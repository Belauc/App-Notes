//
//  PresentorTests.swift
//  App NotesTests
//
//  Created by Sergey on 15.06.2022.
//

import XCTest
@testable import App_Notes

class PresentorTests: XCTestCase {
    var presentor: MainScenePresenter!

    var viewControllerMock: MainViewControllerMock!

    override func setUp() {
        super.setUp()
        viewControllerMock = MainViewControllerMock()
        presentor = MainScenePresenter()
        presentor.viewController = viewControllerMock
    }

    override func tearDown() {
        viewControllerMock = nil
        presentor = nil
        super.tearDown()
    }

    func testPresentNotes() {
        presentor.presentNotes(response: .init(notes: []))
        XCTAssert(viewControllerMock.viewControllerWasCalled, "VC dont call")
    }

    func testUpdateNotesAfterDeleted() {
        presentor.updateNotesAfterDeleted(response: .init(notes: []))
        XCTAssert(viewControllerMock.viewControllerWasCalled, "VC dont call")
    }

    func testUpdateNotesAfterSeved() {
        presentor.updateNotesAfterSeved(response: .init(notes: []))
        XCTAssert(viewControllerMock.viewControllerWasCalled, "VC dont call")
    }
}
