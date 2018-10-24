//
//  ImageDownloader.swift
//  drinksApp
//
//  Created by Amanda Tavares on 23/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    var url: URL
    
    var image:UIImage?
    
    // weak var delegate:LogoDownloaderDelegate?
    // SEE NOTE BELOW
    var delegate: ImageDownloaderDelegate?
    
    init(imageURL:URL) {
        self.url = imageURL
    }
    
    func downloadImage() {
        // Start the image download task asynchronously by submitting
        // it to the default background queue; this task is submitted
        // and DispatchQueue.global returns immediately.
        
                URLSession.shared.dataTask(with: self.url) {
                    data, response, error in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let image = UIImage(data: data)
                        else { return }
                    DispatchQueue.main.async() {
                        self.image = image
                        self.didDownloadImage()
                        //loading.stopAnimating()
                    }
                }.resume()
            
        } // end DispatchQueue.global
   
    
    // Since this class has a reference to the delegate,
    // "at the appropriate time [it] sends a message to" the delegate.
    // Finishing the logo download is definitely
    // the appropriate time.
    func didDownloadImage() {
        self.delegate?.didFinishDownloading(self)
    }

 }
