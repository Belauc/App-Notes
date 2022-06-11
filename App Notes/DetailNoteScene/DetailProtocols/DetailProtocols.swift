//
//  DetailProtocols.swift
//  App Notes
//
//  Created by Sergey on 11.06.2022.
//

import Foundation
import UIKit

protocol DetailDataStore { }

protocol DetailDisplayLogic: AnyObject {
    func displayNote(viewModel: DetailModel.ShowSelectedNote.ViewModel)
}

protocol DetailBusinessLogic: AnyObject {
    func presentSeletedNote()
}

protocol DetailPresentationLogic {
    func presentNotes(response: DetailModel.ShowSelectedNote.Response)
}

protocol DetailRoutingLogic {
    func navigateToDetailScene()
}
