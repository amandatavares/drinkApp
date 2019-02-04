//
//  DrinkTableViewCell.swift
//  drinksApp
//
//  Created by Amanda Tavares on 04/02/19.
//  Copyright © 2019 Amanda Tavares. All rights reserved.
//

import UIKit

class DrinkTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var drinksCollectionView: UICollectionView!
    var drinks:[DrinkList] = []
    var filteredDrinks: [DrinkList] = []
    
    var responseManager:ResponseManager? = ResponseManager()
    var drink: Drink?
    var drinkImage: UIImage = UIImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        drinksCollectionView.dataSource = self
        drinksCollectionView.delegate = self
        
        self.drinksCollectionView.register(UINib.init(nibName: "DrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "drinkCell")
       
        responseManager!.getAllDrinks(){ drinks in
            self.drinks = drinks
            self.filteredDrinks = self.drinks
            DispatchQueue.main.async {
                self.drinksCollectionView.reloadData()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredDrinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // else return drinks
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drinkCell", for: indexPath) as! DrinkCollectionViewCell
        //print(self.filteredDrinks.count)
        
        cell.configure(with: self.filteredDrinks[indexPath.row])
        
        return cell
    }
        // Animation of UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == drinksCollectionView {
            cell.alpha = 0
            cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                cell.alpha = 1
                cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            })
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let numberOfItemsPerRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        
        return CGSize(width: size, height: size+(size/2))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = drinksCollectionView.cellForItem(at: indexPath) as? DrinkCollectionViewCell {
            self.drinkImage = cell.drinkImageView.image!
        }
        let selectedDrink = self.filteredDrinks[indexPath.row]
        let drinkID = selectedDrink.id!
        responseManager?.getDrinkBy(id: drinkID) { drink in
            self.drink = drink
            
            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "detailDrink", sender: self)
            }
        }
        
    }
}
