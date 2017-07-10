//
//  DogPresenter.swift
//  DesafioNodeJS
//
//  Created by Isaias Fernandes on 08/07/17.
//  Copyright © 2017 Isaias Fernandes. All rights reserved.
//

import Foundation


protocol DogPresenterDelegate {
    func dogPresenterFinishedLoading (dogs: [Dog])

}
class DogPresenter : NSObject, ServerDelegate {
    
    
    var delegate : DogPresenterDelegate?
    
    
    func getAllDogs() {
        let url = URL(string: "http://localhost:3000/dogs")
        Server.sharedInstance.get(url: url!)
    }
    
    func addDog(dog: Dog){
        let url = URL(string: "http://localhost:3000")
        let parameters = dog.parseDictionary()
        Server.sharedInstance.post(url: url!, params: parameters)
    }
    
    func deleteDog(dog: Dog) {
        let id = dog.id
        if id > 0 {
            let url = URL(string: "http://localhost:3000/dogs/\(id)")
            Server.sharedInstance.delete(url: url!)
        } else {
            print("ID invalido")
        }
        
    }
    //jc.juliocezar.apple@gmail.com
    func updateDog(dog: Dog) {
        let id = dog.id
        if id > 0 {
            let url = URL(string: "http://localhost:3000/dogs/\(id)")
            let parameters = dog.parseDictionary()
            Server.sharedInstance.put(url: url!, params: parameters)
        } else {
            print("ID invalido")
        }
        
    }
    
    override init() {
        super.init()
        Server.sharedInstance.delegate = self
    }
    
    
    func server(didFinishGetRequest jsonResult: [NSDictionary]){
        var dogs = [Dog]()
        for item in jsonResult {
            dogs.append(Dog(dog: item))
        }
        self.delegate?.dogPresenterFinishedLoading(dogs: dogs)
       
    }
    
    func server(deleted jsonResult: NSDictionary){
        getAllDogs()
        print("ok")
    }
    
    func server(didFinishPostRequest jsonResult: NSDictionary){
        getAllDogs()
        print("ok")
    }
    
    func server(updated jsonResult: NSDictionary){
        getAllDogs()
        print("ok")
    }
}
