//
//  ViewController.swift
//  drinksApp
//
//  Created by Amanda Tavares on 16/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var drinksCollectionView: UICollectionView!
    var drinks:[DrinkList] = []
    var categories:[Category] = []
    
    var responseManager:ResponseManager? = ResponseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Data source and delegate
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        drinksCollectionView.dataSource = self
        drinksCollectionView.delegate = self
        
        // Register cells
        self.categoriesCollectionView.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")

        self.drinksCollectionView.register(UINib.init(nibName: "DrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "drinkCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let navigation = segue.destination as? UINavigationController,
//            let newTripVc = navigation.topViewController as? NewTripViewController {
//            newTripVc.delegate = self
//        }
        if let newDrinkVC = segue.destination as? NewDrinkViewController {
                newDrinkVC.categories = self.categories
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Call API data
        responseManager!.getAllDrinks(){ drinks in
            self.drinks = drinks
            DispatchQueue.main.async {
                self.drinksCollectionView.reloadData()
            }
        }
        responseManager!.getCategories(){ categories in
            self.categories = categories
            
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
        }
    }
}

// Protocols
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoriesCollectionView {
            return self.categories.count
        }
        // else return drinks count
        return self.drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // return categories
        if collectionView == self.categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
            cell.configure(with: self.categories[indexPath.row])
            return cell
        }
        else {
        // else return drinks
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drinkCell", for: indexPath) as! DrinkCollectionViewCell
            cell.configure(with: self.drinks[indexPath.row]) 
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.categoriesCollectionView {
            return CGSize(width: 80.0, height: 40.0)
        }
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
