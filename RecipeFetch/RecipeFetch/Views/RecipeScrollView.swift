//
//  RecipeScrollView.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 2/3/25.
//

import SwiftUI

struct RecipeScrollView: View {
    @State private var selectedCells: Set<RecipeViewModel> = []
    @StateObject private var recipeListViewModel = RecipeListViewModel()
   
    var body: some View {
        var recipes = recipeListViewModel.recipes
        NavigationView {
            ScrollView {
                ForEach(recipes, id: \.uuid) { recipe in
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
                    await recipeListViewModel.getRecipess()
                })
            } .frame(maxWidth: .infinity)
                .padding(.top, 10)

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
