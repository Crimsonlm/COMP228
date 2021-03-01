//
//  DataManage.swift
//  Artworks on Campus
//
//  Created by 康景炫 on 2020/12/18.
//

import Foundation


class Building {
    let location: String
    var lat: Double{
        return Double(artworks.first!.lat)!
    }
    var long: Double{
        return Double(artworks.first!.long)!
    }
    var locationNotes: String{
        return artworks.first!.locationNotes!
    }
    var artworks: [Artwork]
    
    init(location: String, artworks: [Artwork]) {
        self.location = location
        self.artworks = artworks
        
    }
}
