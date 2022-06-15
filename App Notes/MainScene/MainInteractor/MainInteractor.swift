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

    func fetchNotesData(request: MainModel.FetchData.Request) {
        getDataFromDefaults()
        DispatchQueue.main.async { [weak self] in
            self?.worker.fetchData { [weak self] succses, notes in
                if succses, let notes = notes {
                    self?.notes?.append(contentsOf: notes.notes)
                    self?.presenter.presentNotes(response: MainModel.FetchData.Response(notes: self?.notes ?? []))
                }
            }
        }
    }

    private func getDataFromDefaults() {
        notes = UserSettings.noteModel
    }

    func deleteNoteFromList(request: MainModel.DeleteNoteFromList.Request) {
        guard !request.selectedIds.isEmpty else { return }
        request.selectedIds.forEach { id in
            notes?.removeAll(where: { $0.id == id })
        }
        presenter.updateNotesAfterDeleted(response: MainModel.DeleteNoteFromList.Response(notes: notes ?? []))
    }

    func saveNotesToDefaults(request: MainModel.SaveNotesToDefaults.Request) {
        UserSettings.noteModel = request.notes
    }

    func saveStorageData(request: MainModel.SaveStorageData.Request) {
        noteModel = request.note
    }

    func saveNote(request: MainModel.SaveNewNote.Request) {
        guard !request.note.isEmtpy else { return }
        let noteIndex = notes?.firstIndex(where: { $0.id == request.note.id})
        if let index = noteIndex {
            notes?[index] = request.note
        } else {
            notes?.append(request.note)
        }
        presenter.updateNotesAfterSeved(response: MainModel.SaveNewNote.Response(notes: notes ?? []))
    }

    func clearStorageData() {
        noteModel = Note()
    }
}
