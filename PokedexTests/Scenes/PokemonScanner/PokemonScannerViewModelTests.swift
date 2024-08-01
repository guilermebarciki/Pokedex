//
//  PokemonScannerViewModelTests.swift
//  PokedexTests
//
//  Created by Guilerme Barciki   on 01/08/24.
//

import XCTest
import Vision
@testable import Pokedex

class PokemonScannerViewModelTests: XCTestCase {
    
    var sut: PokemonScannerViewModel!
    var mockRequestProvider: MockClassificationRequestProvider!
    var mockDataPersistence: MockPokemonDataPersistence!
    var mockImageProcessor: MockImageProcessor!
    var mockRequestHandlerFactory: MockImageRequestHandlerFactory!
    var mockDelegate: MockPokemonScannerViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        mockRequestProvider = MockClassificationRequestProvider()
        mockDataPersistence = MockPokemonDataPersistence()
        mockImageProcessor = MockImageProcessor()
        mockRequestHandlerFactory = MockImageRequestHandlerFactory()
        mockDelegate = MockPokemonScannerViewModelDelegate()
        sut = PokemonScannerViewModel(delegate: mockDelegate,
                                      requestProvider: mockRequestProvider,
                                      dataPersistence: mockDataPersistence,
                                      imageProcessor: mockImageProcessor,
                                      visionRequestHandlerFactory: mockRequestHandlerFactory)
    }
    
    override func tearDown() {
        sut = nil
        mockRequestProvider = nil
        mockDataPersistence = nil
        mockImageProcessor = nil
        mockRequestHandlerFactory = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testUpdateClassifications_withValidImage_shouldCallDidFinishClassification() {
        // Given
        let expectation = self.expectation(description: "Classification finished")
        mockDelegate.expectation = expectation
        let classification = VNClassificationObservation.makeMockObservation(identifier: "Pikachu", confidence: 0.95)
        let request = makeRequest()
        mockRequestProvider.classificationRequest = request
        mockImageProcessor.ciImage = CIImage()
        let mockRequestHandler = MockImageRequestHandler()
        mockRequestHandler.testResults = [classification]
        mockRequestHandlerFactory.mockRequestHandler = mockRequestHandler
        
        
        // When
        sut.updateClassifications(for: UIImage())
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(self.mockDelegate.didFinishClassificationCalled)
            XCTAssertEqual(self.mockDelegate.classification?.identifier, "Pikachu")
            XCTAssertEqual(self.mockDelegate.classification?.confidence, 0.95)
        }
    }
    
    func testUpdateClassifications_withImageProcessingFailed_shouldCallDidFailClassification() {
        // Given
        mockRequestProvider.classificationRequest = makeRequest()
        mockImageProcessor.ciImage = nil
        
        // When
        let image = UIImage()
        sut.updateClassifications(for: image)
        
        // Then
        XCTAssertTrue(mockDelegate.didFailClassificationCalled)
        XCTAssertEqual(mockDelegate.error, .imageProcessingFailed)
    }
    
    func testUpdateClassifications_withModelLoadingFailed_shouldCallDidFailClassification() {
        // Given
        mockRequestProvider.shouldFailToCreateRequest = true
        
        // When
        let image = UIImage()
        sut.updateClassifications(for: image)
        
        // Then
        XCTAssertTrue(mockDelegate.didFailClassificationCalled)
        XCTAssertEqual(mockDelegate.error, .modelLoadingFailed)
    }
    
    func testUpdateClassifications_withNothingRecognized_shouldCallDidFailClassification() {
        // Given
        let expectation = self.expectation(description: "Nothing Recognized")
        mockDelegate.expectation = expectation
        let request = makeRequest()
        mockRequestProvider.classificationRequest = request
        mockImageProcessor.ciImage = CIImage()
        let mockRequestHandler = MockImageRequestHandler()
        mockRequestHandler.testResults = []
        mockRequestHandlerFactory.mockRequestHandler = mockRequestHandler
        
        // When
        let image = UIImage()
        sut.updateClassifications(for: image)
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(self.mockDelegate.didFailClassificationCalled)
            XCTAssertEqual(self.mockDelegate.error, .nothingRecognized)
        }
    }
    
    func testUpdateClassifications_withClassificationFailed_shouldCallDidFailClassification() {
        // Given
        let expectation = self.expectation(description: "Classification finished")
        mockDelegate.expectation = expectation
        let model = try! VNCoreMLModel(for: PokemonClassifier2().model)
        let request = VNCoreMLRequest(model: model)
        mockRequestProvider.classificationRequest = request
        mockImageProcessor.ciImage = CIImage()
        let mockRequestHandler = MockImageRequestHandler()
        mockRequestHandler.shouldThrowError = true
        mockRequestHandlerFactory.mockRequestHandler = mockRequestHandler
        
        // When
        let image = UIImage()
        sut.updateClassifications(for: image)
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(self.mockDelegate.didFailClassificationCalled)
            XCTAssertEqual(self.mockDelegate.error, .classificationFailed("The operation couldn’t be completed. (test error 1.)"))
        }
    }
    
    func testSavePokemon_shouldSavePokemonName() {
           // Given
           let pokemonName = "Pikachu"
           
           // When
           sut.savePokemon(pokemonName: pokemonName)
           
           // Then
           XCTAssertTrue(mockDataPersistence.isPokemonNameSaved(pokemonName))
       }
    
    private func makeRequest() -> VNCoreMLRequest  {
        let model = try! VNCoreMLModel(for: PokemonClassifier2().model)
        let request = VNCoreMLRequest(model: model)
        return request
    }
    
}
