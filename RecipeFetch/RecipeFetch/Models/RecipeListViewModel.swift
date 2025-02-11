//
//  RecipeListViewModel.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import Foundation
import Combine

@MainActor
class RecipeListViewModel: ObservableObject {
    
    @Published var recipes = [RecipeViewModel]()
    @Published private var cancellables: Set<AnyCancellable> = []
    @Published var searchTerm: String = ""
    @Published var isSearching = false
   
    
    var filteredRecipes: [RecipeViewModel] = []
    
    init() {
        $searchTerm
            //.debounce(for: 0.25, scheduler: DispatchQueue.main)
            .map { searchTerm -> Void  in
                //self.isSearching = true
                self.filterRecipes(searchTerm: searchTerm)
            }
            .sink {}
            .store(in: &cancellables)
    }
    
    func sortRecipesByCuisine()  {
        self.recipes = recipes.sorted { $0.cuisine < $1.cuisine }
    }
    
    func sortRecipesByName() {
        self.recipes = recipes.sorted { $0.name < $1.name}
    }
    
    func sortRecipesByHasRecipe() {
        self.recipes = recipes.sorted { $0.source_url != "" && $1.source_url == ""}
    }
    
    func sortRecipesByHasVideo() {
        self.recipes =  recipes.sorted { $0.youtube_url != "" && $1.youtube_url == ""}
    }
    
    func filterRecipes(searchTerm: String) {
        self.recipes = searchTerm.isEmpty ? self.recipes : recipes.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
    }
}
