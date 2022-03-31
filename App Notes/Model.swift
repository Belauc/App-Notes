//
//  Model.swift
//  App Notes
//
//  Created by Sergey on 27.03.2022.
//

import Foundation

class Note: NSObject, NSCoding {
    var title: String?
    var body: String?

    init(title: String, body: String) {
        self.title = title
        self.body = body
    }

    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(body, forKey: "body")
    }

    required init?(coder: NSCoder) {
        title = coder.decodeObject(forKey: "title") as? String
        body = coder.decodeObject(forKey: "body") as? String
    }
}

enum State {
    case editEnable
    case editDisable
    var nextState: State {
        switch self {
        case .editEnable:
            return .editDisable
        case .editDisable:
            return .editEnable
        }
    }
}
