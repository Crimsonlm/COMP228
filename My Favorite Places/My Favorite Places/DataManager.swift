//
//  DataManager.swift
//  MyFavouritePlaces
//
//  Created by 康景炫 on 2020/12/17.
//

import UIKit

struct Place {
    let id: String
    let name: String
    let lat: Double
    let lon: Double
    
    init(name: String, lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
        self.name = name
        id = String(Date().timeIntervalSince1970 * 1000)
    }
    
    init(dict: [String: Any]) {
        self.lon = dict["lon"] as! Double
        self.lat = dict["lat"] as! Double
        self.name = dict["name"] as! String
        self.id = dict["id"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["lon": lon,
                "lat": lat,
                "name": name,
                "id": id
        ]
    }
}

class DataManager: NSObject {
    static let shared: DataManager = .init()
    
    private let placeKey: String = "places"
    
    func getAllPlaces() -> [Place] {
        if let array = UserDefaults.standard.array(forKey: placeKey) {
            return array.compactMap({Place.init(dict: $0 as! [String : Any])})
        } else {
            return [Place].init()
        }
    }

    func addPlace(_ place: Place) {
        var array = UserDefaults.standard.array(forKey: placeKey) ?? [[String: Any]].init()
        array.append(place.toDict())
        UserDefaults.standard.setValue(array, forKey: placeKey)
    }
    
    func removePlace(_ place: Place) {
        let array = getAllPlaces().filter({place.id != $0.id})
        UserDefaults.standard.setValue(array.compactMap({$0.toDict()}), forKey: placeKey)
    }
    
    func removeAllPlaces() {
        UserDefaults.standard.removeObject(forKey: placeKey)
    }
}
