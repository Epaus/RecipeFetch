//
//  RecipeScrollView.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 2/3/25.
//

import SwiftUI
import Combine

struct RecipeScrollView: View {
    @State private var selectedCells: Set<RecipeViewModel> = []
    @StateObject private var recipeListViewModel = RecipeListViewModel()
    @State private var cancellables: Set<AnyCancellable> = []
    @Environment(\.isSearching) var isSearching
    @FocusState private var isSearchBarFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SearchBar(text: $recipeListViewModel.searchTerm, onDismiss: {
                        isSearchBarFocused = false
                    }                    )
                        .focused($isSearchBarFocused)
                        .onSubmit(of:.search){
                            if isSearching {
                                Task { self.recipeListViewModel.loadRecipes() }
                            }
                        }
                    Button("Cancel") {
                        recipeListViewModel.searchTerm = ""
                        isSearchBarFocused = false // Dismiss the keyboard
                    }.foregroundStyle(.teal)
                        .padding(.trailing, 20)

                }
              
                ScrollView {
                    if recipeListViewModel.recipes.count == 0 {
                        Text("No recipes found. Try again later.")
                            .foregroundStyle(.red)
                    }
                    
                    ForEach(recipeListViewModel.recipes, id: \.uuid) { recipe in
                        RecipeCell(recipe: recipe, isExpanded: self.selectedCells.contains(recipe))
                            .modifier(ScrollCell())
                            .onTapGesture {
                                
                                if self.selectedCells.contains(recipe) {
                                    self.selectedCells.remove(recipe)
                                } else {
                                    self.selectedCells.insert(recipe)
                                }
                            }
                            .animation(.easeInOut, value: 0.3)
                            .padding(.vertical, 2)
                    } .task({
                        recipeListViewModel.loadRecipes()
                    })
                    
                } .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                    .toolbar {
                        Menu {
                            Button {
                                recipeListViewModel.sortRecipesByName()
                            } label: {
                                Label("Name", systemImage: "scribble")
                            }
                            Button {
                                recipeListViewModel.sortRecipesByCuisine()
                            } label: {
                                Label("Cuisine", systemImage: "flag.circle")
                            }
                            Button {
                                recipeListViewModel.sortRecipesByHasRecipe()
                            } label: {
                                Label("Includes recipe link", systemImage: "list.clipboard")
                            }
                            Button {
                                recipeListViewModel.sortRecipesByHasVideo()
                            } label: {
                                Label("Includes video link", systemImage: "video.circle")
                            }
                        } label: {
                            Label("Sort", systemImage: "filter")
                                .padding()
                                .cornerRadius(8)
                                .shadow(color: .black, radius: 80, x: 15, y: 15)
                                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.30)
                                .foregroundStyle(.black)
                        }

                        Spacer()
                        
                        
                    }.navigationBarTitle("Recipe Fetch", displayMode: .large)
                    .onChange(of: recipeListViewModel.searchTerm) {
                        if recipeListViewModel.searchTerm.isEmpty && !isSearching {
                            Task { recipeListViewModel.loadRecipes() }
                        }
                    }
                    .alert(isPresented: $recipeListViewModel.showAlert) {
                        Alert(title: Text("Error"), message: Text(recipeListViewModel.alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .toolbarBackground(Color.teal, for: .navigationBar)
                                    .toolbarBackground(.visible, for: .navigationBar)
                
                

            }

        }
    }
}

struct ScrollCell: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            content
            Divider()
        }
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var onDismiss: () -> Void
    
    class Coordinator: NSObject, UISearchBarDelegate {
        let parent: SearchBar

        init(_ parent: SearchBar) {
            self.parent = parent
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                    parent.onDismiss() // Dismiss the keyboard
                }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ searchBar: UISearchBar, context: Context) {
        searchBar.text = text
        
        // Set the placeholder text color
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]) // Change to your desired color
        }
        
        // Set the cancel button color
        searchBar.tintColor = UIColor.white // Change to your desired color
    }
}

struct ContentView: View {
    @State private var searchTerm: String = ""

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchTerm, onDismiss: {
                    
                })
                // Your list or other views that use the search term
            }
            .navigationTitle("Search")
        }
    }
}



#Preview {
    RecipeScrollView()
}
