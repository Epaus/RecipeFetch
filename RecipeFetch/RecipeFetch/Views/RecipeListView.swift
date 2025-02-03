//
//  ContentView.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import SwiftUI
import SwiftData
/*
struct RecipeListView: View {
   
    @StateObject private var recipeListViewModel = RecipeListViewModel()
    
    var body: some View {
        
        NavigationView {
        
        List(recipeListViewModel.recipes, id: \.uuid) { recipe in
                RecipeCell(recipe: recipe)
        }
        .listStyle(.plain)
        .task({
            await recipeListViewModel.getRecipess()
        })
        .onAppear {
            
        }
        .navigationTitle("Recipe Fetch")
        }
    }

   
}

struct RecipeCell: View {
    
    let recipe: RecipeViewModel
    @State var youTubeTapped = false
    @State var recipeSourceTapped = false
   
    var body: some View {
      
        HStack(alignment: .top) {
                AsyncImage(url: recipe.photo_url_small) { image in
                    image.resizable()
                        .frame(maxWidth: 100, maxHeight: 100)
                } placeholder: {
                    ProgressView("Loading...")
                        .frame(maxWidth: 100, maxHeight: 100)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.name)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .lineLimit(nil)
                    Text(recipe.cuisine)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .italic()
                    
                    if recipe.sourceURL != nil {
                        Button("Go to recipe") {
                            print("recipeSource tapped")
                            recipeSourceTapped = true
                            youTubeTapped = false
                        }
                        if recipeSourceTapped {
                            Link("Recipe Source", destination: recipe.sourceURL!)
                        }
                    }
                    
                }
                
                if recipe.youTubeURL != nil {
                    Button(action: {
                       youTubeTapped = true
                       recipeSourceTapped = false
                       print("tapped youtube button")
                    }){
                                Image(systemName: "play.fill")
                            .frame(width: 50, height: 50)
                                    .foregroundColor(Color.white)
                                    .background(Color.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                            }.buttonStyle(PlainButtonStyle())
                        .frame(maxWidth: 50.0, maxHeight: 50.0, alignment: .trailing)
                        
                    
                    if youTubeTapped {
                        Link("", destination: recipe.youTubeURL!)
                        
                    }
                }
                
                
                
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

 
    }
    
}

*/
