//
//  BreedResponse.swift
//  ViewDogsApp
//
//  Created by Анна Субботина on 30.06.2022.
//

import Foundation
import ObjectMapper

struct BreedsResponse: Mappable {
    var images: [Breed] = []
    var status: String = ""
    
    init?(map: Map) {
        if let imagesStr: [String] = try? map.value("message") {
            self.images = imagesStr.map { Breed(imageUrl: $0) }
        }
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
    }
}
