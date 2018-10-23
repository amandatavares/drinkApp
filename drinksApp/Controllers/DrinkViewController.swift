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
    
    var ingredients: [String?] = []
    var measures: [String?] = []
    var isFavorite: Bool = false
    var drinkImage: UIImage?
    var drink: Drink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let iText = self.drinkIngredients, let mText = self.drinkMeasures {
            iText.text! = ""
            mText.text! = ""
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //drinkImageView.image = self.popImage!
        
        guard let drink = self.drink else {
            return
        }

        if let nameLabel = self.drinkName, let catLabel = self.drinkCategory, let dirLabel = self.drinkDirections, let imageView = drinkImageView {
            nameLabel.text = drink.name!
            catLabel.text = drink.category!
            dirLabel.text = drink.recipe!
            imageView.image = self.drinkImage!
        }
//        if self.drinkName.text == nil || self.drinkCategory.text == nil || self.drinkDirections.text == nil {
//            self.drinkCategory.text = drink.category!
//            self.drinkName.text = drink.name!
//            self.drinkDirections.text = drink.recipe!
//        }
        
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

    }
    
    @IBAction func favoriteDrink(_ sender: UIButton) {
        
        if !isFavorite {
            favoriteButton.setImage(UIImage(named: "heart-filled"), for: .normal)
            self.isFavorite = true
            
            var ingredientList: [Ingredient] = []
            
            for (index, ingredient) in self.ingredients.enumerated() {
                if (ingredient != "" && ingredient != " " && self.measures[index] != "" && self.measures[index] != " ") {
                    let newIngredient = coreData.saveIngredient(name: ingredient!, measure: self.measures[index]!)
                    ingredientList.append(newIngredient!)
                }
            }
            
            if let name = self.drink?.name, let directions = self.drink?.recipe, let category = self.drink?.category, let thumb = self.drink?.thumb {
                coreData.saveDrink(name: name, ingredients: ingredientList, direction: directions, thumb: thumb, category: category, isFavorite: true)
            }
        }
        else {
            favoriteButton.setImage(UIImage(named: "heart-empty"), for: .normal)
            self.isFavorite = false
            
            let unFavorite = coreData.getUserDrink(by: (self.drink?.name)!)
            coreData.deleteDrink(drink: unFavorite)
        }
    }

}
