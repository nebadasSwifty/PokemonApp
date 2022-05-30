//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Кирилл on 19.05.2022.
//

import UIKit
import Alamofire


struct NetworkManager {
    
    static func getData(offset: Int,completion: @escaping ([PokemonEntry], Int) -> Void) {
        AF.request("https://pokeapi.co/api/v2/pokemon/?offset=\(offset)").responseDecodable(of: Pokemon.self) { data in
            guard let data = data.data else { return }
            DataDecoder.JSONDecoder(data) { (pokemons: Pokemon) in
                completion(pokemons.results, pokemons.count)
            }
        }
    }
    
    static func getDetailInfo(name: String, completion: @escaping (PokemonSelection) -> Void) {
        AF.request("https://pokeapi.co/api/v2/pokemon/\(name)").responseDecodable(of: PokemonSelection.self) { data in
            guard let data = data.data else { return }
            DataDecoder.JSONDecoder(data) { (pokemon: PokemonSelection) in
                completion(pokemon)
            }
        }
    }
}
