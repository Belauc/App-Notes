//
//  MainViewCintrollerMock.swift
//  App NotesTests
//
//  Created by Sergey on 16.06.2022.
//

import Foundation
@testable import App_Notes
import XCTest

class MainViewControllerMock: MainDisplayLogic {
    var viewControllerWasCalled = false
    var expectation: XCTestExpectation?

    func displayNotes(viewModel: MainModel.FetchData.ViewModel) {
        viewControllerWasCalled = true
    }

    func updateNotesListAfterDeleted(viewModel: MainModel.DeleteNoteFromList.ViewModel) {
        viewControllerWasCalled = true
    }

    func updateNotesListAfterAdded(viewModel: MainModel.SaveNewNote.ViewModel) {
        viewControllerWasCalled = true
    }
}
