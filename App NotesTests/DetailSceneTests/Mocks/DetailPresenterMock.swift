//
//  DetailPresentorMock.swift
//  App NotesTests
//
//  Created by Sergey on 16.06.2022.
//

import Foundation
@testable import App_Notes
import XCTest

class DetailPresenterMock: DetailPresentationLogic {
    var presentorWasCalled = false
    var expectation: XCTestExpectation?

    func presentNotes(response: DetailModel.ShowSelectedNote.Response) {
        presentorWasCalled = true
        expectation?.fulfill()
    }
}
