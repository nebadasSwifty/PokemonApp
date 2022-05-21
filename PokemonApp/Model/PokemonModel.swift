//
//  PokemonModel.swift
//  PokemonApp
//
//  Created by Кирилл on 19.05.2022.
//

import Foundation


struct Pokemon: Codable {
    var results: [PokemonEntry]
}

struct PokemonEntry: Codable {
    let name: String
    let url: String
}

struct PokemonSelection: Codable {
    let sprites: PokemonSprites
}

struct PokemonSprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
