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
                    .animation(.easeInOut(duration: 0.3))
                    .padding(.vertical, 2)
            } .task({
                await recipeListViewModel.getRecipess()
            })
        } .frame(maxWidth: .infinity)
            .padding(.top, 10)
    }
}

struct RecipeCell: View {
    
    let recipe: RecipeViewModel
    let isExpanded: Bool
    
    @State var youTubeTapped = false
    @State var recipeSourceTapped = false
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: recipe.photo_url_small) { image in
                    image.resizable()
                        .frame(maxWidth: 100, maxHeight: 100)
                } placeholder: {
                    ProgressView("Loading...")
                        .frame(maxWidth: 100, maxHeight: 100)
                }.padding(.leading, 10)
                
                VStack {
                    Text(recipe.name)
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    Text(recipe.cuisine)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .italic()
                }
                
                
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                // .font(system(size: 22, weight: .regular))
                    .padding(.trailing, 10)
            } .contentShape(Rectangle())
                .navigationTitle("Recipe Fetch")
            
            if isExpanded {
                HStack  {
                    if recipe.sourceURL != nil {
                        Button("Go to recipe") {
                            print("recipeSource tapped")
                            recipeSourceTapped = true

                            openURL(recipe.sourceURL!)
                        }.padding(.leading, 10)
                    }
                    Spacer()
                    if recipe.youTubeURL != nil {
                        Button(action: {
                           youTubeTapped = true
                            openURL(recipe.youTubeURL!)
                           print("tapped youtube button")
                        }){
                                    Image(systemName: "play.fill")
                                .frame(width: 50, height: 50)
                                        .foregroundColor(Color.white)
                                        .background(Color.red)
                                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                                }.buttonStyle(PlainButtonStyle())
                            .frame(maxWidth: 50.0, maxHeight: 50.0, alignment: .trailing)
                            .padding(.trailing, 10)
                    }
                }
            }

        }
        
        

                        

                        
                        
                        
                
            Spacer()
        
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
