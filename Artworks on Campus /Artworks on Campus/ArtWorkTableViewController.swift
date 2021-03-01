//
//  ArtWorkTable.swift
//  Artworks on Campus
//
//  Created by 康景炫 on 2020/12/18.
//

import UIKit
import MapKit
import CoreData

class ArtWorkTableViewController: UIViewController ,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate{
    

        open lazy var applicationDocumentsDirectory: NSURL = {
            // The directory the application uses to store the Core Data store file.
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.count-1] as NSURL
        }()
        lazy var managedObjectModel: NSManagedObjectModel = {
            // The managed object model for the application.
            let modelURL = Bundle.main.url(forResource: "Artworks_on_Campus", withExtension: "momd")!
            return NSManagedObjectModel(contentsOf: modelURL)!
        }()
        lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
            // Create the coordinator and store
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            let url = self.applicationDocumentsDirectory.appendingPathComponent("MyCoreDataProject.sqlite")
            var failureReason = "There was an error creating or loading the application's saved data."
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: url, options: nil)
            } catch {
                // Report any error we got.
                abort()
            }
            return coordinator
        }()
        
        open lazy var managedObjectContext: NSManagedObjectContext? = {
            // Returns the managed object context for the application
            let coordinator = self.persistentStoreCoordinator
            var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = coordinator
            return managedObjectContext
        }()
    
    private var currentArtwork: Artwork?
    var locationManager = CLLocationManager()
    private var currentBuilding: Building?
    
    //Put all the buildings into an array
    var datasource: [Building] = .init()
    
    //Provide the current location of buildingc and initialize it to the coordinates of ashton
    var Buildingc = (latitude: 53.406566, longitude: -2.966531)

    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var theTable: UITableView!
    override func viewDidLoad() {
        self.Map.delegate = self
        locationManager.delegate = self as CLLocationManagerDelegate
         locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
         locationManager.requestWhenInUseAuthorization()
         locationManager.startUpdatingLocation()
        dataSaved()//Display data locally
        let lastDate: String? = UserDefaults.standard.string(forKey: "lastdate")
        Api.shared.fetchArtworks(lastModified: lastDate, context: managedObjectContext!) { (result) in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let artworks):
            //Format the current date into the same form as lastmodified for comparison
              let date = Date()
              let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                let currentDateString = dateFormatter.string(for: date)
                UserDefaults.standard.setValue(currentDateString, forKey: "lastdate")
                self.syncDatabase(artworks: artworks)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataSaved), name:.NSManagedObjectContextDidSave, object: nil)
        
    }
    //Get data from coredata, update ui
    @objc private func dataSaved() {
            let context = managedObjectContext!
            if let artworks = try? context.fetch(Artwork.fetchRequest()) as? [Artwork] {
                self.updateUI(artworks)
            }
        }
    //Synchronize data
    //If there is the same data, delete the old one and add the new, if not, add it directly
    private func syncDatabase(artworks: [Artwork]) {
            let context = managedObjectContext!
            context.perform {
                var oldArtworks = [Artwork].init()
                for b in self.datasource {
                    oldArtworks.append(contentsOf: b.artworks)
                }
                
                // add new artworks to core data
                for item in artworks {
                    if let old = oldArtworks.first(where: {$0.id == item.id}) {
                        context.delete(old)
                    }
                    context.insert(item)
                }
                try? context.save()
            }
        }
    
    //Update the content in the map and tableview
    private func updateUI(_ allArtworks: [Artwork]) {
        self.datasource = self.distinct(artworks: allArtworks)
        DispatchQueue.main.async { [self] in
            self.Map.removeAnnotations(self.Map.annotations)
            for aBuilding in self.datasource{
                set(aBuilding: aBuilding)
            }
            self.updateTheTable()
        }
    }
    //Reload tableview
    func updateTheTable() {
        theTable.reloadData()
    }
    //Update the current location and assign it to buildingc
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     let locationOfUser = locations[0]
     let latitude = locationOfUser.coordinate.latitude
     let longitude = locationOfUser.coordinate.longitude
     let latDelta: CLLocationDegrees = 0.002
     let lonDelta: CLLocationDegrees = 0.002
     let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
     let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
     let region = MKCoordinateRegion(center: location, span: span)
     self.Map.setRegion(region, animated: true)
        Buildingc.latitude = location.latitude
        Buildingc.longitude = location.longitude
        var artwork: [Artwork] = .init()
        for i in datasource{
            artwork.append(contentsOf: i.artworks)
        }
        updateUI(artwork)
     
        
        
     }
    
    
    //Place buildings with artworks in the array of buildings
    private func distinct(artworks: [Artwork]) -> [Building] {
            var buildings: [Building] = .init()
            for artwork in artworks {
                if artwork.enabled == "1" {
                    if let building = buildings.first(where: {$0.location == artwork.location}) {
                        var beforeArtworks = building.artworks
                        beforeArtworks.append(artwork)
                        building.artworks = beforeArtworks
                    } else {
                        buildings.append(.init(location: artwork.location, artworks: [artwork]))
                    }
                }
           
            }
        //Sort by distance from the current building
        buildings.sort { (Buildinga, Buildingb) -> Bool in
                    let a = CLLocation(latitude: Buildinga.lat, longitude: Buildinga.long)
                    let b = CLLocation(latitude: Buildingb.lat, longitude: Buildingb.long)
                    let o = CLLocation(latitude: Buildingc.latitude, longitude: Buildingc.longitude)
                    
                    let d0 = a.distance(from: o)
                    let d1 = b.distance(from: o)
                    return d0 < d1
                }
            return buildings
        }
        //Add building annotation
    private func set(aBuilding: Building) {
        let coordinate = CLLocationCoordinate2D(latitude: aBuilding.lat, longitude: aBuilding.long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = aBuilding.locationNotes
        self.Map.addAnnotation(annotation)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datasource[section].artworks.first?.locationNotes
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datasource[section].artworks.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "theCell")
        cell.textLabel?.text = datasource[indexPath.section].artworks[indexPath.row].title
        cell.detailTextLabel?.text = datasource[indexPath.section].artworks[indexPath.row].artist
       cell.textLabel?.numberOfLines = 0
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentArtwork = datasource[indexPath.section].artworks[indexPath.row]
        performSegue(withIdentifier: "detail", sender: nil)
    }
    
    
    
    
    //Click on the annotation on the map
    //if it is one, jump to the artwork detail interface through the detail segue
    //if there are more than one, pull up an artwork list interface through imagedetailsegue
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let building = datasource.first(where: {$0.locationNotes == view.annotation?.title}) {
                          
                    if building.artworks.count == 1{
                        currentArtwork = building.artworks.first!
                        performSegue(withIdentifier: "detail", sender: nil)
                      
                    }else{
                        self.currentBuilding = building
                        performSegue(withIdentifier: "imagedetail", sender: nil)
                    }
                           
                        }
        
    
        }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            let detaildate = segue.destination as! ViewController
            detaildate.datasource = currentArtwork
        }
        if segue.identifier == "imagedetail"{
            let detaildate = segue.destination as! BuildingDetailViewController
            detaildate.building = self.currentBuilding
            self.currentBuilding = nil
            
        }
        
    }


}
