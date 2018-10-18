//
//  CoreDataManager.swift
//  drinksApp
//
//  Created by Amanda Tavares on 18/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit
import CoreData

// Singleton to handle and manage core data
class CoreDataManager: NSObject {
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public func saveDrink(name: String, ingredients: [Ingredient], direction: String, thumb: String, category: String) {
        if let drink = NSEntityDescription.insertNewObject(forEntityName: "DrinkLocal", into: self.context) as? DrinkLocal {
            drink.name = name
            drink.direction = direction
            drink.thumb = thumb
            drink.category = category
            //drink.ingredients = ingredients
            for ingredient in ingredients {
                drink.addToIngredients(ingredient)
            }
            try? context.save()
        }
    }
    
    public func getUserDrinks() -> [DrinkLocal]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrinkLocal")
        do {
            let drinks = try context.fetch(request) as! [DrinkLocal]
            return drinks
        }
        catch {
            fatalError("Failed to fetch: \(error)")
        }
    }
    
    public func editUserDrink(name: String, direction: String, thumb: String, category: String, drink: DrinkLocal){
        
        drink.setValuesForKeys(["name" : name, "direction" : direction, "thumb": thumb])
        drink.category = category
        
        try? context.save()
    }
    
    public func deleteDrink(drink: DrinkLocal){
        context.delete(drink)
        try? context.save()
    }
}

