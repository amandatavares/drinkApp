//
//  ViewController.swift
//  drinksApp
//
//  Created by Amanda Tavares on 16/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var filteredDrinks: [DrinkList] = []

    
    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var drinksLabel: UILabel!
//    @IBOutlet weak var seeAllBtn: UIButton!
    
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Data source and delegate
        
        searchBar.delegate = self as? UISearchBarDelegate

        // Register cells
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        tableView.register(UINib(nibName: "DrinkTableViewCell", bundle: nil), forCellReuseIdentifier: "DrinkTableViewCell")
        
        
//        if traitCollection.forceTouchCapability == .available {
//            registerForPreviewing(with: self as! UIViewControllerPreviewingDelegate, sourceView: view)
//        }
//        else {
//            print("3D Touch Not Available")
//        }
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 44
        
        searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true

        // Customize search and navigation bar
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderWidth = 0
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.layer.addShadow()
            searchTextField.placeholder = "What do you want to drink today?"
        }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    
//        self.drinksLabel.text = "All"
//        self.seeAllBtn.alpha = 0
        
        //registerForPreviewing(with: self, sourceView: view)
        //self.filteredDrinks = self.drinks
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

//        if let newDrinkVC = segue.destination as? NewDrinkViewController {
//            newDrinkVC.categories = self.categories
//        }
//        if let detailDrinkVC = segue.destination as? DrinkViewController {
//            detailDrinkVC.drink = self.drink
//            detailDrinkVC.drinkImage = self.drinkImage
//
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Call API data
        
        }
        
    
    
//    @IBAction func seeAllDrinks(_ sender: Any) {
//        self.drinksLabel.text = "All"
//        self.seeAllBtn.alpha = 0
//        self.filteredDrinks = self.drinks
//        self.drinksCollectionView.reloadData()
//    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(section)
        switch section {
        case 0:
            return "Categories"
        case 1:
            return "Drinks"
        default:
            return "Error"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0:
                let categoriesCell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
                return categoriesCell

            case 1:
                let drinksCell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewCell", for: indexPath) as! DrinkTableViewCell
                return drinksCell
                
            default:
                return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 400.0
        }
        return 44.0
    }
    
}
//extension ViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UITextFieldDelegate {
//    //Calls this function when the tap is recognized.
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.view.endEditing(true)
//    }
//    func updateSearchResults(for searchController: UISearchController) {
//        //self.searchActive = true
//        print(searchBar.text!)
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text == nil || searchBar.text == "" {
//            self.searchActive = false
//            self.filteredDrinks = self.drinks
//            view.endEditing(true)
//            drinksCollectionView.reloadData()
//        } else {
//            self.filteredDrinks = drinks.filter({ (drink) -> Bool in
//                return drink.name!.range(of: searchText, options: [ .caseInsensitive]) != nil
//            })
//            self.searchActive = !self.filteredDrinks.isEmpty
//            print(searchActive)
//            self.drinksCollectionView.reloadData()
//        }
//    }
//}


//extension ViewController: UIViewControllerPreviewingDelegate {
//
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        guard let indexPath = drinksCollectionView.indexPathForItem(at: drinksCollectionView.convert(location, from: view)),
//            let cell = drinksCollectionView.cellForItem(at: indexPath) as? DrinkCollectionViewCell else {
//            return nil
//        }
//        
//        let popVC = storyboard?.instantiateViewController(withIdentifier: "drinkVc") as! DrinkViewController
//        //let peekVC = storyboard?.instantiateViewController(withIdentifier: "peekVC") as! PeekViewController
//        
//        let selectedDrink = self.filteredDrinks[indexPath.row]
//        let drinkID = selectedDrink.id!
//        responseManager?.getDrinkBy(id: drinkID) { drink in
//            self.drink = drink
//            DispatchQueue.main.async {
//                if let image = cell.drinkImageView.image, let name = cell.drinkNameLabel.text, let category = cell.drinkCategoryLabel.text {
//                    popVC.drinkImageView.image = image
//                    popVC.drinkImage = image
//                    popVC.drinkName.text = name
//                    popVC.drinkCategory.text = category
//                }
//                popVC.drink = self.drink
//            }
//        }
//        
//       
//        //Set your height
//        popVC.preferredContentSize = CGSize(width: 0.0, height: 300)
//        previewingContext.sourceRect = cell.drinkImageView.frame
//        
//        return popVC
//    }
//    
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        show(viewControllerToCommit, sender: self)
//    }
//}

