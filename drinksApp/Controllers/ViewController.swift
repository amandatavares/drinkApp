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
    @IBOutlet weak var searchBar: UISearchBar!
    var drinks:[DrinkList] = []
    var categories:[Category] = []
    var drink: Drink?
    var drinkImage: UIImage = UIImage()

    var responseManager:ResponseManager? = ResponseManager()
    let constants: Constants = Constants()

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
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        else {
            print("3D Touch Not Available")
        }
        //registerForPreviewing(with: self, sourceView: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let newDrinkVC = segue.destination as? NewDrinkViewController {
            newDrinkVC.categories = self.categories
        }
        if let detailDrinkVC = segue.destination as? DrinkViewController {
            detailDrinkVC.drink = self.drink
            detailDrinkVC.drinkImage = self.drinkImage
            
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
            cell.configure(with: self.categories[indexPath.row], bgColor: constants.colors[indexPath.row])
            
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

            let text = NSAttributedString(string: self.categories[indexPath.item].name!)
            let width = (text.size().width) * 2
            let height = CGFloat(40)

            return CGSize(width: width, height: height)
        }
        
        let numberOfItemsPerRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        //return CGSize(width: itemWidth, height: itemWidth)
        //print("---------------\(size) + \(size+size/2)")
        return CGSize(width: size, height: size+(size/2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == drinksCollectionView {
            if let cell = drinksCollectionView.cellForItem(at: indexPath) as? DrinkCollectionViewCell {
                self.drinkImage = cell.drinkImageView.image!
            }
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

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = drinksCollectionView.indexPathForItem(at: drinksCollectionView.convert(location, from: view)),
            let cell = drinksCollectionView.cellForItem(at: indexPath) as? DrinkCollectionViewCell else {
            return nil
        }
        
        let popVC = storyboard?.instantiateViewController(withIdentifier: "drinkVc") as! DrinkViewController
        //let peekVC = storyboard?.instantiateViewController(withIdentifier: "peekVC") as! PeekViewController
        
        let selectedDrink = self.drinks[indexPath.row]
        let drinkID = selectedDrink.id!
        responseManager?.getDrinkBy(id: drinkID) { drink in
            self.drink = drink
            DispatchQueue.main.async {
                if let image = cell.drinkImageView.image, let name = cell.drinkNameLabel.text, let category = cell.drinkCategoryLabel.text {
                    popVC.drinkImageView.image = image
                    popVC.drinkImage = image
                    popVC.drinkName.text = name
                    popVC.drinkCategory.text = category
                }
                popVC.drink = self.drink
            }
        }
        
       
        //Set your height
        popVC.preferredContentSize = CGSize(width: 0.0, height: 300)
        previewingContext.sourceRect = cell.drinkImageView.frame
        
        return popVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

