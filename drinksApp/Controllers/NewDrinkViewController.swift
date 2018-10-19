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
    var helper: GlobalFunctions = GlobalFunctions()
    var imageSavedUrl: String?
    var category: String?
    var categories: [Category]?
    var ingredients: [Ingredient]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        ingredientsTableView.dataSource = self
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+200)
        
        nameTextField.delegate = self
        ingredientTextField.delegate = self
        measureTextField.delegate = self
        directionsTextField.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
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
        var ingredient: Ingredient? = Ingredient()
        
        if let name = self.ingredientTextField.text,
            let measure = self.measureTextField.text {
                ingredient = manager.saveIngredient(name: name, measure: measure)
                //print(ingredient!)
        }
        self.ingredients?.append(ingredient!)
        //print(self.ingredients!)
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
        let filename = helper.getCurrentDate().appending(".jpg")
        let filepath = helper.getDocumentsDirectory() + "/" + filename

//        let url = NSURL.fileURL(withPath: filepath)
//        do {
            let image = image.jpegData(compressionQuality: 1.0)
            FileManager.default.createFile(atPath: filepath, contents: image, attributes: nil)
            return filename

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
            print("------------\(imageSavedUrl!)")
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
        return self.ingredients!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.ingredients?[indexPath.row].name!
        cell.detailTextLabel?.text = self.ingredients?[indexPath.row].measure!
        return cell
    }
}

extension NewDrinkViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}
