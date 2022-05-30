//
//  DetailViewController.swift
//  PokemonApp
//
//  Created by Кирилл on 21.05.2022.
//

import UIKit
import SDWebImage

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
        NetworkManager.getDetailInfo(name: name) { [weak self] pokemon in
            self?.title = pokemon.name.localizedCapitalized
            self?.pokeNameLabel.text = pokemon.name
            self?.pokeWeightLabel.text = String(describing: pokemon.weight)
            self?.pokeHeightLabel.text = String(describing: pokemon.height)
            self?.pokeTypeLabel.text = pokemon.types.first?.type.name
            self?.pokeOrderLabel.text = String(describing: pokemon.order)
            self?.pokeBaseExpLabel.text = String(describing: pokemon.baseExperience)
            self?.pokeFirstAbilityLabel.text = pokemon.abilities?.first?.ability.name
            guard let url = URL(string: pokemon.sprites.frontDefault) else { return }
            DispatchQueue.main.async {
                self?.pokeImage.sd_setImage(with: url)
            }
        }
    }
}
