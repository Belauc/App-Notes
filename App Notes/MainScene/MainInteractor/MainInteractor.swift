//
//  MainInteractor.swift
//  App Notes
//
//  Created by Sergey on 09.06.2022.
//

import Foundation

final class MainInteractor: MainDataStore, MainBusinessLogic {
    private(set) var noteId: UUID?
    private(set) var noteModels: MainModel.FetchData.Response?

    private let presenter: MainPresentationLogic
    private let worker: MainWorkingLogic
    private let userSettings = UserSettings()

    init(
        presenter: MainPresentationLogic,
        worker: MainWorkingLogic
    ) {
        self.presenter = presenter
        self.worker = worker
    }

    func fetchNotesData() {
        DispatchQueue.main.async { [weak self] in
            self?.worker.fetchData { [weak self] succses, notes in
                if succses, let notes = notes {
                    self?.noteModels = notes
                    self?.presenter.presentNotes(response: notes)
                }
            }
        }
    }

    func deleteNoteFromList(noteId: MainModel.DeleteNoteFromList.Request) {
        guard !noteId.idNotes.isEmpty else { return }
        noteId.idNotes.forEach { id in
            noteModels?.notes.removeAll(where: { $0.id == id })
        }
    }

    func saveNotesToDefaults(notes: MainModel.SaveNotesToDefaults.Request) {
        UserSettings.noteModel = notes.notes
    }
}
