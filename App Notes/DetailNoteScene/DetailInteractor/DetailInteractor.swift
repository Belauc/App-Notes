//
//  DetailInteractor.swift
//  App Notes
//
//  Created by Sergey on 11.06.2022.
//

import Foundation

final class DetailInteractor: DetailBusinessLogic {
    private let presenter: DetailPresentationLogic
    private let noteModel: Note

    init(
        presenter: DetailPresentationLogic,
        noteModel: Note
    ) {
        self.presenter = presenter
        self.noteModel = noteModel
    }

    func presentSeletedNote() {
        presenter.presentNotes(response: DetailModel.ShowSelectedNote.Response(note: noteModel))
    }
}
