//
//  MainProtocols.swift
//  App Notes
//
//  Created by Sergey on 09.06.2022.
//

import Foundation
import UIKit

protocol MainDataStore {
    var noteModels: MainModel.FetchData.Response? { get }
    var noteId: UUID? { get }
}

protocol MainDisplayLogic: AnyObject {
    func displayNotes(viewModel: MainModel.FetchData.ViewModel)
}

protocol MainBusinessLogic: AnyObject {
    func fetchNotesData()
    func deleteNoteFromList(noteId: MainModel.DeleteNoteFromList.Request)
    func saveNotesToDefaults(notes: MainModel.SaveNotesToDefaults.Request)
}

protocol MainWorkingLogic {
    var session: URLSession { get }
    func fetchData(completion: @escaping (Bool, MainModel.FetchData.Response?) -> Void)
//    func loadImage(from urlString: String, completion: @escaping (Data) -> Void)
//    func createURLComponents() -> URL?
//    func getErrorMessageFor(statusCode: Int) -> String?
}

protocol MainPresentationLogic {
    func presentNotes(response: MainModel.FetchData.Response)
}

protocol MainRoutingLogic {
    func navigateToDetailScene()
}
