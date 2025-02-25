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
    
    var body: some View {
        NavigationView {
            
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
                            .background(Color.pink)
                            .cornerRadius(8)
                            .shadow(color: .black, radius: 30, x: 15, y: 15)
                            .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.30)
                    }

                    Spacer()
                    
                }.navigationBarTitle("Recipe Fetch", displayMode: .large)
                .searchable(text: $recipeListViewModel.searchTerm)
                .onSubmit(of:.search){
                    if isSearching {
                        Task { self.recipeListViewModel.loadRecipes() }
                    }
                }
                .onChange(of: recipeListViewModel.searchTerm) {
                    if recipeListViewModel.searchTerm.isEmpty && !isSearching {
                        Task { recipeListViewModel.loadRecipes() }
                    }
                }
                .alert(isPresented: $recipeListViewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text(recipeListViewModel.alertMessage), dismissButton: .default(Text("OK")))
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


#Preview {
    RecipeScrollView()
}
