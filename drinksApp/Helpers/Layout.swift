//
//  Layout.swift
//  drinksApp
//
//  Created by Amanda Tavares on 17/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            self.contents = nil
            if let sublayer = sublayers?.first
            {
                //sublayer.name == Constants.contentLayerName
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            //contentLayer.name = Constants.contentLayerName
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
    
    func addShadow() {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.2
        self.shadowRadius = 4
        self.shadowColor = UIColor.gray.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    func addStrongShadow() {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.2
        self.shadowRadius = 7
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
}

extension UITextField {
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

extension UIView{
    func spinner(_ loading: UIActivityIndicatorView){
        loading.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loading)
        loading.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

extension UIImageView {
    func downloadedFrom(url: URL) {
        let loading = UIActivityIndicatorView(style: .white)
        self.spinner(loading)
        loading.startAnimating()
        //contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
                loading.stopAnimating()
            }
            }.resume()
    }
    func downloadedFrom(link: String?) {
        if let link = link {
            guard let url = URL(string: link) else { return }
            downloadedFrom(url: url)
        }
    }
}
