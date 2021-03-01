
//
//  Api.swift
//  Artworks on Campus
//
//  Created by 康景炫 on 2020/12/20.
//

import UIKit
import CoreData

class Api: NSObject {
    static let shared: Api = .init()
    
 
    func fetchArtworks(lastModified date:String?, context: NSManagedObjectContext, handler: @escaping (Result<[Artwork], Error>) -> Void) {
        let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artworksOnCampus/data.php?class=artworks&lastModified" + (date != nil ? "=\(date!)" : ""))!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            
            guard data != nil else {
                let error = NSError(domain: "data_null", code: -1, userInfo: [NSLocalizedDescriptionKey: "data null"])
                handler(.failure(error))
                return
            }
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
            
            guard let dictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as? [AnyHashable: Any], let allArtworksJson = dictionary["artworks"] as? [[AnyHashable: Any]], let data = try? JSONSerialization.data(withJSONObject: allArtworksJson) else  {
                let error = NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: "data invalid"])
                handler(.failure(error))
                return
            }
            guard let allartworks = try? decoder.decode([Artwork].self, from: data) else {
                let error = NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: "decode Failed"])
                handler(.failure(error))
                return
            }
            handler(.success(allartworks))
        }.resume()
    }
}
