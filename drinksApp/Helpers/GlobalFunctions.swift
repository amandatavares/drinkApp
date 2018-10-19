//
//  GlobalFunctions.swift
//  drinksApp
//
//  Created by Amanda Tavares on 19/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import Foundation
import UIKit

class GlobalFunctions: NSObject {
    public func getDocumentsDirectory() -> String {
        let directoryPath = FileManager.default.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: .userDomainMask).first!
        if !FileManager.default.fileExists(atPath: directoryPath.path) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath.path), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        return directoryPath.path
    }
    public func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyyMMddHHmmss"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
}
