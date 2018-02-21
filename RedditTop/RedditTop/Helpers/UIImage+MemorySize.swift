//
//  UIImage+MemorySize.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 2/20/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

extension UIImage {
    var memorySize: Int {
        guard let cgImage = self.cgImage else { return 0 }
        return cgImage.height * cgImage.bytesPerRow
    }
}
