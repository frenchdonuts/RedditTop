//
//  UIImageView+ImageDownloader.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/29/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

private struct AssociatedKeys {
    static var downloadingTask = "downloadingTask"
}

extension UIImageView {
    static let cache = BasicInMemoryImageCache()

    private var downloadingTask: URLSessionDownloadTask? {
        get {
            guard let task = objc_getAssociatedObject(self, &AssociatedKeys.downloadingTask) as? URLSessionDownloadTask else {
                return nil
            }
            return task
        }

        set(value) {
            objc_setAssociatedObject(self,&AssociatedKeys.downloadingTask, value,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setImage(with url: URL, placeHolder: UIImage?) {
        cancelDownload()
        image = placeHolder
        if let cachedImage = UIImageView.cache[url] {
            image = cachedImage
        }
        downloadingTask = ImageDownloader.downloadImage(with: url) { [weak self] (downloadedImage, error) in
            guard error == nil else { return }
            guard let downloadedImage = downloadedImage else { return }
            UIImageView.cache[url] = downloadedImage
            self?.image = downloadedImage
            self?.downloadingTask = nil
        }
    }

    func cancelDownload() {
        guard downloadingTask != nil else { return }
        downloadingTask?.cancel()
        downloadingTask = nil
    }
}
