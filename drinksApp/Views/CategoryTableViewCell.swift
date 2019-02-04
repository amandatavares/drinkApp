//
//  CategoryTableViewCell.swift
//  drinksApp
//
//  Created by Amanda Tavares on 04/02/19.
//  Copyright © 2019 Amanda Tavares. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    var categories:[Category] = []

    var responseManager:ResponseManager? = ResponseManager()
    let constants: Constants = Constants()

    override func awakeFromNib() {
        super.awakeFromNib()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
    self.categoriesCollectionView.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        
        responseManager!.getCategories(){ categories in
            self.categories = categories
            
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.configure(with: self.categories[indexPath.row], bgColor: constants.colors[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = NSAttributedString(string: self.categories[indexPath.item].name!)
        let width = (text.size().width) * 2
        let height = CGFloat(40)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let categories = self.categories
//        responseManager?.getDrinks(from: categories[indexPath.row], completion: { (ids) in
//            self.filteredDrinks = self.drinks.filter({ (drinkList) -> Bool in
//                ids.contains(where: { (id) -> Bool in
//                    if drinkList.id == id {
//                        return true
//                    } else {
//                        return false
//                    }
//                })
//            })
//            //print(self.filteredDrinks.count)
//            DispatchQueue.main.async {
//                self.drinksLabel.text = "Category: \(categories[indexPath.row].name!)"
//                self.seeAllBtn.alpha = 1
//                self.drinksCollectionView.reloadData()
//            }
//        })
    }
}
