//
//  SplashViewModelTests.swift
//  IMDBCloneTests
//
//  Created by Mina on 04/02/2023.
//

import XCTest
@testable import IMDBClone

class SplashViewModelTests: XCTestCase {
    private var sut: SplashViewModel!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func setUp() {
        super.setUp()
        sut = SplashViewModel(apiService: MockNetworkManager(fileName: "MoviesResponse"), databaseManager: MockDatabaseManager(fileName: "MoviesResponse"))
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSut_whenInitCalled_networkManagerIsSet() {
        XCTAssertNotNil(sut.apiService)
    }
    
    func testSut_whenInitCalled_databaseManagerIsSet() {
        XCTAssertNotNil(sut.databaseManager)
    }
    
    func testSut_whenFetchMoviesFromApi_retriveMoviesSuccessfully() {
        sut.fetchMoviesFromApi(appDelegate: appDelegate)
        XCTAssertNotEqual(sut.state, CachedState.failed)
    }
    
    func testSut_whenFetchMoviesFromApi_moviesUnfilled() {
        sut = SplashViewModel(apiService: MockNetworkManager(fileName: "Error"))
        sut.fetchMoviesFromApi(appDelegate: appDelegate)
        XCTAssertEqual(sut.state, CachedState.failed)
    }
    
    func testSut_whenFetchMoviesFromApi_emptyArray() {
        sut = SplashViewModel(apiService: MockNetworkManager(fileName: "EmptyResponse"))
        sut.fetchMoviesFromApi(appDelegate: appDelegate)
        XCTAssertEqual(sut.state, CachedState.failed)
    }
    
    func testSut_whenFetchMoviesFromApi_saveMoviesToCoreData() {
        sut.fetchMoviesFromApi(appDelegate: appDelegate)
        XCTAssertEqual(sut.state, CachedState.success)
    }
}
