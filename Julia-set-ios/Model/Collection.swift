//
//  Collection.swift
//  Julia-set-ios
//
//  Created by Evan Beh on 08/10/2021.
//

import UIKit

import Firebase

struct CollectionModel: Codable {
    let title: String?
    let uniform : Uniforms


    enum CodingKeys: String, CodingKey {
        case title = "name"
        case uniform

    }

    
    init(title:String, uniform:Uniforms) {
        self.title = title
        self.uniform = uniform
       }
    
 
}
