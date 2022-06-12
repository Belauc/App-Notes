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

    func navigateToDetailScene(clouser: ((Note) -> Void)?) {
        let detailVC = DetailSceneAssembly.builder(note: dataStore?.noteModel ?? Note(), clouser: clouser)
        viewController?.navigationController?.pushViewController(
            detailVC,
            animated: true
        )
    }
}
