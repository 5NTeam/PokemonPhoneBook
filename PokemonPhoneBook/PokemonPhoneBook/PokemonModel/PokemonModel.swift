//
//  PokemonModel.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/6/24.
//

import UIKit

struct PokemonModel: Codable {
    let id: String
    let name: String
    let sprites: [PokemonSprites]
}

struct PokemonSprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
