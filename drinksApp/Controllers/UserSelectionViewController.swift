//
//  UserSelectionViewController.swift
//  drinksApp
//
//  Created by Amanda Tavares on 18/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit
import CoreData

class UserSelectionViewController: UIViewController {

    @IBOutlet weak var userDrinksCollectionView: UICollectionView!
    @IBOutlet weak var userFavoritesCollectionView: UICollectionView!
    var userDrinks: [DrinkLocal] = []
    var userFavorites: [DrinkLocal] = []
    var allDrinks: [DrinkLocal] = []
    
    var coreManager: CoreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDrinksCollectionView.dataSource = self
        userDrinksCollectionView.delegate = self
        userFavoritesCollectionView.dataSource = self
        userFavoritesCollectionView.delegate = self
        
        self.userDrinksCollectionView.register(UINib.init(nibName: "DrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "drinkCell")
        self.userFavoritesCollectionView.register(UINib.init(nibName: "DrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "drinkCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Call Core Data
        self.allDrinks = coreManager.getUserDrinks()!
        for drink in self.allDrinks {
            if drink.isFavorite == true {
                self.userFavorites.append(drink)
            }
            else {
                self.userDrinks.append(drink)
            }
        }
        self.userDrinksCollectionView.reloadData()
        self.userFavoritesCollectionView.reloadData()
    }
}

extension UserSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.userDrinksCollectionView {
            return self.userDrinks.count
        }
        // else return drinks count
        return self.userFavorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // return user drinks
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drinkCell", for: indexPath) as! DrinkCollectionViewCell
        
        if collectionView == self.userDrinksCollectionView {
            cell.configure(with: self.userDrinks[indexPath.row])
            return cell
        }
        else {
            // else return favorite drinks
            cell.configure(with: self.userFavorites[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let inset: CGFloat = 15
        //let minimumLineSpacing: CGFloat = 10
        let minimumInteritemSpacing: CGFloat = 15
        let cellsPerRow = 2
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth+20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
