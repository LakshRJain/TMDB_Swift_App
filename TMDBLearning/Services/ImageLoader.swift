import UIKit

final class ImageLoader {

    static let shared = ImageLoader()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func loadImage(
        from path: String,
        completion: @escaping (UIImage?) -> Void
    ) {

        if let cachedImage = cache.object(
            forKey: path as NSString
        ) {

            completion(cachedImage)
            return
        }

        let fullPath = "https://image.tmdb.org/t/p/w500\(path)"

        guard let url = URL(string: fullPath) else {

            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) {
            [weak self] data, _, error in

            guard let self = self else {
                return
            }

            guard error == nil,
                  let data = data,
                  let image = UIImage(data: data) else {

                DispatchQueue.main.async {
                    completion(nil)
                }

                return
            }

            self.cache.setObject(
                image,
                forKey: path as NSString
            )

            DispatchQueue.main.async {
                completion(image)
            }

        }.resume()
    }
}
