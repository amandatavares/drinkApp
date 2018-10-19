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
    var userDrinks: [DrinkLocal]?
    var userFavorites: [Drink]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDrinksCollectionView.dataSource = self
        userDrinksCollectionView.delegate = self
        userFavoritesCollectionView.dataSource = self
        userFavoritesCollectionView.delegate = self
        
    }

}

extension UserSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
