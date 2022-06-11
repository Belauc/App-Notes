//
//  MainProtocols.swift
//  App Notes
//
//  Created by Sergey on 09.06.2022.
//

import Foundation
import UIKit

protocol MainDataStore {
    var noteModel: Note? { get }
}

protocol MainDisplayLogic: AnyObject {
    func displayNotes(viewModel: MainModel.FetchData.ViewModel)
}

protocol UpdateNotesListDelegate: AnyObject {
    func updateNoteList(note: Note)
}

protocol MainBusinessLogic: AnyObject {
    func fetchNotesData()
    func deleteNoteFromList(noteId: MainModel.DeleteNoteFromList.Request)
    func saveNotesToDefaults(notes: MainModel.SaveNotesToDefaults.Request)
    func saveStorageData(note: MainModel.SaveStorageData.Request)
}

protocol MainWorkingLogic {
    var session: URLSession { get }
    func fetchData(completion: @escaping (Bool, MainModel.FetchData.Response?) -> Void)
}

protocol MainPresentationLogic {
    func presentNotes(response: MainModel.FetchData.Response)
}

protocol MainRoutingLogic {
    func navigateToDetailScene()
}
