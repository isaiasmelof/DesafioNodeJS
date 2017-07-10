//
//  Dog.swift
//  DesafioNodeJS
//
//  Created by Isaias Fernandes on 07/07/17.
//  Copyright © 2017 Isaias Fernandes. All rights reserved.
//

import Foundation

class Dog : NSObject {
    var id : Int
    var name: String
    var breed: String
    
    init(name: String, breed: String) {
        self.id = -1
        self.name = name
        self.breed = breed
    }
    
    func isValidInstance() -> Bool {
        return self.id > 0 && !self.name.isEmpty  && !self.breed.isEmpty
    }
    
    convenience init(name: String, breed: String, id: Int) {
        self.init(name: name, breed: breed)
        self.id = id
    }
    
    init(dog: NSDictionary) {
        self.id = dog.value(forKey: "id") as! Int
        self.name = dog.value(forKey: "name") as! String
        self.breed = dog.value(forKey: "breed") as! String
    }
    
    func parseDictionary() -> [String : Any] {
        let dictionary = ["name" : self.name, "breed" : self.breed] as [String : Any]
        return dictionary
    }
}
