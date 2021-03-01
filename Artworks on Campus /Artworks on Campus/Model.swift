//
//  Model.swift
//  Artworks on Campus
//
//  Created by 康景炫 on 2020/12/20.
//

import Foundation
import CoreData
extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

public class Artwork: NSManagedObject, Decodable {
    struct Name {
        static let id = "id"
        static let yearOfWork = "yearOfWork"
    }
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var artist: String
    @NSManaged public var lat: String
    @NSManaged public var long: String
    @NSManaged public var location: String
    @NSManaged public var enabled: String?
    @NSManaged public var fileName: String?
    @NSManaged public var information: String?
    @NSManaged public var lastModified: String?
    @NSManaged public var locationNotes: String?
    @NSManaged public var type: String?
    @NSManaged public var yearOfWork: String?
    
    required convenience public init(from decoder: Decoder) throws {
        guard let managedObjectContext = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext, let entity = NSEntityDescription.entity(forEntityName: "Artwork", in: managedObjectContext) else {
            fatalError("Failed to decode Artwork")
        }
        self.init(entity: entity, insertInto: managedObjectContext)

        let values = try decoder.container(keyedBy: CodingKeys.self)
        artist = try values.decode(String.self, forKey: .artist)
        enabled = try values.decodeIfPresent(String.self, forKey: .enabled)
        fileName  = try values.decodeIfPresent(String.self, forKey: .fileName)
        id = try values.decode(String.self, forKey: .id)
        information = try values.decodeIfPresent(String.self, forKey: .information)
        lastModified = try values.decodeIfPresent(String.self, forKey: .lastModified)
        lat = try values.decode(String.self, forKey: .lat)
        location = try values.decode(String.self, forKey: .location)
        locationNotes = try values.decodeIfPresent(String.self, forKey: .locationNotes)
        long = try values.decode(String.self, forKey: .long)
        title = try values.decode(String.self, forKey: .title)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        yearOfWork = try values.decodeIfPresent(String.self, forKey: .yearOfWork)
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artwork> {
        return NSFetchRequest<Artwork>(entityName: "Artwork")
    }
    
    enum CodingKeys: String, CodingKey {
        case artist
        case enabled
        case fileName
        case id
        case information = "Information"
        case lastModified
        case lat
        case location
        case locationNotes
        case long
        case title
        case type
        case yearOfWork
    }
}


