//
//  Model.swift
//  App Notes
//
//  Created by Sergey on 27.03.2022.
//

import Foundation

class Note: NSObject, NSCoding {
    static var count: Int = 0
    let id: Int
    var title: String?
    var body: String?
    var date: String?
    var fullDateTime: String?
    var isEmtpy: Bool {
        guard (title ?? "").isEmpty && (body ?? "").isEmpty else {
            return false
        }
        return true
    }

    init(title: String, body: String, date: String) {
        self.title = title
        self.body = body
        self.date = date
        self.id = Note.count
        Note.count += 1
    }

    override init() {
        self.id = Note.count
        Note.count += 1
    }

    deinit {
        Note.count -= 1
    }

    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(body, forKey: "body")
        coder.encode(date, forKey: "date")
    }

    required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as? Int ?? 0
        title = coder.decodeObject(forKey: "title") as? String
        body = coder.decodeObject(forKey: "body") as? String
        date = coder.decodeObject(forKey: "date") as? String
    }
}
