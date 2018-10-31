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
    @IBOutlet weak var scroll: UIScrollView!
    var userDrinks: [DrinkLocal] = []
    var userFavorites: [DrinkLocal] = []
    var allDrinks: [DrinkLocal] = []
    var drinkLocal: DrinkLocal?
    
    var coreManager: CoreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDrinksCollectionView.dataSource = self
        userDrinksCollectionView.delegate = self
        userFavoritesCollectionView.dataSource = self
        userFavoritesCollectionView.delegate = self
        
        scroll.isDirectionalLockEnabled = true
        self.userDrinksCollectionView.register(UINib.init(nibName: "DrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "drinkCell")
        self.userFavoritesCollectionView.register(UINib.init(nibName: "DrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "drinkCell")
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(UserSelectionViewController.handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
    self.userDrinksCollectionView?.addGestureRecognizer(lpgr)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //coreManager.dropDrinkDatabase()
        // Call Core Data
        self.allDrinks = coreManager.getUserDrinks()!
        for drink in self.allDrinks {
            if drink.isFavorite == true {
                if !self.userFavorites.contains(drink) {
                    self.userFavorites.append(drink)
                }
            }
            else {
                if !self.userDrinks.contains(drink) {
                    self.userDrinks.append(drink)
                }
            }
        }
        self.userDrinksCollectionView.reloadData()
        self.userFavoritesCollectionView.reloadData()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scroll.contentOffset.x>0 {
            scroll.contentOffset.x = 0
        }
    }
    
}

extension UserSelectionViewController: UIGestureRecognizerDelegate {
    // MARK: - Long Press Gesture Action Sheet
    @objc func handleLongPress(longPressGesture : UILongPressGestureRecognizer)
    {
        if (longPressGesture.state != UIGestureRecognizer.State.ended){
            return
        }
        // Delete selected Cell
        let point = longPressGesture.location(in: self.userDrinksCollectionView)
        let indexPath = self.userDrinksCollectionView.indexPathForItem(at: point)
        //        let cell = self.collectionView?.cellForItem(at: indexPath!)
        if indexPath != nil
        {
            let alertActionCell = UIAlertController(title: "Action Recipe Cell", message: "Choose an action for the selected recipe", preferredStyle: .actionSheet)
            
            // Configure Remove Item Action
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                self.coreManager.deleteDrink(drink: self.userDrinks[(indexPath?.row)!])
                self.userDrinks.remove(at: (indexPath?.row)!)
                
                print("Cell Removed")
                self.userDrinksCollectionView.reloadData()
            })
            
            // Configure Cancel Action Sheet
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { acion in
                print("Cancel actionsheet")
            })
            
            alertActionCell.addAction(deleteAction)
            alertActionCell.addAction(cancelAction)
            self.present(alertActionCell, animated: true, completion: nil)
            
        }
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
//            print(self.userFavorites[indexPath.row].thumb!)
            return cell
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
}
