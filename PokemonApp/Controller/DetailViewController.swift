//
//  DetailViewController.swift
//  PokemonApp
//
//  Created by Кирилл on 21.05.2022.
//

import UIKit

class DetailViewController: UITableViewController {
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var pokeNameLabel: UILabel!
    @IBOutlet weak var pokeWeightLabel: UILabel!
    @IBOutlet weak var pokeHeightLabel: UILabel!
    @IBOutlet weak var pokeOrderLabel: UILabel!
    @IBOutlet weak var pokeBaseExpLabel: UILabel!
    @IBOutlet weak var pokeTypeLabel: UILabel!
    @IBOutlet weak var pokeFirstAbilityLabel: UILabel!
    

    func configureCell(name: String) {
        NetworkManager.getDetailInfo(name: name) { [weak self] pokemon, data in
            self?.title = pokemon.name.localizedCapitalized
            self?.pokeNameLabel.text = pokemon.name
            self?.pokeWeightLabel.text = String(pokemon.weight)
            self?.pokeHeightLabel.text = String(pokemon.height)
            self?.pokeTypeLabel.text = pokemon.types[0].type.name
            self?.pokeOrderLabel.text = String(pokemon.order)
            self?.pokeBaseExpLabel.text = String(pokemon.baseExperience)
            self?.pokeFirstAbilityLabel.text = pokemon.abilities?[0].ability.name
            DispatchQueue.main.async {
                self?.pokeImage.image = UIImage(data: data)
            }
        }
    }
}
