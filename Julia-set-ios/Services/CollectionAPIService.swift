//
//  CollectionAPIService.swift
//  Julia-set-ios
//
//  Created by Evan Beh on 09/10/2021.
//

import UIKit
import Firebase
import CodableFirebase


protocol DBProtocol : AnyObject
{
    func save(collection:CollectionModel)
    func retrieve( completion: @escaping (([CollectionModel]) -> Void))

    
}



class CollectionAPIService: DBProtocol {

    var ref: DatabaseReference!

     init() {
        ref = Database.database().reference()

    }
    
    func save(collection:CollectionModel)
    {
        let docData = try! FirestoreEncoder().encode(collection)

        ref.child("favourites").childByAutoId().setValue(docData)
        
    }
    
    func retrieve( completion: @escaping (([CollectionModel]) -> Void))
    {
        
        var array = [CollectionModel]()
        let collections = self.ref.child("favourites")

        collections.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                  
                             
                    let collection = try! FirebaseDecoder().decode(CollectionModel.self, from: (snap ).value as Any)

                    array.append(collection)
                  
                    completion(array)
                    print(collection)
                }
           
        }
        )
    
        

    }
    

    
}
