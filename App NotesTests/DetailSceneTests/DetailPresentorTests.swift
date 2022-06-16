//
//  DetailPresentorTests.swift
//  App NotesTests
//
//  Created by Sergey on 15.06.2022.
//

import XCTest
@testable import App_Notes

class DetailPresentorTests: XCTestCase {
    var sut: DetailScenePresenter!

    var viewControllerMock: DetailViewControllerMock!

    override func setUp() {
        super.setUp()
        viewControllerMock = DetailViewControllerMock()
        sut = DetailScenePresenter()
        sut.viewController = viewControllerMock
    }

    override func tearDown() {
        viewControllerMock = nil
        sut = nil
        super.tearDown()
    }

    func testPresentNotes() {
        sut.presentNotes(response: .init(note: Note()))
        XCTAssert(viewControllerMock.viewControllerWasCalled)
    }

}
