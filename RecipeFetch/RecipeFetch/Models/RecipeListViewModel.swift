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
 
    private var networkManager = {
        #if TEST
        return MockNetworkManager()
        #else
        return NetworkManager()
        #endif
    }
    
    init() {
        $searchTerm
            //.debounce(for: 0.25, scheduler: DispatchQueue.main)
            .map { searchTerm -> Void  in
                Task { await self.initialLoad() }
            }
            .sink {}
            .store(in: &cancellables)
    }
    
    func initialLoad() async {
        
        var recipeUrl: URL?
        #if TEST
        recipeUrl = nil
        #else
        recipeUrl = URLS.recipeUrl
        #endif
        
        networkManager().fetchRecipes(url: recipeUrl)
            .sink { data  in
                self.filterRecipes(searchTerm: self.searchTerm)
            } receiveValue: { recipes in
                self.recipes = recipes
            }.store(in: &cancellables)
    }
    
    func loadRecipes(url: URL) async {
        networkManager().fetchRecipes(url: url)
            .sink { data  in
                self.filterRecipes(searchTerm: self.searchTerm)
            } receiveValue: { recipes in
                self.recipes = recipes
            }.store(in: &cancellables)
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
