//
//  PresentorTests.swift
//  App NotesTests
//
//  Created by Sergey on 15.06.2022.
//

import XCTest
@testable import App_Notes

class PresenterTests: XCTestCase {
    var presenter: MainScenePresenter!

    var viewControllerMock: MainViewControllerMock!

    override func setUp() {
        super.setUp()
        viewControllerMock = MainViewControllerMock()
        presenter = MainScenePresenter()
        presenter.viewController = viewControllerMock
    }

    override func tearDown() {
        viewControllerMock = nil
        presenter = nil
        super.tearDown()
    }

    func testPresentNotes() {
        presenter.presentNotes(response: .init(notes: []))
        XCTAssert(viewControllerMock.viewControllerWasCalled, "VC dont call")
    }

    func testUpdateNotesAfterDeleted() {
        presenter.updateNotesAfterDeleted(response: .init(notes: []))
        XCTAssert(viewControllerMock.viewControllerWasCalled, "VC dont call")
    }

    func testUpdateNotesAfterSeved() {
        presenter.updateNotesAfterSeved(response: .init(notes: []))
        XCTAssert(viewControllerMock.viewControllerWasCalled, "VC dont call")
    }
}
