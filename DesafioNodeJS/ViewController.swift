 //
//  ViewController.swift
//  DesafioNodeJS
//
//  Created by Isaias Fernandes on 04/07/17.
//  Copyright © 2017 Isaias Fernandes. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DogPresenterDelegate {

    
    @IBOutlet weak var tableViewDogs: UITableView!
   
    let presenter = DogPresenter()
    var dogs : [Dog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewDogs.delegate = self
        self.tableViewDogs.dataSource = self
        self.presenter.delegate = self
        self.presenter.getAllDogs()
    }
    
    
    
    
    @IBAction func addDog(_ sender: Any) {
        presentAlert(type: .POST, dog: Dog(name: "", breed: "", id: -1))
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        return self.dogs.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = dogs[indexPath.row].name
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dogPresenterFinishedLoading (dogs: [Dog]){
        self.dogs = dogs
        //Dou prioridade ao recarregamento da tabela./
        DispatchQueue.main.async{
            self.tableViewDogs.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.presenter.deleteDog(dog: self.dogs[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentAlert(type: .PUT, dog: self.dogs[indexPath.row])
    }
    
    func presentAlert(type: TypeRequest, dog: Dog) {
        let alertController = UIAlertController(title: "Dog", message: "Please input dog:", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

        addTxtFldInAllertController(alertController: alertController, placeHolder: "Name")
        addTxtFldInAllertController(alertController: alertController, placeHolder: "Breed")
        alertController.addAction(cancelAction)
        
        switch type {
        case .POST:
            alertController.addAction(createPostAction(alertController: alertController))
            break
        case .PUT:
            if dog.isValidInstance() {
                alertController.textFields?[0].text = dog.name
                alertController.textFields?[1].text = dog.breed
                alertController.addAction(createPutAction(alertController: alertController, dog: dog))
            }
            break
        default:
            print("merdou")
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addTxtFldInAllertController(alertController: UIAlertController, placeHolder: String){
        alertController.addTextField { (textField) in
            textField.placeholder = placeHolder
        }
    }
    
    func createPostAction(alertController: UIAlertController) -> UIAlertAction {
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            var name : String = ""
            var breed : String = ""
            
            if let field = alertController.textFields?[0] {
                if (!(field.text?.isEmpty)!){
                    name  = (alertController.textFields?[0].text)!
                }
            }
            
            if let field = alertController.textFields?[1]{
                if (!(field.text?.isEmpty)!){
                    breed  = (alertController.textFields?[1].text)!
                }
            }
            let dog = Dog(name: name, breed: breed)
            self.presenter.addDog(dog: dog)
        }
        
        return confirmAction
    }
    
    func createPutAction(alertController: UIAlertController, dog: Dog) -> UIAlertAction {
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                if (!(field.text?.isEmpty)!){
                    dog.name  = (alertController.textFields?[0].text)!
                }
            }
            
            if let field = alertController.textFields?[1]{
                if (!(field.text?.isEmpty)!){
                    dog.breed  = (alertController.textFields?[1].text)!
                }
            }
            self.presenter.updateDog(dog: dog)
        }
        
        return confirmAction
    }
    

}

