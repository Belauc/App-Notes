//
//  DetailViewControllerMock.swift
//  App NotesTests
//
//  Created by Sergey on 16.06.2022.
//

import Foundation
@testable import App_Notes
import XCTest

class DetailViewControllerMock: DetailDisplayLogic {
    var viewControllerWasCalled = false

    func displayNote(viewModel: DetailModel.ShowSelectedNote.ViewModel) {
        viewControllerWasCalled = true
    }
}
