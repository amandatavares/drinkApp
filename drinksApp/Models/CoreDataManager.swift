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
    
    public func saveDrink(id: String?, name: String, ingredients: [Ingredient], direction: String, thumb: String, category: String, isFavorite: Bool) {
        if let drink = NSEntityDescription.insertNewObject(forEntityName: "DrinkLocal", into: self.context) as? DrinkLocal {
            drink.id = id
            drink.name = name
            drink.direction = direction
            drink.thumb = thumb
            drink.category = category
            drink.isFavorite = isFavorite
            //drink.ingredients = ingredients
            for ingredient in ingredients {
                drink.addToIngredients(ingredient)
            }
            //print(drink)
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
    public func getUserDrink(by name: String) -> DrinkLocal {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DrinkLocal")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "name = %@", name)

        do {
            let drinks = try context.fetch(request) as! [DrinkLocal]
            let drink = drinks.first
            return drink!
        }
        catch {
            fatalError("Failed to fetch: \(error)")
        }
    }
    func thisDrinkExists(id: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DrinkLocal")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
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
    
    public func saveIngredient(name: String, measure: String) -> Ingredient? {
        var ingredientRet: Ingredient? = Ingredient()
        if let ingredient = NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: self.context) as? Ingredient {
            ingredient.name = name
            ingredient.measure = measure
            
            ingredientRet = ingredient
            try? context.save()
        }
        return ingredientRet
    }
    public func getAllIngredients() -> [Ingredient]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Ingredient")
        do {
            let ingredients = try context.fetch(request) as! [Ingredient]
            return ingredients
        }
        catch {
            fatalError("Failed to fetch: \(error)")
        }
    }
    
}

