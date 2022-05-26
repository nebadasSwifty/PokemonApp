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
        AF.request("https://pokeapi.co/api/v2/pokemon/?offset=\(offset)").responseDecodable(of: Pokemon.self) { response in
            guard let data = response.data else { return }
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "pokemonList")
            do {
                let pokemons = try JSONDecoder().decode(Pokemon.self, from: userDefaults.object(forKey: "pokemonList") as! Data)
                completion(pokemons.results, pokemons.count)
            } catch { print(error) }
        }
    }
    
    static func getDetailInfo(name: String, completion: @escaping (PokemonSelection) -> Void) {
        AF.request("https://pokeapi.co/api/v2/pokemon/\(name)").responseDecodable(of: PokemonSelection.self) { data in
            guard let data = data.data else { return }
            do {
                let info = try JSONDecoder().decode(PokemonSelection.self, from: data)
                DispatchQueue.main.async {
                    completion(info)
                }
            } catch { print(error) }
        }
    }
}
