//
//  PokeImage.swift
//  PokemonPhoneBook
//
//  Created by 내일배움캠프 on 12/10/24.
//

import Foundation

struct PokemonModel: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: PokemonSprites
}

struct PokemonSprites: Decodable {
    let frontDefault: String
    let frontShiny: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

