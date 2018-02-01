//
//  RedditListingsAPIService.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/28/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

class RedditListingsAPIService {
    enum ListingPeriod: String {
        case hour = "hour"
        case day = "day"
        case week = "week"
        case month = "month"
        case year = "year"
        case all = "all"
    }
    enum ListingShowType: String {
        case none = "none"
        case all = "all"
    }
    static let path = "/top.json"
    static let defaultLimit = 25
    static let maximumLimit = 100

    static func request(url: String, before: String?, after: String?, limit: Int = defaultLimit, t:ListingPeriod = .day) -> URLRequest? {
        var urlString = url
        var query:[String] = []
        query.append("sort=top")
        query.append("limit=\(limit)")
        query.append("t=\(t.rawValue)")
        if let before = before {
            query.append("before=\(before)")
        }
        if let after = after {
            query.append("after=\(after)")
        }
        urlString.append("?\(query.joined(separator: "&"))")

        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    static func getTop(before: String?, after: String?, limit: Int = defaultLimit, t:ListingPeriod = .day, completion: @escaping ((Thing?, Error?)->Void)) {
        let urlString = RedditAPIClient.basePath + RedditListingsAPIService.path
        guard let request = RedditListingsAPIService.request(url: urlString, before: before, after: after) else {
            print("Can not create request")
            completion(nil, nil)
            return
        }
        let dataTask = RedditAPIClient.session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error: did not receive data")
                completion(nil, error)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                completion(nil, nil)
                return
            }
            do {
                let thing = try JSONDecoder().decode(Thing.self, from:responseData)
                completion(thing, nil)
            } catch {
                completion(nil, error)
                return
            }
        }
        dataTask.resume()
    }
}
