//
//  DrinkCollectionViewCell.swift
//  drinksApp
//
//  Created by Amanda Tavares on 16/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit

class DrinkCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkCategoryLabel: UILabel!
    var id: String?
    var category: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.addShadow()
        
    }
    
    public func configure(with model: DrinkList) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        if let url = URL(string: model.thumb ?? "https://via.placeholder.com/150x100"){
            
            let task = session.dataTask(with: url as URL, completionHandler: {data, response, error in
                
                if let err = error {
                    print("Error: \(err)")
                    return
                }
                
                if let http = response as? HTTPURLResponse {
                    if http.statusCode == 200 {
                        let downloadedImage = UIImage(data: data!)
                        DispatchQueue.main.async {
                            self.drinkImageView.image = downloadedImage
                        }
                    }
                }
            })
            task.resume()
        }
        
        drinkNameLabel.text = model.name!
        self.id = model.id
        
        
        //drinkCategoryLabel.text = model.category ?? "Sem categoria"
    }
}
