//
//  NewDrinkViewController.swift
//  drinksApp
//
//  Created by Amanda Tavares on 18/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit
import CoreData

class NewDrinkViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var measureTextField: UITextField!
    @IBOutlet weak var directionsTextField: UITextField!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var drink: DrinkLocal?
    var manager: CoreDataManager = CoreDataManager()
    var imageSavedUrl: String?
    var category: String?
    var categories: [Category]?
    var ingredients: [Ingredient]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+200)

    }
    
    @IBAction func addDrinkImage(_ sender: Any) {
        // Show action sheet for Library or Take photo
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func saveNewDrink(_ sender: Any) {
        // TODO: Component to add new inputs to new ingredients and them to a list. change ingredients type on CoreManager
        if let name = nameTextField.text,
            let directions = directionsTextField.text,
            let category = category,
            let thumb = imageSavedUrl {
        
                manager.saveDrink(name: name, ingredients: self.ingredients!, direction: directions, thumb: thumb, category: category)
            
                self.dismiss(animated: true, completion: nil)
        }
            
        else {
            let alertFillAll = UIAlertController(title: "Fill the blanks", message: "There are some empty field. Please, fill all them.", preferredStyle: .alert)
            alertFillAll.addAction(UIAlertAction(title: "Confirm", style: .cancel, handler: nil))
            self.present(alertFillAll, animated: true, completion: nil)
        }
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        let ingredientName = self.ingredientTextField.text!
        let ingredientMeasure = self.ingredientTextField.text!
        
        let ingredient: Ingredient? = Ingredient()
        ingredient!.name = ingredientName
        ingredient!.measure = ingredientMeasure
        self.ingredients?.append(ingredient!)
        self.ingredientsTableView.reloadData()
    }
}
extension NewDrinkViewController {
    // Aditional Functions to handle camera options
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    func saveImageDocumentDirectory(image: UIImage) -> String{
        let filename = getCurrentDate().appending(".jpg")
        let filepath = getDocumentsDirectory().appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try image.jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomic)
            return String.init("/Images/\(filename)")
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath
        }
    }
    func getDocumentsDirectory() -> String {
        let directoryPath =  NSHomeDirectory().appending("/Images/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        return directoryPath
    }
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "ddMMMyyyy"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
}

extension NewDrinkViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.drinkImageView.image = image
            imageSavedUrl = self.saveImageDocumentDirectory(image: image)
            print(imageSavedUrl!)
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension NewDrinkViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // TODO: Create delegate to receive categories list from ViewController
        return categories!.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // data[row]
        return categories?[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // data[row]
        self.category = categories?[row].name
    }
    
}

extension NewDrinkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ingredients?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.ingredients?[indexPath.row].name!
        cell.detailTextLabel?.text = self.ingredients?[indexPath.row].measure!
        return cell
    }
    
    
}
