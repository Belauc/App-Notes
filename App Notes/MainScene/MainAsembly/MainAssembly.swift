//
//  MainAssembly.swift
//  App Notes
//
//  Created by Sergey on 09.06.2022.
//

import Foundation
import UIKit

enum MainSceneAssembly {
    static func builder() -> UIViewController {

        let worker = MainNetworkWorker()
        let presenter = MainScenePresenter()
        let router = MainRouter()

        let interactor = MainInteractor(
            presenter: presenter,
            worker: worker
        )

        let viewController = MainSceneViewController(
            interactor: interactor,
            router: router
        )

        router.viewController = viewController
        presenter.viewController = viewController
        router.dataStore = interactor

        return viewController
    }
}
