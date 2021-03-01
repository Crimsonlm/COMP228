//
//  PlacesViewController.swift
//  My Favorite Places
//
//  Created by 康景炫 on 2020/12/17.
//

import UIKit



class PlacesViewController: UITableViewController {
    
    
    var currentPlace = -1
    @IBOutlet var table: UITableView!
    

    @IBAction func edit(_ sender: Any) {
        if(self.tableView.isEditing == true)
         {
             self.tableView.isEditing = false
             self.navigationItem.leftBarButtonItem?.title = "Edit"
         }
         else
         {
             self.tableView.isEditing = true
             self.navigationItem.leftBarButtonItem?.title = "Done"
         }
        
    }
    var places:[Place] = .init()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
    }
    

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        cell.textLabel?.text = places[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPlace = indexPath.row
        performSegue(withIdentifier: "toMap", sender: nil)
    }

    override func viewDidAppear(_ animated: Bool) {

       
        currentPlace = -1
        places = DataManager.shared.getAllPlaces()
        places.insert(Place.init(name: "Ashton Building", lat: 53.406566, lon: -2.966531), at: 0)
        table.reloadData()
        
       
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            DataManager.shared.removePlace(places[indexPath.row])
            places.remove(at: indexPath.row)
           
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toMap" {
                if let destVc = segue.destination as? ViewController {
                    if currentPlace > 0 {
                        destVc.place = places[currentPlace]
                    } else {
                        destVc.place = Place.init(name: "Ashton Building", lat: 53.406566, lon: -2.966531)
                    }
                }
            }
        }
    
}
