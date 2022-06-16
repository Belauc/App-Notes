//
//  App NotesTests
//
//  Created by Sergey on 15.06.2022.
//

import XCTest
@testable import App_Notes

class DetailInteractorTests: XCTestCase {
    var sut: DetailBusinessLogic!

    var presenterMock: DetailPresenterMock!

    override func setUp() {
        super.setUp()
        presenterMock = DetailPresenterMock()
        sut = DetailInteractor(presenter: presenterMock, noteModel: Note())
    }

    override func tearDown() {
        presenterMock = nil
        sut = nil
        super.tearDown()
    }

    func testPresentSeletedNote() {
        sut.presentSeletedNote(request: .init())
        XCTAssert(presenterMock.presentorWasCalled)
    }
}
