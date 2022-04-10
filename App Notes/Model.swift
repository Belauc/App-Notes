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
    var date: String?
    var isEmtpy: Bool {
        guard (title ?? "").isEmpty && (body ?? "").isEmpty && (date ?? "").isEmpty else {
            return false
        }
        return true
    }

    init(title: String, body: String, date: String) {
        self.title = title
        self.body = body
        self.date = date
    }

    override init() { }

    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(body, forKey: "body")
        coder.encode(date, forKey: "date")
    }

    required init?(coder: NSCoder) {
        title = coder.decodeObject(forKey: "title") as? String
        body = coder.decodeObject(forKey: "body") as? String
        date = coder.decodeObject(forKey: "date") as? String
    }
}
