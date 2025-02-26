//
//  MockNetworkManager.swift
//  RecipeFetchTests
//
//  Created by Estelle Paus on 2/19/25.
//

import Foundation
import Combine

class MockNetworkManager {
    
    var recipes = [RecipeViewModel]()
    
    @Published private var cancellables: Set<AnyCancellable> = []
    
    func fetchRecipes(url: URL?) -> AnyPublisher<[RecipeViewModel], Error>  {
        
        let recipes = RecipeList.correctData
       
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
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher() 
    }
    
  
  
  
}
