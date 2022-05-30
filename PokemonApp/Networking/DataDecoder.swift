//
//  DataDecoder.swift
//  PokemonApp
//
//  Created by Кирилл on 30.05.2022.
//

import UIKit

struct DataDecoder {
    static func JSONDecoder<T: Codable>(_ data: Data, completion: @escaping (T) -> Void) {
        do {
            let decoder = Foundation.JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            completion(decodedData)
        } catch {
            print(error)
        }
    }
}
