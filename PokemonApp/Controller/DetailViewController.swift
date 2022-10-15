//
//  DetailViewController.swift
//  PokemonApp
//
//  Created by Кирилл on 21.05.2022.
//

import UIKit
import SDWebImage

final class DetailViewController: UITableViewController {
    var selectedPokemon: PokemonSelection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedSectionHeaderHeight = 64
        tableView.register(UINib(nibName: "TitleHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        title = selectedPokemon.name.localizedCapitalized
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 || section == 3 {
            return section == 2 ? selectedPokemon.types.count : selectedPokemon.abilities?.count ?? 0
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonImageCell") as! PokemonImageCell
            cell.setupImage(pokemonImageUrl: selectedPokemon.sprites.frontDefault)
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonDetailInfo") as! PokemonDetailInfoCell
            cell.setupPokemonDetailCell(pokemon: selectedPokemon)
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonAbilityTypes") as! PokemonAbilitiesTypesCell
            let type = selectedPokemon.types[indexPath.row]
            
            cell.setup(text: type.type.name)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonAbilityTypes") as! PokemonAbilitiesTypesCell
            let ability = selectedPokemon.abilities?[indexPath.row]
            
            cell.setup(text: ability?.ability.name ?? "")
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! TitleHeader
        
        if section == 1 {
            view.setup(text: "Pokemon Info")
        } else if section == 2 {
            view.setup(text: "Types")
        } else if section == 3 {
            view.setup(text: "Abilities")
        } else {
            return nil
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

final class PokemonImageCell: UITableViewCell {
    @IBOutlet private weak var pokeImage: UIImageView!
    
    func setupImage(pokemonImageUrl url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        pokeImage.sd_setImage(with: url)
    }
}

final class PokemonDetailInfoCell: UITableViewCell {
    @IBOutlet private weak var pokeNameLabel: UILabel!
    @IBOutlet private weak var pokeWeightLabel: UILabel!
    @IBOutlet private weak var pokeHeightLabel: UILabel!
    @IBOutlet private weak var pokeOrderLabel: UILabel!
    @IBOutlet private weak var pokeBaseExperienceLabel: UILabel!
    
    func setupPokemonDetailCell(pokemon: PokemonSelection) {
        pokeNameLabel.text = pokemon.name
        pokeWeightLabel.text = "\(pokemon.weight)"
        pokeHeightLabel.text = "\(pokemon.height)"
        pokeOrderLabel.text = "\(pokemon.order)"
        pokeBaseExperienceLabel.text = "\(pokemon.baseExperience)"
    }
}

final class PokemonAbilitiesTypesCell: UITableViewCell {
    @IBOutlet private weak var pokeAbilitiesTypesLabel: UILabel!
    
    func setup(text: String) {
        pokeAbilitiesTypesLabel.text = text
    }
}

final class TitleHeader: UITableViewHeaderFooterView {
    @IBOutlet private weak var title: UILabel!
    
    func setup(text: String) {
        title.text = text
    }
}
