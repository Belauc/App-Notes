//
//  MainPresentor.swift
//  App Notes
//
//  Created by Sergey on 09.06.2022.
//

import Foundation

final class MainScenePresenter: MainPresentationLogic {

    // MARK: - reference
    public weak var viewController: MainDisplayLogic?

    // MARK: - Prepare data for display
    func presentNotes(response: MainModel.FetchData.Response) {
        response.notes.forEach { note in
            note.stringDate = getDataFormater().string(from: note.date)
        }
        let sortedNotes = sortNotes(response)
        viewController?.displayNotes(
            viewModel: MainModel.FetchData.ViewModel(notes: sortedNotes.notes)
        )
    }

    private func getDataFormater() -> DateFormatter {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        dateFormater.locale = Locale(identifier: "ru_RU")
        return dateFormater
    }

    private func sortNotes(_ response: MainModel.FetchData.Response) -> MainModel.FetchData.Response {
        let sortedNotes = response.notes.sorted(by: { $0.date > $1.date })
        var result = response
        result.notes = sortedNotes
        return result
    }
}
