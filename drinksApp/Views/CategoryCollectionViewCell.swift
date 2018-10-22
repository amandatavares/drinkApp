//
//  CategoryCollectionViewCell.swift
//  drinksApp
//
//  Created by Amanda Tavares on 16/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    let responseData: ResponseManager = ResponseManager()
    var category: [Category]?
    let constants: Constants = Constants()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.addShadow()
        self.layer.roundCorners(radius: constants.cornerRadius)
        self.clipsToBounds = true
    }
    
    public func configure(with model: Category, bgColor: UIColor) {
        self.categoryNameLabel.text = model.name!
        self.categoryView.backgroundColor = bgColor
    }
}
