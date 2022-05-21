//
//  CollectionViewController.swift
//  PokemonApp
//
//  Created by Кирилл on 19.05.2022.
//

import UIKit

private let reuseIdentifier = "Cell"


class CollectionViewController: UICollectionViewController {
    private let url = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=151"
    var pokemonList: [PokemonEntry] = []
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
    
    private func configureCell(cell: PokemonCell, for indexPath: IndexPath) {
        NetworkManager.getSprites(name: pokemonList[indexPath.row].name) { data in
            DispatchQueue.main.async {
                cell.pokemonName.text = self.pokemonList[indexPath.row].name
                cell.imageView.image = UIImage(data: data)
            }
        }
    }

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokemonCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
}
