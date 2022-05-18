//
//  Worker.swift
//  App Notes
//
//  Created by Sergey on 16.05.2022.
//

import Foundation

protocol WorkerType {
    var session: URLSession { get }
    func fetch()
}

final class Worker: WorkerType {
    var session: URLSession

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func fetch() {
        let task = session.dataTask(with: createURLReComponents()!) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let data = data else { return }
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                let json = try? jsonDecoder.decode([Note].self, from: data)
                print(json![0])
            }
        }
        task.resume()
    }

    private func createURLReComponents() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "firebasestorage.googleapis.com"
        urlComponents.path = "/v0/b/ios-test-ce687.appspot.com/o/Empty.json"
        urlComponents.queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            URLQueryItem(name: "token", value: "d07f7d4a-141e-4ac5-a2d2-cc936d4e6f18")
        ]
        return urlComponents.url
    }
}
