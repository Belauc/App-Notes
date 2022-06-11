//
//  DetailAssembly.swift
//  App Notes
//
//  Created by Sergey on 11.06.2022.
//

import Foundation
import UIKit

enum DetailSceneAssembly {
    static func builder(note: Note) -> UIViewController {

        let presenter = DetailScenePresenter()
        let router = DetailRouter()

        let interactor = DetailInteractor(
            presenter: presenter,
            noteModel: note
        )

        let viewController = DetailSceneViewController(
            router: router,
            interactor: interactor
        )

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
