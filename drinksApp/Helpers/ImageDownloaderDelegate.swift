//
//  ImageDownloaderDelegate.swift
//  drinksApp
//
//  Created by Amanda Tavares on 23/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDownloaderDelegate {
    // Classes that adopt this protocol MUST define
    // this method -- and hopefully do something in
    // that definition.
    func didFinishDownloading(_ sender: ImageDownloader)
}
