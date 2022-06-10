//
//  MainRouter.swift
//  App Notes
//
//  Created by Sergey on 09.06.2022.
//

import Foundation
import UIKit

final class MainRouter: MainRoutingLogic {
    // MARK: - Reference

    weak var viewController: UIViewController?

    // MARK: - Data store
    var dataStore: MainDataStore?

    func navigateToDetailScene() {
        let vc = SearchSceneAssembly.builder()
            viewController?.navigationController?.pushViewController(
              vc,
              animated: true
            )
    }
}
