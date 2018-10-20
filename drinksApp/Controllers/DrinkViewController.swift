//
//  DrinkViewController.swift
//  drinksApp
//
//  Created by Amanda Tavares on 18/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit

class DrinkViewController: UIViewController {
    
    var drink: Drink?
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkCategory: UILabel!
    @IBOutlet weak var drinkIngredients: UILabel!
    @IBOutlet weak var drinkDirections: UILabel!
    var ingredients: [String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        guard let drink = self.drink else {
            return
        }
        let ingredientsList: [String?] = [self.drink?.ingredient1, self.drink?.ingredient2, self.drink?.ingredient3, self.drink?.ingredient4, self.drink?.ingredient5, self.drink?.ingredient6, self.drink?.ingredient7, self.drink?.ingredient8, self.drink?.ingredient9, self.drink?.ingredient10, self.drink?.ingredient11, self.drink?.ingredient12, self.drink?.ingredient13, self.drink?.ingredient14, self.drink?.ingredient15]
        var ingredientName: String? = " "
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        if let url = URL(string: drink.thumb ?? "https://via.placeholder.com/150x100"){
            
            let task = session.dataTask(with: url as URL, completionHandler: {data, response, error in
                
                if let err = error {
                    print("Error: \(err)")
                    return
                }
                
                if let http = response as? HTTPURLResponse {
                    if http.statusCode == 200 {
                        let downloadedImage = UIImage(data: data!)
                        DispatchQueue.main.async {
                            self.drinkImageView.image = downloadedImage
                        }
                    }
                }
            })
            task.resume()
        }
        
        self.drinkName.text = drink.name!
        self.drinkCategory.text = drink.category
        self.drinkDirections.text = drink.recipe
        
        // catch all ingredients and add to viewcontroller list
        var i = 0 // iterator
        while (ingredientName != "" || i < ingredientsList.count-1) {
            ingredientName = ingredientsList[i]
            self.ingredients.append(ingredientName)
            i = i + 1
        }
        
       

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
