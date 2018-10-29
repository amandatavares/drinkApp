//
//  DrinkCollectionViewCell.swift
//  drinksApp
//
//  Created by Amanda Tavares on 16/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit

class DrinkCollectionViewCell: UICollectionViewCell, ImageDownloaderDelegate {

    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkCategoryLabel: UILabel!
    let responseData: ResponseManager = ResponseManager()
    var coreData: CoreDataManager = CoreDataManager()
    let constants: Constants = Constants()
    var imageDownloader: ImageDownloader?
    var id: String?
    var category: String?
    var drink: Drink?
    var drinkLocal: DrinkLocal?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.addShadow()
        self.layer.roundCorners(radius: constants.cornerRadius)
        self.clipsToBounds = true
        
    }
    
    public func configure(with model: DrinkList) {
    

        if let url = URL(string: model.thumb ?? "https://via.placeholder.com/150x100"){
            self.imageDownloader = ImageDownloader(imageURL: url)
            self.imageDownloader?.delegate = self
            self.imageDownloader?.downloadImage()
            if imageDownloader?.delegate == nil {
                print("----ueeeee-----")
            }
            
        }
        
        drinkNameLabel.text = model.name!
        self.id = model.id
        responseData.getDrinkBy(id: self.id!) { drink in
            self.drink = drink
            DispatchQueue.main.async {
                self.drinkCategoryLabel.text = self.drink?.category
            }
        }
        
        //drinkCategoryLabel.text = model.category ?? "Sem categoria"
    }
    func didFinishDownloading(_ sender: ImageDownloader) {
        drinkImageView.image = imageDownloader?.image
    }
    
    public func configure(with model: DrinkLocal) {
        
        let helper: GlobalFunctions = GlobalFunctions()
        var fileName = ""
        if let thumb = model.thumb {
             fileName = thumb
        }
        let fileURL = NSURL(fileURLWithPath: helper.getDocumentsDirectory()).appendingPathComponent(fileName)
        if let imageData = NSData(contentsOf: fileURL!) {
            let image = UIImage(data: imageData as Data) // Here you can attach image to UIImageView
            drinkImageView.image = image
        }
        
        if let name = model.name, let category = model.category {
            drinkNameLabel.text = name
            drinkCategoryLabel.text = category
        }
    }
    
    
}
