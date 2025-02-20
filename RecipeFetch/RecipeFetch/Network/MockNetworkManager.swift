//
//  MockNetworkManager.swift
//  RecipeFetchTests
//
//  Created by Estelle Paus on 2/19/25.
//

import Foundation
import Combine

class MockNetworkManager {
    
    @Published private var cancellables: Set<AnyCancellable> = []
    
    func fetchRecipes(url: URL?) -> AnyPublisher<[RecipeViewModel], Error>  {
         print("fetchingRecipes with MockNetworkManager")
        
         let recipe1 = RecipeViewModel(recipe: Recipe(cuisine: "Malaysian", name: "Apam Balik", photo_url_large: nil, photo_url_small: nil, uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", source_url: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtube_url: "https://www.youtube.com/watch?v=6R8ffRRJcrg"))
         
        let recipe2 = RecipeViewModel(recipe: Recipe(cuisine: "British", name: "Apple & Blackberry Crumble" , photo_url_large: nil, photo_url_small: nil, uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f", source_url: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble", youtube_url: nil))
         
        let recipe3 = RecipeViewModel(recipe: Recipe(cuisine: "British", name: "Apple Frangipan Tart" , photo_url_large: nil, photo_url_small: nil, uuid: "74f6d4eb-da50-4901-94d1-deae2d8af1d1", source_url: nil, youtube_url: "https://www.youtube.com/watch?v=rp8Slv4INLk"))
         
        let recipe4 = RecipeViewModel(recipe: Recipe(cuisine: "American", name: "Choc Chip Pecan Pie" , photo_url_large: nil, photo_url_small: nil, uuid: "74f6d4eb-da50-4901-94d1-deae2d8af1d1", source_url: "https://www.bbcgoodfood.com/recipes/choc-chip-pecan-pie", youtube_url: "https://www.youtube.com/watch?v=fDpoT0jvg4Y"))
         
        let recipes: [RecipeViewModel] = [recipe1, recipe2, recipe3, recipe4]
       
         let publisher = mockRecipesPublisher(recipes: recipes)
         publisher.sink(
             receiveCompletion: { completion in
                 switch completion {
                 case .finished:
                     print("Finished successfully")
                 case .failure(let error):
                     print("Error: \(error)")
                 }
             },
             receiveValue: { receivedRecipes in
                 print("Received recipes: \(receivedRecipes)")
             }
         )
         .store(in: &cancellables)
         return publisher
     }
     
    func mockRecipesPublisher(recipes: [RecipeViewModel]) -> AnyPublisher<[RecipeViewModel], Error> {
        return Just(recipes)
            .setFailureType(to: Error.self) // Set the failure type to Error
            .eraseToAnyPublisher() // Erase to AnyPublisher
    }
  
  
}
