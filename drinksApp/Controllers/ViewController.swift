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
    var drink: Drink?
    
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
        
        registerForPreviewing(with: self, sourceView: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let newDrinkVC = segue.destination as? NewDrinkViewController {
                newDrinkVC.categories = self.categories
        }
        if let detailDrinkVC = segue.destination as? DrinkViewController {
            detailDrinkVC.drink = self.drink
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
            //cell.isUserInteractionEnabled = true
            
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == drinksCollectionView {
            let selectedDrink = self.drinks[indexPath.row]
            let drinkID = selectedDrink.id!
            responseManager?.getDrinkBy(id: drinkID) { drink in
                self.drink = drink
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "detailDrink", sender: self)
                }
            }
            
        }
    }
}

extension ViewController: UIViewControllerPreviewingDelegate {
//    func viewControllerForDrink(at indexPath: IndexPath) -> DrinkViewController {
//        let drinkVC = DrinkViewController()
//        drinkVC.drink = self.drink
//        return drinkVC
//    }
//
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = drinksCollectionView.indexPathForItem(at: drinksCollectionView.convert(location, from: view)), let cell = drinksCollectionView.cellForItem(at: indexPath) as? DrinkCollectionViewCell else {
            return nil
        }
        
        let popVC = storyboard?.instantiateViewController(withIdentifier: "drinkVc") as! DrinkViewController
            
            //let selectedDrink = cell.drink
            //popVC.drink = selectedDrink
        let selectedDrink = self.drinks[indexPath.row]
        let drinkID = selectedDrink.id!
        responseManager?.getDrinkBy(id: drinkID) { drink in
            self.drink = drink
            DispatchQueue.main.async {
//                    self.performSegue(withIdentifier: "detailDrink", sender: self)
                popVC.drink = self.drink
            }
        }
           
            //Set your height
        popVC.preferredContentSize = CGSize(width: 0.0, height: 300)
        previewingContext.sourceRect = cell.drinkImageView.frame
        
        return popVC

    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        if let viewController = viewControllerToCommit as? DrinkViewController {
//            //viewController.back.isHidden = false
//
//        }
        show(viewControllerToCommit, sender: self)
    }
    
    
}
