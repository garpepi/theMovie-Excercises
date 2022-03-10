//
//  Network.swift
//  theMovie
//
//  Created by Garpepi Aotearoa on 10/03/22.
//

import UIKit

// MARK: - NetworkRequest
protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func execute(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        print(url)
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) -> Void in
            guard let data = data, let value = self?.decode(data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(value)
            }
        }
        task.resume()
    }
}

// MARK: - APIRequest
class APIRequest<Resource: APIResource> {
    let resource: Resource
    let apiType: typeAPI
    init(resource: Resource, apiType: typeAPI) {
        self.resource = resource
        self.apiType = apiType
    }
}

extension APIRequest: NetworkRequest {
    func decode(_ data: Data) -> [Resource.ModelType]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        print("decode")
        switch self.apiType {
        case .genres:
            let wrapper = try? decoder.decode(Wrapper<Resource.ModelType>.self, from: data)
            return wrapper?.gen
        case .movieReview:
            let wrapper = try? decoder.decode(WrapperMovieReview<Resource.ModelType>.self, from: data)
            return wrapper?.reviews
        default:
            let wrapper = try? decoder.decode(WrapperMovie<Resource.ModelType>.self, from: data)
            return wrapper?.results
        }

    }

    func execute(withCompletion completion: @escaping ([Resource.ModelType]?) -> Void) {
        print("execute")
        load(resource.url, withCompletion: completion)
    }
}

// MARK: - APIResource
protocol APIResource {
    associatedtype ModelType: Decodable
    var methodPath: String { get }
    var filter: String? { get }
    var page: Int? { get }
}

extension APIResource {
    var url: URL {
        var components = URLComponents(string: "https://api.themoviedb.org/")!
        components.path = methodPath
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "84c5865f836f88313e9df0d2a05566f5"),
            URLQueryItem(name: "language", value: "en-US")
        ]
        if let filter = filter {
            components.queryItems?.append(URLQueryItem(name: "with_genres", value: filter))
        }
        if let page = page {
            components.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
        }
        return components.url!
    }
}


