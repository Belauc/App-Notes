//
//  MainNetworkWorker.swift
//  App Notes
//
//  Created by Sergey on 09.06.2022.
//

import Foundation

final class MainNetworkWorker: MainWorkingLogic {
    var session: URLSession

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    deinit {
        print(#function)
    }

    func fetchData(completion: @escaping (Bool, MainModel.FetchData.Response?) -> Void) {
        guard let url = createURLComponents() else { return }
        let group = DispatchGroup()
        group.enter()
        let task = session.dataTask(with: url) { data, response, error in
            defer { group.leave() }
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
                return
            } else {
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let data = data else {
                    let response = response as? HTTPURLResponse
                    print(self.getErrorMessageFor(statusCode: response?.statusCode ?? 0) ?? "")
                    return
                }
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                do {
                    let notes = try jsonDecoder.decode([Note].self, from: data)
                    notes.forEach { [weak self] note in
                        group.enter()
                        guard let imageUrl = note.userShareIcon else { return }
                        self?.loadImage(from: imageUrl) { data in
                            note.cachedImage = data
                            group.leave()
                        }
                    }
                    completion(true, MainModel.FetchData.Response(notes: notes))
                } catch let error {
                    print(error)
                }
            }
        }
        task.resume()
    }

    private func loadImage(from urlString: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: urlString) else { return }
        do {
            let data = try Data(contentsOf: url)
            completion(data)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    private func createURLComponents() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "firebasestorage.googleapis.com"
        urlComponents.path = "/v0/b/ios-test-ce687.appspot.com/o/lesson8.json"
        urlComponents.queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            URLQueryItem(name: "token", value: "215055df-172d-4b98-95a0-b353caca1424")
        ]
        return urlComponents.url
    }

    private func getErrorMessageFor(statusCode: Int) -> String? {
        if (400...499).contains(statusCode) {
            return "Извините, что то пошло не так. Попробуйте позже. Ошибка: \(statusCode)"
        } else if (500...599).contains(statusCode) {
            return "Извините, сервер временно недоступен. Ошибка: \(statusCode)"
        } else {
            return "Какая то ошибочка... \(statusCode)"
        }
    }
}

