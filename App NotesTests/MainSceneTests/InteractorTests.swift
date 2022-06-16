//
//  InteractorTests.swift
//  App NotesTests
//
//  Created by Sergey on 15.06.2022.
//

import XCTest
@testable import App_Notes

class InteractorTests: XCTestCase {
    var sut: (MainDataStore & MainBusinessLogic)!

    var presenterMock: MainPresentorMock!
    var workerMock: MainWorkerMock!
    var userDefaultsMock: MainUserDefaultsMock!

    override func setUp() {
        super.setUp()
        presenterMock = MainPresentorMock()
        workerMock = MainWorkerMock()
        userDefaultsMock = MainUserDefaultsMock()
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

    func testSaveNotesToDefaults() {
        let testNote = Note(title: "TestTitle", body: "testBody", date: Date())
        sut.saveNotesToDefaults(request: .init(notes: [testNote]))
        XCTAssertFalse(UserSettings.noteModel.contains(testNote), "noteModel ids is not empty")
    }

    func testSaveStorageData() {
        let testNote = Note(title: "TestTitle", body: "testBody", date: Date())
        sut.saveStorageData(request: .init(note: testNote))
        XCTAssertFalse(sut.noteModel!.isEmtpy, "DataStorage is empty or nil")
    }

    func testClearStorageData() {
        sut.clearStorageData()
        XCTAssert(sut.noteModel!.isEmtpy, "DataStorage is not empty or nil")
    }

}
