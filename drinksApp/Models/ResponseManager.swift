//
//  ResponseManager.swift
//  drinksApp
//
//  Created by Amanda Tavares on 17/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import Foundation
import UIKit

class ResponseManager {
    let urlBase = "https://www.thecocktaildb.com/api/json/v1/1/"
    let alcoholicDrink = "filter.php?a=Alcoholic"
    let nonAlcoholicDrink = "filter.php?a=Non_Alcoholic"
    let lookup = "lookup.php?i="
    let catories = "list.php?c=list"
    
    func getAllDrinks(completion: @escaping ([DrinkList])->Void) {
        
        if let apiBase = URL(string: urlBase+alcoholicDrink) {
        URLSession.shared.dataTask(with: apiBase) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let drinks = try decoder.decode(ResultList.self, from: data)
                
                DispatchQueue.global().async {
                    let array: Array<DrinkList>
                    array = drinks.drinks
                    completion(array)
                }
            } catch let err {
                print("Err", err)
            }
            
            }.resume()
        }
    }
    
    func getDrinkBy(id:String, completion: @escaping (Drink)->Void) {
        //var drinkResult: Drink?
        if let apiBase = URL(string: urlBase+lookup+id) {
        URLSession.shared.dataTask(with: apiBase) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let resultDrink = try decoder.decode(ResultDrink.self, from: data)
                //print(resultDrink)
                DispatchQueue.global().async {
                    let drink = resultDrink.drink[0]
                    //print(drink)
                    
                    completion(drink)
                }

            } catch let err {
                print("Err", err)
                }
            }.resume()
        }
        else {
            print("WTF")
        }
    }
    
    func getCategories(completion: @escaping ([Category])->Void) {
        //var array: [Category] = []
        
        if let apiBase = URL(string: urlBase+catories) {
            URLSession.shared.dataTask(with: apiBase) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let categoryList = try decoder.decode(CategoryList.self, from: data)
                    let categories = categoryList.categories
                    
                    //let group = DispatchGroup()
//                    for category in categories {
//                        group.enter()
//
//                        self.getAllDrinks(){ drinks in
//                            for ourDrink in drinks {
//                                self.getDrinkBy(id: ourDrink.id!, completion: { (drink) in
//                                    if drink.category == category.name && drink.alcoholic == "Alcoholic"{
//                                        array.append(category)
//
//                                        group.leave()
//
//                                    }
//                                })
//                            }
//                        }
//                    }
                    //group.notify(queue: DispatchQueue.main, execute: {
                        DispatchQueue.main.async {
                            completion(categories)
                        }
                    //})
                } catch let err {
                    print("Err", err)
                }
            }.resume()
        }
    }
    func getDrinks(from category: Category, completion: @escaping ([String]) -> Void) {
        guard let apiBase = URL(string: urlBase+alcoholicDrink) else {return}
        
         var drinkIds: [String] = []
        
        URLSession.shared.dataTask(with: apiBase) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let drinkList = try decoder.decode(ResultList.self, from: data)
                let resultDrinks = drinkList.drinks
                
                let group = DispatchGroup()
                
                for result in resultDrinks {
                    
                    group.enter()
                    
                   self.getDrinkBy(id: result.id!) { drink in
                        if drink.category == category.name {
                            drinkIds.append(drink.id!)
                        }
                        group.leave()
                        
                    }
                }
                
                group.notify(queue: DispatchQueue.main, execute: {
                    DispatchQueue.main.async {
                        completion(drinkIds)
                    }
                })
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}
