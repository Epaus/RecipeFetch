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
    
    private func loadRecipes() async {
        NetworkManager().newFetchRecipes(url: URLS.recipeUrl)
            .sink { data  in
            } receiveValue: { recipes in
                self.recipeListViewModel.recipes = recipes
            }.store(in: &cancellables)

    }
   
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                ForEach(recipeListViewModel.recipes, id: \.uuid) { recipe in
                    RecipeCell(recipe: recipe, isExpanded: self.selectedCells.contains(recipe))
                        .modifier(ScrollCell())
                        .onTapGesture {
                        
                            if self.selectedCells.contains(recipe) {
                               
                                self.selectedCells.forEach( { cell in
                                    print(cell.name)
                                })
                                print("selectedCells.count = \(self.selectedCells.count)")
                                self.selectedCells.remove(recipe)
                            } else {
                               
                                self.selectedCells.insert(recipe)
                                self.selectedCells.forEach( { cell in
                                    print(cell.name)
                                })
                                print("selectedCells.count = \(self.selectedCells.count)")
                            }
                        }
                        .animation(.easeInOut, value: 0.3)
                        .padding(.vertical, 2)
                } .task({
                    await loadRecipes()
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
                            print("sorted by cuisine button tapped")
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
                    
                }
            
        } .navigationBarTitle("Recipe Fetch", displayMode: .large)
        
        
    }
}

struct RecipeCell: View {
    
    let recipe: RecipeViewModel
    let isExpanded: Bool
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack {
            HStack (alignment: .top) {
                AsyncImage(url: recipe.photo_url_small) { image in
                    image.resizable()
                        .frame(maxWidth: 100, maxHeight: 100)
                } placeholder: {
                    ProgressView("Loading...")
                        .frame(maxWidth: 100, maxHeight: 100)
                }.padding(.leading, 10)
                
                VStack  {
                    Text(recipe.name)
                        .font(.headline)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8, maxHeight: UIScreen.main.bounds.height * 0.1, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    
                    Text(recipe.cuisine)
                        .frame(maxWidth: .infinity, maxHeight: 20.0, alignment: .leading)
                        .italic()
                    Spacer()
                }
                
                
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .padding(.trailing, 16)
            } .contentShape(Rectangle())
                .navigationTitle("Recipe Fetch")
            
            if isExpanded {
                Spacer()
                HStack(spacing: UIScreen.main.bounds.width * 0.30) {
                    let hasRecipeSource = recipe.sourceURL != nil
                    if hasRecipeSource {
                        Button("Go to recipe") {
                            openURL(recipe.sourceURL!)
                        }.padding(.leading, 10)
                    } else {
                        Button("Go to recipe") {
                        }.disabled(!hasRecipeSource)
                    }
                    
                    if recipe.youTubeURL != nil {
                        Button(action: {
                            openURL(recipe.youTubeURL!)
                        }){
                            PlayVideoImage()
                        }.buttonStyle(PlainButtonStyle())
                            .frame(maxWidth: 50.0, maxHeight: 50.0, alignment: .trailing)
                            .padding(.trailing, 10)
                    } else {
                        Button(action: {}){
                            PlayVideoImage()
                        }.buttonStyle(PlainButtonStyle())
                            .frame(maxWidth: 50.0, maxHeight: 50.0, alignment: .trailing)
                            .padding(.trailing, 10).disabled(true)
                    }
                    
                }
                
            }
        }
    }
}

struct PlayVideoImage: View {
    var body: some View {
        Image(systemName: "play.fill")
            .frame(width: 55, height: 35)
            .foregroundColor(Color.white)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
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
