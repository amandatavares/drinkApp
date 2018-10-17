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
    var drinks:[Drink] = []
    
//    var categoryCollectionLayout: UICollectionViewFlowLayout = {
//        let categoryCollectionLayout = UICollectionViewFlowLayout()
//        let categoryWidth = 80.0
//        categoryCollectionLayout.estimatedItemSize = CGSize(width: categoryWidth, height: 40.0)
//        return categoryCollectionLayout
//    }()
//
//    var drinkCollectionLayout: UICollectionViewFlowLayout = {
//        let drinkCollectionLayout = UICollectionViewFlowLayout()
//        let drinkWidth = 200.0
//        drinkCollectionLayout.estimatedItemSize = CGSize(width: drinkWidth, height: 170.0)
//        return drinkCollectionLayout
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Data source and delegate
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        drinksCollectionView.dataSource = self
        drinksCollectionView.delegate = self
        
        // Register cells
        self.categoriesCollectionView.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
//        self.categoriesCollectionView.collectionViewLayout = categoryCollectionLayout

        self.drinksCollectionView.register(UINib.init(nibName: "DrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "drinkCell")
//        self.drinksCollectionView.collectionViewLayout = drinkCollectionLayout
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Call API data
        let url = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic"
        guard let apiBase = URL(string: url) else { return }
        URLSession.shared.dataTask(with: apiBase) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let drinks = try decoder.decode(Result.self, from: data)
               
                self.drinks = drinks.drink
                DispatchQueue.main.async {
                    self.drinksCollectionView.reloadData()
                }
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}

// Protocols
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoriesCollectionView {
            return 1
        }
        // else return drinks count
        return self.drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // return categories
        if collectionView == self.categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
            cell.categoryNameLabel.text = "Cocktail"
            cell.categoryView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
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
        let minimumInteritemSpacing: CGFloat = 10
        let cellsPerRow = 2
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        print(itemWidth)
        return CGSize(width: itemWidth, height: itemWidth+30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
