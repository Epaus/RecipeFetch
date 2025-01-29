//
//  ContentView.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
   
    @StateObject private var recipeListViewModel = RecipeListViewModel()
    
    var body: some View {
        
        NavigationView {
        
        List(recipeListViewModel.recipes, id: \.uuid) { recipe in
                RecipeCell(recipe: recipe)
        }
        .listStyle(.plain)
        .onAppear {
            recipeListViewModel.getRecipes()
        }
        .navigationTitle("Recipe Fetch")
        }
    }

   
}

struct RecipeCell: View {
    
    let recipe: RecipeViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: recipe.photo_url_small) { image in
                image.resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
            } placeholder: {
                ProgressView("Loading...")
                    .frame(maxWidth: 100, maxHeight: 100)
            }
            
            VStack {
                Text(recipe.name)
                    .fontWeight(.bold)
                Text(recipe.cuisine)
            }
        }
    }
}
