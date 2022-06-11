//
//  DetailPresentor.swift
//  App Notes
//
//  Created by Sergey on 11.06.2022.
//

import Foundation

final class DetailScenePresenter: DetailPresentationLogic {

    // MARK: - reference
    public weak var viewController: DetailDisplayLogic?

    // MARK: - Prepare data for display
    func presentNotes(response: DetailModel.ShowSelectedNote.Response) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy EEEE HH:mm"
        dateFormater.locale = Locale(identifier: "ru_RU")
        response.note.stringDate = dateFormater.string(from: response.note.date)
        viewController?.displayNote(
            viewModel: DetailModel.ShowSelectedNote.ViewModel(note: response.note)
        )
    }
}
