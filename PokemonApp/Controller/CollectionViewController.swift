//
//  CollectionViewController.swift
//  PokemonApp
//
//  Created by Кирилл on 19.05.2022.
//

import UIKit
import SDWebImage

class CollectionViewController: UICollectionViewController {
    private var pokemonList: [PokemonEntry] = []
    private var pokemonName: String?
    private var maximumPokemonCount = 0
    private var offsetList = 0
    @IBOutlet weak var pokeView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(offset: offsetList)
    }
    
    private func fetchData(offset: Int) {
        NetworkManager.getData(offset: offset) {
            self.pokemonList.append(contentsOf: $0)
            self.maximumPokemonCount = $1
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PokemonCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if offsetList < maximumPokemonCount && indexPath.row == pokemonList.count - 2 {
            offsetList += 20
            fetchData(offset: offsetList)
        }
    }
}

