//
//  Data+TimeAgoString.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/30/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//
import Foundation
import UIKit

fileprivate let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy"
    return dateFormatter
}()

extension Date {
    func timeAgoString(showAgo: Bool = true, longDate: Bool = true) -> String {
        let seconds = abs(Int(timeIntervalSinceNow))
        let minutes = Int(seconds / 60)
        let hours = Int(minutes / 60)
        let days = Int(hours / 24)

        let agoString: String = showAgo ? " ago" : ""

        if days > 6 {
            return dateFormatter.string(from: self)
        } else if days > 0 {
            return "\(days)d\(agoString)"
        } else if hours > 0 {
            return "\(hours)h\(agoString)"
        } else if minutes > 0 {
            return "\(minutes)m\(agoString)"
        } else {
            return "\(seconds)s\(agoString)"
        }
    }
}
