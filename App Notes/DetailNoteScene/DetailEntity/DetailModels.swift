//
//  DetailModels.swift
//  App Notes
//
//  Created by Sergey on 11.06.2022.
//

import Foundation

enum DetailModel {
    enum ShowSelectedNote {
        struct Request {}
        struct Response {
            var note = Note()
        }
        struct ViewModel {
            var note = Note()
        }
    }

    enum SaveNote {
        struct Request {
            var note = Note()
        }
        struct Response { }
        struct ViewModel { }
    }
}
