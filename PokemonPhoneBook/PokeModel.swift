//
//  PokeImage.swift
//  PokemonPhoneBook
//
//  Created by 내일배움캠프 on 12/10/24.
//

import Foundation

struct PokeModel: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: PokeSprites
}

struct PokeSprites: Decodable {
    let frontDefault: String
    let frontShiny: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

