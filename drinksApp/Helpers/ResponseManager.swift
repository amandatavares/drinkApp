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
    let urlBase = "https://www.thecocktaildb.com/api/json/v1/1"
    let alcoholicDrink = "/filter.php?a=Alcoholic"
    let nonAlcoholicDrink = "/filter.php?a=Non_Alcoholic"
    let lookup = "lookup.php?i="
    
    
    func getAllDrinks() -> Array<DrinkList> {
        var array: Array<DrinkList>?
        
        if let apiBase = URL(string: urlBase+alcoholicDrink) {
        URLSession.shared.dataTask(with: apiBase) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let drinks = try decoder.decode(ResultList.self, from: data)
                
                DispatchQueue.global().async {
                    array = drinks.drinks
                }
                
            } catch let err {
                print("Err", err)
            }
            }.resume()
        }
        return array!
    }
    
    func getDrinkBy(id:String) -> Drink {
        var drinkResult: Drink?
        
        if let apiBase = URL(string: urlBase+lookup+id) {
        URLSession.shared.dataTask(with: apiBase) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let resultDrink = try decoder.decode(ResultDrink.self, from: data)
                let drink = resultDrink.drink[0]

                DispatchQueue.main.async {
                    drinkResult = drink
                }

            } catch let err {
                print("Err", err)
                }
            }.resume()
        }
        return drinkResult!
    }
    
}
