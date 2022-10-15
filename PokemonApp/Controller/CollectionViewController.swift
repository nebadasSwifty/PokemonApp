//
//  CollectionViewController.swift
//  PokemonApp
//
//  Created by Кирилл on 19.05.2022.
//

import UIKit
import SDWebImage

class CollectionViewController: UICollectionViewController {
    private var pokemonList: [PokemonSelection] = []
    private var favoritePokemons: [PokemonSelection] = []
    private var maximumPokemonCount = 0
    private var offsetList = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(offset: offsetList)
    }
    
    private func fetchData(offset: Int) {
        var loadedPokemonsCount = 0
        NetworkManager.getData(offset: offset, completion: { [weak self] pokemons, pokemonsCount in
            self?.maximumPokemonCount = pokemonsCount
            pokemons.forEach({
                NetworkManager.getDetailInfo(name: $0.name, completion: {
                    loadedPokemonsCount += 1
                    self?.pokemonList.append($0)
                    
                    if loadedPokemonsCount == pokemons.count {
                        self?.collectionView.reloadData()
                    }
                })
            })
        })
    }
    
    @objc private func likePokemon(sender: UIButton) {
        guard let cell = sender.superview?.superview as? PokemonCell else {
            return
        }
        
        let pokemon: PokemonSelection?
        
        if pokemonList.contains(where: { $0.name == cell.pokemonName.text }) {
            pokemon = pokemonList.first(where: { $0.name == cell.pokemonName.text })
            favoritePokemons.append(pokemon!)
            pokemonList.removeAll(where: { $0.name == pokemon?.name })
        } else {
            pokemon = favoritePokemons.first(where: { $0.name == cell.pokemonName.text })
            pokemonList.append(pokemon!)
            favoritePokemons.removeAll(where: { $0.name == pokemon?.name })
        }
        
        collectionView.reloadData()
    }
    
    private func configureCell(cell: PokemonCell, for indexPath: IndexPath) {
        let pokemon: PokemonSelection
        
        if indexPath.section == 0 && !favoritePokemons.isEmpty {
            pokemon = favoritePokemons[indexPath.item]
            cell.likeButton.setTitle("👎 Dislike", for: .normal)
        } else {
            pokemon = pokemonList[indexPath.item]
            cell.likeButton.setTitle("👍 Like", for: .normal)
        }
        
        cell.likeButton.addTarget(self, action: #selector(likePokemon(sender:)), for: .touchUpInside)
        cell.pokemonName.text = pokemon.name
        
        if let url = URL(string: pokemon.sprites.frontDefault) {
            cell.imageView.sd_setImage(with: url)
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
            
            if indexPath.section == 0 && !favoritePokemons.isEmpty {
                controller.selectedPokemon = favoritePokemons[indexPath.item]
            } else {
                controller.selectedPokemon = pokemonList[indexPath.item]
            }
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return favoritePokemons.isEmpty ? 1 : 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? favoritePokemons.isEmpty ? pokemonList.count : favoritePokemons.count : pokemonList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PokemonCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if offsetList < maximumPokemonCount && indexPath.row == pokemonList.count - 1 {
            offsetList += 20
            fetchData(offset: offsetList)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! PokeViewHeader
        
        if indexPath.section == 0 && !favoritePokemons.isEmpty {
            view.setText(text: "Favorite Pokemons")
        } else {
            view.setText(text: "All Pokemons")
        }
        
        return view
    }
}

final class PokeViewHeader: UICollectionReusableView {
    @IBOutlet weak private var titleLabel: UILabel!
    
    func setText(text: String) {
        titleLabel.text = text
    }
}
