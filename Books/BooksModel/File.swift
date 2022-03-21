// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

public struct File {
    let name: String
    let type: String
    let bundle: Bundle
    let bundleUrl: URL?
    let documentUrl: URL
    
    var existsInDocumentsDirectory: Bool {
        FileManager.default.fileExists(atPath: documentUrl.path)
    }
    
    public init(name: String, type: String, bundle: Bundle = Bundle.main) {
        self.name = name
        self.type = type
        self.bundle = bundle
        self.bundleUrl = bundle.url(forResource: name, withExtension: type)
        
        documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(name)
            .appendingPathExtension(type)
    }
    
    func copyFromMainBundleToDocumentsDirectory() {
        guard let bundleUrl = bundleUrl else {
            fatalError("file \(name).\(type) missing in bundle \(self.bundleUrl!).")
        }
        
        do {
            if (!existsInDocumentsDirectory) {
                try FileManager.default.copyItem(at: bundleUrl, to: documentUrl)
            }
        } catch {
            fatalError("Unable to copy file \(name).\(type) to Documents directory.")
        }
    }
    
    func remove() {
        try? FileManager.default.removeItem(at: documentUrl)
    }
}
