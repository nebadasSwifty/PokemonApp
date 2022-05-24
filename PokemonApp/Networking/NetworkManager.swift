//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Кирилл on 19.05.2022.
//

import UIKit
import Alamofire
import SwiftyJSON

struct NetworkManager {
    
    static func getData(url: String, completion: @escaping ([PokemonEntry]) -> Void) {
        guard let url = URL(string: url) else { return }
        AF.request(url, method: .get).validate().responseDecodable(of: Pokemon.self) { response in
            guard let data = response.data else { return }
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "pokemonList")
            do {
                let pokemons = try JSONDecoder().decode(Pokemon.self, from: userDefaults.object(forKey: "pokemonList") as! Data)
                DispatchQueue.main.async {
                    completion(pokemons.results)
                }
            } catch { print(error) }
       }
    }
    
    static func getDetailInfo(name: String, completion: @escaping (PokemonSelection) -> ()) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let info = try JSONDecoder().decode(PokemonSelection.self, from: data)
                DispatchQueue.main.async {
                    completion(info)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
}
