//
//  DrinkViewController.swift
//  drinksApp
//
//  Created by Amanda Tavares on 18/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit

class DrinkViewController: UIViewController {
    
    //var drink: Drink?
    let coreData: CoreDataManager = CoreDataManager()
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkCategory: UILabel!
    @IBOutlet weak var drinkIngredients: UILabel!
    @IBOutlet weak var drinkMeasures: UILabel!
    @IBOutlet weak var drinkDirections: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var helper: GlobalFunctions = GlobalFunctions()
    var ingredients: [String?] = []
    var measures: [String?] = []
    var isFavorite: Bool? = false
    var drinkImage: UIImage?
    var drink: Drink?
    var drinkLocal: DrinkLocal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let iText = self.drinkIngredients, let mText = self.drinkMeasures {
            iText.text! = ""
            mText.text! = ""
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if drinkLocal != nil {
            if let nameLabel = self.drinkName, let catLabel = self.drinkCategory, let dirLabel = self.drinkDirections {
                nameLabel.text = drinkLocal!.name
                catLabel.text = drinkLocal!.category
                dirLabel.text = drinkLocal!.direction
                
//                let ingredientsLocal = Array(drinkLocal!.ingredients!) as! [Ingredient]
                
//                for ingredient in ingredientsLocal {
//                    if let ingLabel = self.drinkIngredients, let measLabel = self.drinkMeasures {
//                        ingLabel.text?.append(contentsOf: "\(ingredient.name ?? "") \n")
//                        measLabel.text?.append(contentsOf: "\(ingredient.measure ?? "") \n")
//                    }
//                }
                
            }
        }
        
        guard let drink = self.drink else {
            return
        }

        if let nameLabel = self.drinkName, let catLabel = self.drinkCategory, let dirLabel = self.drinkDirections, let imageView = drinkImageView {
            nameLabel.text = drink.name!
            catLabel.text = drink.category!
            dirLabel.text = drink.recipe!
            imageView.image = self.drinkImage!
        }
        
        let ingredientsList: [String?] = [self.drink?.ingredient1, self.drink?.ingredient2, self.drink?.ingredient3, self.drink?.ingredient4, self.drink?.ingredient5, self.drink?.ingredient6, self.drink?.ingredient7, self.drink?.ingredient8, self.drink?.ingredient9, self.drink?.ingredient10, self.drink?.ingredient11, self.drink?.ingredient12, self.drink?.ingredient13, self.drink?.ingredient14, self.drink?.ingredient15]
        var ingredientName: String? = " "
        
        let measuresList: [String?] = [self.drink?.measure1, self.drink?.measure2, self.drink?.measure3, self.drink?.measure4, self.drink?.measure5, self.drink?.measure6, self.drink?.measure7, self.drink?.measure8, self.drink?.measure9, self.drink?.measure10, self.drink?.measure11, self.drink?.measure12, self.drink?.measure13, self.drink?.measure14, self.drink?.measure15]
        var measureName: String? = " "
        
        // catch all ingredients and add to viewcontroller list
        var i = 0 // iterator
        while (ingredientName != "" || i < ingredientsList.count-1) {
            ingredientName = ingredientsList[i]
            self.ingredients.append(ingredientName)
            i = i + 1
        }
        for ingredient in self.ingredients {
            if (ingredient != "" && ingredient != " ") {
                if let ingLabel = self.drinkIngredients {
                    ingLabel.text?.append(contentsOf: "\(ingredient!) \n")
                }
            }
        }
        
        var f = 0 // iterator
        while (measureName != "" || f < measuresList.count-1) {
            measureName = measuresList[f]
            self.measures.append(measureName)
            f = f + 1
        }
        for measure in self.measures {
            if (measure != "" && measure != " ") {
                if let mesLabel = self.drinkMeasures {
                    mesLabel.text?.append(contentsOf: "\(measure!) \n")
                }
            }
        }
        
        let drinkFavorite = isDrinkFavorite()
        print(drinkFavorite!)
    }
    func isDrinkFavorite() -> Bool? {
        guard let drink = self.drink else {
            return nil
        }
        if self.coreData.thisDrinkExists(id: drink.id!) {
            let drinkLocal: DrinkLocal = coreData.getUserDrink(by: drink.name!)
            if drinkLocal.isFavorite {
                favoriteButton.setImage(UIImage(named: "heart-filled"), for: .normal)
                return true
            } else {
                favoriteButton.setImage(UIImage(named: "heart-empty"), for: .normal)
                return false
            }
        }
        return false
    }
    @IBAction func favoriteDrink(_ sender: UIButton) {
        
        if (isDrinkFavorite() == false) {
            favoriteButton.setImage(UIImage(named: "heart-filled"), for: .normal)
            self.isFavorite = true
            
            var ingredientList: [Ingredient] = []
            
            for (index, ingredient) in self.ingredients.enumerated() {
                if (ingredient != "" && ingredient != " " && self.measures[index] != "" && self.measures[index] != " ") {
                    let newIngredient = coreData.saveIngredient(of: nil, name: ingredient!, measure: self.measures[index]!)
                    ingredientList.append(newIngredient!)
                }
            }
            
            var drinkFile: String = ""
            if let drinkImage = self.drinkImageView.image {
                drinkFile = saveImageDocumentDirectory(image: drinkImage)
            } else { drinkFile = (drink?.thumb)! }
            
            if let id = self.drink?.id, let name = self.drink?.name, let directions = self.drink?.recipe, let category = self.drink?.category {
                coreData.saveDrink(id: id, name: name, ingredients: ingredientList, direction: directions, thumb: drinkFile, category: category, isFavorite: true)
            }
        }
        else {
            favoriteButton.setImage(UIImage(named: "heart-empty"), for: .normal)
            self.isFavorite = false
            
            let unFavorite = coreData.getUserDrink(by: (self.drink?.name)!)
            coreData.deleteDrink(drink: unFavorite)
        }
    }

    func saveImageDocumentDirectory(image: UIImage) -> String{
        let filename = helper.getCurrentDate().appending(".jpg")
        let filepath = helper.getDocumentsDirectory() + "/" + filename
        
        let image = image.jpegData(compressionQuality: 1.0)
        FileManager.default.createFile(atPath: filepath, contents: image, attributes: nil)
        return filename
        
    }
}
