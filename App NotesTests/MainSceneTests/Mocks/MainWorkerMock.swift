//
//  MainWorkerMock.swift
//  App NotesTests
//
//  Created by Sergey on 15.06.2022.
//

import Foundation
@testable import App_Notes

class MainWorkerMock: MainWorkingLogic {
    var workerWasCalled = false
    var result = true

    func fetchData(completion: @escaping (Bool, MainModel.FetchData.Response?) -> Void) {
        workerWasCalled = true
        completion(result, MainModel.FetchData.Response(notes: [Note()]))
    }
}
