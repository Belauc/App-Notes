//
//  InteractorTests.swift
//  App NotesTests
//
//  Created by Sergey on 15.06.2022.
//

import XCTest
@testable import App_Notes

class InteractorTests: XCTestCase {
    var sut: MainBusinessLogic!

    var presenterMock: MainPresentorMock!
    var workerMock: MainWorkerMock!

    override func setUp() {
        super.setUp()
        presenterMock = MainPresentorMock()
        workerMock = MainWorkerMock()
        sut = MainInteractor(presenter: presenterMock, worker: workerMock)
    }

    override func tearDown() {
        presenterMock = nil
        workerMock = nil
        sut = nil
        super.tearDown()
    }

    func testFetchNotesData() {
        let expectation = expectation(description: "Fetch data error")
        presenterMock.expectation = expectation
        sut.fetchNotesData(request: .init())
        waitForExpectations(timeout: 1) { _ in
            XCTAssert(self.presenterMock.presentorWasCalled)
        }
    }

    func testDeleteNoteFromList() {
        sut.deleteNoteFromList(request: .init(selectedIds: [UUID()]))
        XCTAssert(presenterMock.presentorWasCalled, "Selected ids is empty")
    }

    func testSaveNote() {
        let testNote = Note(title: "TestTitle", body: "testBody", date: Date())
        sut.saveNote(request: .init(note: testNote))
        XCTAssert(presenterMock.presentorWasCalled, "Note is empty or nil")
    }
}
