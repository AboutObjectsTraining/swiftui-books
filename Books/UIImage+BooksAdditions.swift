// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit

extension UIImage {
    static var defaultName = "DefaultImage"
    class func named(_ name: String, defaultName: String? = nil) -> UIImage {
        let defaultName = defaultName ?? UIImage.defaultName
        return UIImage(named: name) ?? UIImage(named: defaultName) ?? UIImage(systemName: "nosign")!
    }
}

