//
//  DogResponse.swift
//  ViewDogsApp
//
//  Created by Анна Субботина on 30.06.2022.
//

import Foundation
import ObjectMapper

struct DogsResponse: Mappable {
    var breeds: [Dog] = []
    var status: String = ""
    
    init?(map: Map) {
        if let breedsStr: [String] = try? map.value("message") {
            self.breeds = breedsStr.map { Dog(breed: $0) }
        }
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
    }
}
