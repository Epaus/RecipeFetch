//
//  RecipeListViewModelTests.swift
//  RecipeFetchTests
//
//  Created by Estelle Paus on 2/19/25.
//

import XCTest


final class RecipeListViewModelTests: XCTestCase {
    
    var viewModel: RecipeListViewModel!

    func setUpWithError() async throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func test_viewModel_exists() async throws {
        viewModel = await RecipeListViewModel()
        XCTAssertNotNil(viewModel)
    }
    
    func test_loadRecipes() async {
        let expectation = XCTestExpectation(description: "Load recipes")
        viewModel = await RecipeListViewModel()
    
        try? await viewModel.initialLoad()
        let count = await viewModel.recipes.count
        if count > 1 {
            expectation.fulfill()
        }
        
        XCTAssertTrue(count > 0)
        await fulfillment(of: [expectation], enforceOrder: true)
       
    }
    
    func test_sortRecipesByCuisine() async {
    
        viewModel = await RecipeListViewModel()
    
        try? await viewModel.initialLoad()

        var firstRecipeCuisine = await viewModel.recipes.first?.cuisine  ?? ""
        XCTAssertTrue(firstRecipeCuisine == "Malaysian")
        
        await viewModel.sortRecipesByCuisine()
        firstRecipeCuisine = await viewModel.recipes.first?.cuisine ?? "Malaysian"
        XCTAssertTrue(firstRecipeCuisine == "American")
    }
    
    func test_sortRecipesByName() async {
        viewModel = await RecipeListViewModel()
    
        try? await viewModel.initialLoad()
        var firstRecipeName = await viewModel.recipes.first?.name  ?? ""
        XCTAssertTrue(firstRecipeName == "Apam Balik")
       
        await viewModel.sortRecipesByCuisine()
        firstRecipeName = await viewModel.recipes.first?.name ?? ""
        XCTAssertTrue(firstRecipeName == "Choc Chip Pecan Pie")
        
        await viewModel.sortRecipesByName()
        firstRecipeName = await viewModel.recipes.first?.name ?? ""
        let lastRecipeName = await viewModel.recipes.last?.name ?? ""
       
        XCTAssertTrue((firstRecipeName == "Apam Balik") && (lastRecipeName == "Choc Chip Pecan Pie"))
    }
    
    func test_sortByHasRecipe() async {
        viewModel = await RecipeListViewModel()
    
        try? await viewModel.initialLoad()
       
        let firstRecipeName = await viewModel.recipes.first?.name  ?? ""
        XCTAssertTrue(firstRecipeName == "Apam Balik")
        
        var firstRecipeHasRecipe = await viewModel.recipes.first?.source_url != ""
        var lastRecipeHasRecipe = await viewModel.recipes.last?.source_url != ""
        XCTAssertTrue(firstRecipeHasRecipe)
        XCTAssertTrue(lastRecipeHasRecipe)
        
        await viewModel.sortRecipesByHasRecipe()
        
        firstRecipeHasRecipe = await viewModel.recipes.first?.source_url != ""
        lastRecipeHasRecipe = await viewModel.recipes.last?.source_url != ""
        
        XCTAssertTrue(firstRecipeHasRecipe)
        XCTAssertFalse(lastRecipeHasRecipe)
    }
    
    func test_sortByHasVideo() async {
        viewModel = await RecipeListViewModel()
    
        try? await viewModel.initialLoad()
        let firstRecipeName = await viewModel.recipes.first?.name  ?? ""
       
        XCTAssertTrue(firstRecipeName == "Apam Balik")
        
        var firstRecipeHasVideo = await viewModel.recipes.first?.youtube_url != ""
        var lastRecipeHasVideo = await viewModel.recipes.last?.youtube_url != ""
        XCTAssertTrue(firstRecipeHasVideo)
        XCTAssertTrue(lastRecipeHasVideo)
        
        try? await viewModel.sortRecipesByHasRecipe()
        
        firstRecipeHasVideo = await viewModel.recipes.first?.source_url != ""
        lastRecipeHasVideo = await viewModel.recipes.last?.source_url != ""
        
        XCTAssertTrue(firstRecipeHasVideo)
        XCTAssertFalse(lastRecipeHasVideo)
    }
    
    func test_searchTerm_wholeWord_filterRecipes() async {
        viewModel = await RecipeListViewModel()
        try? await viewModel.initialLoad()
        
        let searchTerm = "apple"
        await viewModel.filterRecipes(searchTerm: searchTerm)
        
        let count = await viewModel.recipes.count
        XCTAssertTrue(count == 2)
    }
    
    func test_emptyString_FilterRemovesNoRecipes() async {
        viewModel = await RecipeListViewModel()
        try? await viewModel.initialLoad()
        
        let searchTerm = ""
        await viewModel.filterRecipes(searchTerm: searchTerm)
        
        let count = await viewModel.recipes.count
        XCTAssertTrue(count == 4)
    }
    
    func test_searchTermString_filterRecipes() async {
        viewModel = await RecipeListViewModel()
        try? await viewModel.initialLoad()
        
        let searchTerm = "ip"
        await viewModel.filterRecipes(searchTerm: searchTerm)
        
        let count = await viewModel.recipes.count
        XCTAssertTrue(count == 2)
    }
    
    func test_searchStringNotFound_filterRecipes() async {
        viewModel = await RecipeListViewModel()
        try? await viewModel.initialLoad()
        
        let searchTerm = "zz"
        await viewModel.filterRecipes(searchTerm: searchTerm)
        
        let count = await viewModel.recipes.count
        XCTAssertTrue(count == 0)
    }

   

}
