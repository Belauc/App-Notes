//
//  MainPresentorMock.swift
//  App NotesTests
//
//  Created by Sergey on 15.06.2022.
//

import Foundation
@testable import App_Notes
import XCTest

class MainPresentorMock: MainPresentationLogic {
    var presentorWasCalled = false
    var expectation: XCTestExpectation?

    func presentNotes(response: MainModel.FetchData.Response) {
        presentorWasCalled = true
        expectation?.fulfill()
    }

    func updateNotesAfterDeleted(response: MainModel.DeleteNoteFromList.Response) {
        presentorWasCalled = true
        expectation?.fulfill()
    }

    func updateNotesAfterSeved(response: MainModel.SaveNewNote.Response) {
        presentorWasCalled = true
        expectation?.fulfill()
    }
}
