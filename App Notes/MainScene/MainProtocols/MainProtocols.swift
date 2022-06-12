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
    func updateNotesListAfterDeleted(viewModel: MainModel.DeleteNoteFromList.ViewModel)
    func updateNotesListAfterAdded(viewModel: MainModel.SaveNewNote.ViewModel)
}

protocol UpdateNotesListClouser: AnyObject {
    func updateNoteList(note: Note)
}

protocol MainBusinessLogic: AnyObject {
    func fetchNotesData()
    func deleteNoteFromList(selectedIds: MainModel.DeleteNoteFromList.Request)
    func saveNotesToDefaults(notes: MainModel.SaveNotesToDefaults.Request)
    func saveStorageData(note: MainModel.SaveStorageData.Request)
    func clearStorageData()
    func saveNote(note: MainModel.SaveNewNote.Request)
}

protocol MainWorkingLogic {
    var session: URLSession { get }
    func fetchData(completion: @escaping (Bool, MainModel.FetchData.Response?) -> Void)
}

protocol MainPresentationLogic {
    func presentNotes(response: MainModel.FetchData.Response)
    func updateNotesAfterDeleted(response: MainModel.DeleteNoteFromList.Response)
    func updateNotesAfterSeved(response: MainModel.SaveNewNote.Response)
}

protocol MainRoutingLogic {
    func navigateToDetailScene(clouser: ((Note) -> Void)?)
}
