//
//  MainInteractor.swift
//  App Notes
//
//  Created by Sergey on 09.06.2022.
//

import Foundation

final class MainInteractor: MainDataStore, MainBusinessLogic {

    private(set) var noteModel: Note?
    private var notes: [Note]?

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
                    self?.notes = notes.notes
                    self?.presenter.presentNotes(response: notes)
                }
            }
        }
    }

    func deleteNoteFromList(noteId: MainModel.DeleteNoteFromList.Request) {
        guard !noteId.idNotes.isEmpty else { return }
        noteId.idNotes.forEach { id in
            notes?.removeAll(where: { $0.id == id })
        }
    }

    func saveNotesToDefaults(notes: MainModel.SaveNotesToDefaults.Request) {
        UserSettings.noteModel = notes.notes
    }

    func saveStorageData(note: MainModel.SaveStorageData.Request) {
        noteModel = note.note
    }
}
