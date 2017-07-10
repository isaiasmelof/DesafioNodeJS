//
//  Server.swift
//  DesafioNodeJS
//  Created by Isaias Fernandes on 07/07/17.
//  Copyright © 2017 Isaias Fernandes. All rights reserved.
//
import Foundation
import Alamofire

protocol ServerDelegate : class {
    func server(didFinishGetRequest jsonResult: [NSDictionary])
    func server(deleted jsonResult: NSDictionary)
    func server(didFinishPostRequest jsonResult: NSDictionary)
    func server(updated jsonResult: NSDictionary)
}


final class Server : NSObject {
   
   //MARK: - Static Instance (Singleton)
    static let sharedInstance : Server = {
        let instance = Server()
        return instance
    }()
    
    //MARK: - Weak var for delegate
    weak var delegate :  ServerDelegate?
   
    func get(url: URL){
        Alamofire.request(url, method: .get).responseJSON { (response) in
            //test http responde
            if !self.isSuccessResponse(response: response) {
                return
            }
            //test value data response
            guard let json = response.result.value as? [NSDictionary] else {
                print("Erro na resposta do Json")
                return
            }
            self.delegate?.server(didFinishGetRequest: json)
        }
    }
    
    func delete (url: URL){
        Alamofire.request(url, method: .delete).responseJSON { (response) in
            if !self.isSuccessResponse(response: response) {
                return
            }
            guard let json = response.result.value as? NSDictionary else {
                print("Erro na resposta do Json")
                return
            }
            self.delegate?.server(deleted: json)
        }
    }
    
    func post(url: URL, params: [String:Any]){
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            if !self.isSuccessResponse(response: response) {
                return
            }
            guard let json = response.result.value as? NSDictionary else {
                print("Erro na resposta do Json")
                return
            }
            self.delegate?.server(didFinishPostRequest: json)
        }
    }
    
    func put(url: URL, params: [String:Any]){
        Alamofire.request(url, method: .put, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            if !self.isSuccessResponse(response: response) {
                return
            }
            guard let json = response.result.value as? NSDictionary else {
                print("Erro na resposta do Json")
                return
            }
            self.delegate?.server(didFinishPostRequest: json)
        }
    }
    
    // MARK: - Initialization Method
    override private init() {
        super.init()
    }
    
    func isSuccessResponse (response: DataResponse<Any>) -> Bool{
        guard response.result.isSuccess else {
            print("Not sucess")
            return false
            
        }
        return true
    }
}

enum TypeRequest  {
    case POST
    case PUT
    case DELETE
    case UPDATE
}
