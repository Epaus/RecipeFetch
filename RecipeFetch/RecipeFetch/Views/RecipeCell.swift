//
//  RecipeCell.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 2/24/25.
//

import SwiftUI

struct RecipeCell: View {
    
    let recipe: RecipeViewModel
    let isExpanded: Bool
    
    @Environment(\.openURL) private var openURL
   
    var body: some View {
        VStack {
            HStack (alignment: .top) {
                if recipe.smallPhotoString != "" {
                    AsyncCachedImage(url: recipe.photo_url_small) { image in
                                image
                                    .resizable()
                                    .frame(maxWidth: 100, maxHeight: 100)
                            } placeholder: {
                                ProgressView("Loading...")
                                .frame(maxWidth: 100, maxHeight: 100)
                            }.padding(.leading, 10)
                } else {
                    Image(uiImage: UIImage(named: "noRecipeImage.png") ?? UIImage()) .resizable()
                                   .frame(maxWidth: 100, maxHeight: 100)
                }
                
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




#Preview {
    let recipe1 = RecipeViewModel(recipe: Recipe(cuisine: "Malaysian", name: "Apam Balik", photo_url_large: nil, photo_url_small: nil, uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", source_url: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtube_url: "https://www.youtube.com/watch?v=6R8ffRRJcrg"))
    let recipe2 = RecipeViewModel(recipe: Recipe(cuisine: "British", name: "Apple & Blackberry Crumble" , photo_url_large: nil, photo_url_small: nil, uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f", source_url: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble", youtube_url: nil))
    RecipeCell(recipe: recipe1, isExpanded: true).frame(width: UIScreen.main.bounds.width * 0.90, height: 200.0)
    RecipeCell(recipe: recipe2, isExpanded: false).frame(width: UIScreen.main.bounds.width * 0.90, height: 100.0)
    
}
