//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Кирилл on 19.05.2022.
//

import UIKit


struct NetworkManager {
    
    static func getData(url: String, completion: @escaping ([PokemonEntry]) -> ()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            do {
                let pokemons = try JSONDecoder().decode(Pokemon.self, from: data)
                DispatchQueue.global().async {
                    completion(pokemons.results)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    static func getDetailInfo(name: String, completion: @escaping (PokemonSelection, Data) -> ()) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let info = try JSONDecoder().decode(PokemonSelection.self, from: data)
                guard let url = URL(string: info.sprites.frontDefault) else { return }
                guard let image = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async {
                    completion(info, image)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
}
