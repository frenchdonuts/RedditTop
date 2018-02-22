//
//  PaginatorTests.swift
//  RedditTopTests
//
//  Created by Alexander Kharevich on 2/22/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import XCTest

@testable import RedditTop

class PaginatorTests: XCTestCase {
    var paginator: Paginator<Link>!

    override func tearDown() {
        paginator = nil
        super.tearDown()
    }

    override func setUp() {
        super.setUp()
        paginator = Paginator<Link>()
    }

    func testThatPaginatorIsNotEmptyInitially() {
        XCTAssertEqual(paginator.isEmpty, false)
    }

    func testThatPaginatorIsNotEmptyDataIsAvailable() {
        let genExp = expectation(description: "Paginator is not empty after reset, it contains proper number of items, it has more available items if data available on the server")
        paginator.onUpdatedHandler = {
            (numberOfNewItems) -> Void in
            XCTAssertEqual(numberOfNewItems, 1)
            XCTAssertFalse(self.paginator.isEmpty)
            XCTAssertTrue(self.paginator.moreAvailable)
            genExp.fulfill()
        }

        paginator.updateRequest = {
            (after: String?, updateHandler: @escaping Paginator<Link>.completionHandler) -> Void in
            let mockLink = PaginatorTests.createMockLink()
            updateHandler([mockLink], Cursors(after: "mock_after"), nil)
        }
        paginator.reset()

        waitForExpectations(timeout: 10.0) { (error) in
            guard let error = error else { return }
            XCTFail("waitForExpectationsWithTimeout errored: \(error)")
        }
    }

    func testThatPaginatorIsEmptyDataIsNotAvailable() {
        let genExp = expectation(description: "Paginator is empty after reset, it contains no items, it has no more available items if data is not available on the server")
        paginator.onUpdatedHandler = {
            (numberOfNewItems) -> Void in
            XCTAssertEqual(numberOfNewItems, 0)
            XCTAssertTrue(self.paginator.isEmpty)
            XCTAssertFalse(self.paginator.moreAvailable)
            genExp.fulfill()
        }

        paginator.updateRequest = {
            (after: String?, updateHandler: @escaping Paginator<Link>.completionHandler) -> Void in
            updateHandler([], Cursors(after: nil), nil)
        }
        paginator.reset()

        waitForExpectations(timeout: 10.0) { (error) in
            guard let error = error else { return }
            XCTFail("waitForExpectationsWithTimeout errored: \(error)")
        }
    }

    func testThatPaginatorFetchItemsDataAvailable() {
        let genExp = expectation(description: "Paginator is not empty after fetch more items, it contains proper number of items, it has more available items if data available on the server")
        paginator.cursors = Cursors(after: "mock_after_1", before: nil)
        paginator.items = [PaginatorTests.createMockLink()]
        paginator.onUpdatedHandler = {
            (numberOfNewItems) -> Void in
            XCTAssertEqual(numberOfNewItems, 1)
            XCTAssertFalse(self.paginator.isEmpty)
            XCTAssertEqual(self.paginator.items.count, 2)
            XCTAssertTrue(self.paginator.moreAvailable)
            genExp.fulfill()
        }

        paginator.updateRequest = {
            (after: String?, updateHandler: @escaping Paginator<Link>.completionHandler) -> Void in
            let mockLink = PaginatorTests.createMockLink()
            updateHandler([mockLink], Cursors(after: "mock_after_2"), nil)
        }
        paginator.fetchItems()

        waitForExpectations(timeout: 10.0) { (error) in
            guard let error = error else { return }
            XCTFail("waitForExpectationsWithTimeout errored: \(error)")
        }
    }


    func testThatPaginatorFetchItemsDataIsNotAvailable() {
        let genExp = expectation(description: "Paginator is not empty after fetch more items, it contains proper number of items, it has more available items if more data is not available on the server")
        paginator.cursors = Cursors(after: "mock_after_1", before: nil)
        paginator.items = [PaginatorTests.createMockLink()]
        paginator.onUpdatedHandler = {
            (numberOfNewItems) -> Void in
            XCTAssertEqual(numberOfNewItems, 0)
            XCTAssertFalse(self.paginator.isEmpty)
            XCTAssertEqual(self.paginator.items.count, 1)
            XCTAssertFalse(self.paginator.moreAvailable)
            genExp.fulfill()
        }

        paginator.updateRequest = {
            (after: String?, updateHandler: @escaping Paginator<Link>.completionHandler) -> Void in
            updateHandler([], Cursors(after: nil), nil)
        }
        paginator.fetchItems()

        waitForExpectations(timeout: 10.0) { (error) in
            guard let error = error else { return }
            XCTFail("waitForExpectationsWithTimeout errored: \(error)")
        }
    }
}

extension PaginatorTests {
    class func createMockLink() ->Link {
        return Link(created: Double(Date().timeIntervalSinceReferenceDate), author: "MockAuthor", title: "MockTitle", numComments: 999, thumbnail: "MockThumbnail", url: "MockUrl", preview: nil)
    }
}
