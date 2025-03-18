//
//  RecipeListViewModel.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class RecipeListViewModel: ObservableObject {
    
    @Published var recipes = [RecipeViewModel]()
    @Published private var cancellables: Set<AnyCancellable> = []
    @Published var searchTerm: String = ""
    @Published var isLoading = true
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    let title = "Recipe Fetch"
    let progressViewTitle = "Loading recipes..."
    let noRecipesFound = "No recipes found. Try again later."
    let menuName = "Name"
    let menuNameImage = "scribble"
    let menuCuisine = "Cuisine"
    let menuCuisineImage = "flag.circle"
    let menuIncludesLink = "Includes recipe link"
    let menuIncludesLinkImage = "list.clipboard"
    let menuIncludesVideoLink = "Includes video link"
    let menuIncludesVideoLinkImage = "video.circle"
    let sortItem = "Sort"
    let sortImage = "filter"
    var errorTitle = "Error"
    let okTitle = "OK"
    let appColor = Color.teal
    let searchPlaceholderText = "Search"
    let cancelSearchText = "Cancel"
    
 
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
                Task { try? await self.initialLoad() }
            }
            .sink {}
            .store(in: &cancellables)
    }
    
  
    
    func loadRecipes() {
        Task {
                    do {
                        try await initialLoad() // Call your async method here
                    } catch {
                        //alertMessage = "Failed to load recipes: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
    }
    
    func initialLoad() async throws {
        
        var recipeUrl: URL?
#if TEST
        recipeUrl = nil
#else
        recipeUrl = URLS.recipeUrl
#endif
        
        networkManager().fetchRecipes(url: recipeUrl)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if let recipeError = error as? RecipeError {
                        switch recipeError {
                        case .missingField(let incompleteRecipe):
                            self.alertMessage = "There is a problem.\n \(incompleteRecipe).\n Please try again later."
                        }
                    }
                    self.showAlert = true
                }
            }, receiveValue: { recipes in
                self.recipes = recipes
                self.filterRecipes(searchTerm: self.searchTerm)
                self.isLoading = false
            })
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
