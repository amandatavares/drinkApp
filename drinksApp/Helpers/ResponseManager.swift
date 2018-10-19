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
        //print(urlBase+lookup+id)
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
        //var drinkResult: Drink?
        
        if let apiBase = URL(string: urlBase+catories) {
            URLSession.shared.dataTask(with: apiBase) { (data, response
                , error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let categoryList = try decoder.decode(CategoryList.self, from: data)
                    let categories = categoryList.categories
                    
                    DispatchQueue.main.async {
                        completion(categories)
                    }
                    
                } catch let err {
                    print("Err", err)
                }
            }.resume()
        }
    }
}
