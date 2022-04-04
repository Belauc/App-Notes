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
    var date: Date?
    var isEmtpy: Bool {
            guard title != nil, body != nil else {
                return true
            }
            return false
    }

    init(title: String, body: String, date: Date) {
        self.title = title
        self.body = body
        self.date = date
    }

    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(body, forKey: "body")
        coder.encode(date, forKey: "date")
    }

    required init?(coder: NSCoder) {
        title = coder.decodeObject(forKey: "title") as? String
        body = coder.decodeObject(forKey: "body") as? String
        body = coder.decodeObject(forKey: "date") as? String
    }
}
