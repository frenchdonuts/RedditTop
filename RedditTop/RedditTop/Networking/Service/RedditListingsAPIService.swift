//
//  RedditListingsAPIService.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/28/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import Foundation

class RedditListingsAPIService {
    func getTop() {

    }
}

class RedditTopRequest {
    enum ListingType: String {
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
    static let defaultLimit = 25
    static let maximumLimit = 100
    var limit: Int = defaultLimit {
        didSet {
            limit = min(max(0, limit), RedditListingsAPIService.maximumLimit)
        }
    }
    var t: ListingType
    var show: ListingShowType?
}
