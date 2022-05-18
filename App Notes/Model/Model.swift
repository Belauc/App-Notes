//
//  Model.swift
//  App Notes
//
//  Created by Sergey on 27.03.2022.
//

import Foundation

class Note: NSObject, Decodable, NSCoding {
    var id: UUID = UUID()
    var title: String?
    var body: String?
    var date: String?
    var dt: Date?
    var fullDateTime: String?
    var isEmtpy: Bool {
        guard (title ?? "").isEmpty && (body ?? "").isEmpty else {
            return false
        }
        return true
    }
    enum CodingKeys: String, CodingKey {
        case title = "header"
        case body = "text"
    }

    init(title: String, body: String, date: String) {
        self.title = title
        self.body = body
        self.date = date
        self.id = UUID()
    }

    override init() {}

    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(body, forKey: "body")
        coder.encode(date, forKey: "date")
        coder.encode(fullDateTime, forKey: "fullDate")
    }

    required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as? UUID ?? UUID()
        title = coder.decodeObject(forKey: "title") as? String
        body = coder.decodeObject(forKey: "body") as? String
        date = coder.decodeObject(forKey: "date") as? String
        fullDateTime = coder.decodeObject(forKey: "fullDate") as? String
    }
}
