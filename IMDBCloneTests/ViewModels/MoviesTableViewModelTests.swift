//
//  MoviesTableViewModelTests.swift
//  IMDBCloneTests
//
//  Created by Mina on 04/02/2023.
//

import XCTest
@testable import IMDBClone

class MoviesTableViewModelTests: XCTestCase {
    private var sut: MoviesTableViewModel!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func setUp() {
        super.setUp()
        sut = MoviesTableViewModel(databaseManager: MockDatabaseManager(fileName: "MoviesResponse"))
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSut_whenInitCalled_databaseManagerIsSet() {
        XCTAssertNotNil(sut.databaseManager)
    }
    
    func testSut_whenFetchMovies_retriveMoviesSuccessfully() {
        sut.fetchMovies(appDelegate: appDelegate)
        XCTAssertEqual(sut.state, State.populated)
    }
    
    func testSut_whenFetchMovies_moviesUnfilled() {
        sut = MoviesTableViewModel(databaseManager: MockDatabaseManager(fileName: "Error"))
        sut.fetchMovies(appDelegate: appDelegate)
        XCTAssertEqual(sut.state, State.error)
    }
    
    func testSut_whenFetchMovies_emptyArray() {
        sut = MoviesTableViewModel(databaseManager: MockDatabaseManager(fileName: "EmptyResponse"))
        sut.fetchMovies(appDelegate: appDelegate)
        XCTAssertEqual(sut.state, State.empty)
    }
    
    func testSut_whenFetchMovies_retriveTenMoviesSuccessfully() {
        sut.fetchMovies(appDelegate: appDelegate)
        XCTAssertEqual(sut.paginationMovies.count, 10)
    }
    
    func testSut_setPaginationMovies_appendTenMoviesToArray() {
        sut.fetchMovies(appDelegate: appDelegate)
        sut.setPaginationMovies()
        XCTAssertEqual(sut.paginationMovies.count, 20)
    }
    
    func testSut_setPaginationMovies_appendLessThanLimitMoviesToArray() {
        sut.fetchMovies(appDelegate: appDelegate)
        sut.setPaginationMovies()
        sut.setPaginationMovies()
        XCTAssertEqual(sut.paginationMovies.count, 23)
    }
    
    func testSut_setPaginationMovies_overSizeOfMoviesArray() {
        sut.fetchMovies(appDelegate: appDelegate)
        sut.setPaginationMovies()
        sut.setPaginationMovies()
        sut.setPaginationMovies()
        XCTAssertEqual(sut.paginationMovies.count, 23)
    }
    
    func testSut_whensortMoviesByYear_retriveMoviesSuccessfully() {
        sut.fetchMovies(appDelegate: appDelegate)
        sut.sortMoviesByYear()
        XCTAssertEqual(sut.paginationMovies.count, 10)
        XCTAssertEqual(sut.state, State.populated)
    }
    
    func testSut_whensortMoviesByRate_retriveMoviesSuccessfully() {
        sut.fetchMovies(appDelegate: appDelegate)
        sut.sortMoviesByRate()
        XCTAssertEqual(sut.paginationMovies.count, 10)
        XCTAssertEqual(sut.state, State.populated)
    }
}
