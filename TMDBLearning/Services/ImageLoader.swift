//
//  ImageLoader.swift
//  TMDBLearning
//
//  Created by Laksh on 03/06/26.
//

import UIKit

final class ImageLoader {

    static let shared = ImageLoader()

    private init() {}

    func loadImage(
        from path: String,
        completion: @escaping (UIImage?) -> Void
    ) {

        let fullPath = "https://image.tmdb.org/t/p/w500\(path)"

        guard let url = URL(string: fullPath) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in

            guard let data = data,
                  let image = UIImage(data: data) else {

                DispatchQueue.main.async {
                    completion(nil)
                }

                return
            }

            DispatchQueue.main.async {
                completion(image)
            }

        }.resume()
    }
}
