//
//  UIImageView+ImageDownloader.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/29/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

private var downloadingTaskHandle: UInt8 = 0
private var activityIndicatorViewHandle: UInt8 = 0

extension UIImageView {
    static let imageCache = ImageCache()
    static var taskCache = Cache<URL,URLSessionDownloadTask>()
    private var activityIndicatorView: UIActivityIndicatorView? {
        get {
            guard let activityIndicator = objc_getAssociatedObject(self, &activityIndicatorViewHandle) as? UIActivityIndicatorView else {
                return nil
            }
            return activityIndicator
        }

        set(value) {
            objc_setAssociatedObject(self,&activityIndicatorViewHandle, value,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var downloadingTask: URLSessionDownloadTask? {
        get {
            guard let task = objc_getAssociatedObject(self, &downloadingTaskHandle) as? URLSessionDownloadTask else {
                return nil
            }
            return task
        }

        set(value) {
            objc_setAssociatedObject(self,&downloadingTaskHandle, value,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private func setupActivityIndicatorIfNeeded() {
        guard self.activityIndicatorView == nil else { return }
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidesWhenStopped = true
        self.activityIndicatorView = activityIndicatorView
    }

    func setImage(with url: URL, placeHolder: UIImage?, completion: ((UIImage?)->Void)? = nil) {
        cancelDownload()
        if let cachedImage = UIImageView.imageCache[url] {
            image = cachedImage
            completion?(cachedImage)
            return
        }
        setupActivityIndicatorIfNeeded()
        backgroundColor = UIColor.black
        activityIndicatorView?.startAnimating()
        if let cachedTask = UIImageView.taskCache[url] {
            downloadingTask = cachedTask
            downloadingTask?.resume()
            UIImageView.taskCache[url] = nil
            return
        }
        downloadingTask = ImageDownloader.downloadImage(with: url) { [weak self] (downloadedImage, error) in
            DispatchQueue.main.async {
                self?.activityIndicatorView?.stopAnimating()
                UIImageView.imageCache[url] = downloadedImage
                self?.downloadingTask = nil
                self?.backgroundColor = UIColor.clear
                guard error == nil, let downloadedImage = downloadedImage else {
                    self?.image = placeHolder
                    completion?(nil)
                    return
                }
                self?.image = downloadedImage
                completion?(downloadedImage)
            }
        }
    }

    func cancelDownload() {
        activityIndicatorView?.stopAnimating()
        backgroundColor = UIColor.clear
        guard let downloadingTask = self.downloadingTask else { return }
        self.downloadingTask = nil
        guard let url = downloadingTask.originalRequest?.url else {
            return
        }
        downloadingTask.suspend()
        UIImageView.taskCache[url] = downloadingTask
    }
}
