//
//  DetailRouter.swift
//  App Notes
//
//  Created by Sergey on 11.06.2022.
//

import Foundation
import UIKit

final class DetailRouter: DetailRoutingLogic {
    // MARK: - Reference

    weak var viewController: UIViewController?

    // MARK: - Data store
    var dataStore: MainDataStore?

    func navigateToDetailScene() {
//        let vc = DetailSceneAssembly.builder(note: Note(), clouser: (Note) -> Void)
//        viewController?.navigationController?.pushViewController(
//            vc,
//            animated: true
//        )
    }
}
