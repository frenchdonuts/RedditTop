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

    var onTapImageHandler: (()->Void)?
    private var tapRecognizer: UITapGestureRecognizer?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestureRecognizer()
        reset()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }

    @objc private func onTapImageAction() {
        onTapImageHandler?()
    }

    private func setupGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImageAction))
        tapRecognizer.isEnabled = false
        thumbnailImageView.isUserInteractionEnabled = true
        thumbnailImageView.addGestureRecognizer(tapRecognizer)
        self.tapRecognizer = tapRecognizer
    }

    private func reset() {
        onTapImageHandler = nil
        thumbnailImageView.cancelDownload()
        thumbnailImageView.image = nil
        titleLabel.text = nil
        commentsLabel.text = nil
        authorLabel.text = nil
        timeAgoLabel.text = nil
        tapRecognizer?.isEnabled = false
    }

    func setup(for link:Link) {
        switch link.thumbnail {
        case "self","default":
            thumbnailImageView.image = UIImage(named:"selfPlaceholder")
        case "image":
            thumbnailImageView.image = UIImage(named:"imagePlaceholder")
            tapRecognizer?.isEnabled = true
            break
        default:
            if let str = link.thumbnail.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                let path = URL(string: str) {
                thumbnailImageView.setImage(with: path, placeHolder: UIImage(named:"selfPlaceholder"))
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
