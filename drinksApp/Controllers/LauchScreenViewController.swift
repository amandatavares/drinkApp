//
//  LauchScreenViewController.swift
//  drinksApp
//
//  Created by Amanda Tavares on 28/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit

class LauchScreenViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var brandImageView: UIImageView!
    
    var gradientLayer: CAGradientLayer!
    var constant: Constants = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    func createGradientLayer(on view:UIView) {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [constant.secondColor, constant.officialColor]
        view.layer.addSublayer(gradientLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer(on: self.contentView)
        iconImageView.image = #imageLiteral(resourceName: "tipsy-white-2")
        brandImageView.image = #imageLiteral(resourceName: "coquele")
    }
}
