//
//  CollectionViewController.swift
//  PokemonApp
//
//  Created by Кирилл on 19.05.2022.
//

import UIKit
import SDWebImage


private let reuseIdentifier = "Cell"
private let url = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=20"

class CollectionViewController: UICollectionViewController {
    var pokemonList: [PokemonEntry] = []
    var pokemonName: String?
    @IBOutlet weak var pokeView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    private func fetchData() {
        NetworkManager.getData(url: url) { pokemons in
            self.pokemonList = pokemons
            DispatchQueue.main.async {
                self.pokeView.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else { return }
        detailVC.configureCell(name: pokemonName!)
        
    }
    
    private func configureCell(cell: PokemonCell, for indexPath: IndexPath) {
        NetworkManager.getDetailInfo(name: pokemonList[indexPath.row].name) { pokemons in
            cell.pokemonName.text = self.pokemonList[indexPath.row].name
            guard let url = URL(string: pokemons.sprites.frontDefault) else { return }
            DispatchQueue.main.async {
                cell.imageView.sd_setImage(with: url)
            }
        }
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = pokemonList[indexPath.row]
        pokemonName = pokemon.name
        performSegue(withIdentifier: "detailPokemon", sender: nil)
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokemonCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
}
