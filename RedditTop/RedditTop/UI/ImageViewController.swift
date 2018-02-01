//
//  ImageViewController.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/31/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit
import AssetsLibrary

class ImageViewController: UIViewController {
    var imageUrl: URL?
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func onCloseButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onDownloadButtonAction(_ sender: Any) {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadButton.isHidden = true
        loadImage()
    }

    private func loadImage() {
        guard let imageUrl = self.imageUrl else { return }
        imageView.setImage(with: imageUrl, placeHolder: nil) { [weak self] (image) in
            guard image != nil else { return }
            self?.downloadButton.isHidden = false
        }
    }
}
