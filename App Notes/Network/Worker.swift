//
//  Worker.swift
//  App Notes
//
//  Created by Sergey on 16.05.2022.
//

import Foundation

protocol WorkerType {
    var session: URLSession { get }
    func fetch(complition: @escaping (Bool, [Note]?) -> Void)
}

final class Worker: WorkerType {
    var session: URLSession

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func fetch(complition: @escaping (Bool, [Note]?) -> Void) {
        let task = session.dataTask(with: createURLReComponents()!) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                complition(false, nil)
                return
            } else {
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let data = data else {
                    let response = response as? HTTPURLResponse
                    print("Ошибка, код ответа сервера: \(response?.statusCode ?? 0)")
                    return
                }
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                do {
                    let notes = try jsonDecoder.decode([Note].self, from: data)
                    complition(true, notes)
                } catch let error {
                    print(error)
                }
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
