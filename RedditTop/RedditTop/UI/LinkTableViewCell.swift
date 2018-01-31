//
//  LinkTableViewCell.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/29/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        resetUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetUI()
    }

    private func resetUI() {
        thumbnailImageView.cancelDownload()
        thumbnailImageView.image = nil
        titleLabel.text = nil
        commentsLabel.text = nil
        authorLabel.text = nil
        timeAgoLabel.text = nil
    }

    func setup(for link:Link) {
        var urlString = link.thumbnail
        switch urlString {
        case "self":
            thumbnailImageView.image = UIImage(named:"selfPlaceholder")
        case "default":
            thumbnailImageView.image = UIImage(named:"imagePlaceholder")
        case "image":
            urlString = link.url
            fallthrough
        default:
            if let str = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                let path = URL(string: str) {
                thumbnailImageView.setImage(with: path, placeHolder: UIImage(named:"imagePlaceholder"))
            }
            break
        }

        titleLabel.text = link.title
        authorLabel.text = link.author
        commentsLabel.text = "\(link.numComments) comments"
        let date = Date(timeIntervalSince1970: link.created)
        timeAgoLabel.text = date.timeAgoString()
    }
}
