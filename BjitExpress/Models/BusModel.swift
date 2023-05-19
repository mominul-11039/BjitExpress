//
//  BusModel.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 18/5/23.
//

import Foundation

struct BusModel: Codable {
    enum CodingKeys: CodingKey {
        case busName
        case departureTime
        case busID
    }

    var busName: String
    var departureTime: String
    var busID: Int
}

func getBusList() -> [BusModel]  {
    guard let url = Bundle.main.url(forResource: "BusList", withExtension: "json")
        else {
            print("Json file not found")
            return []
        }
    
    let data = try? Data(contentsOf: url)
    let busList = (try? JSONDecoder().decode([BusModel].self, from: data!)) ?? []
    return busList
}
