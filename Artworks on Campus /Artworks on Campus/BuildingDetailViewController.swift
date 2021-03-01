//
//  BuildingDetailViewController.swift
//  Artworks on Campus
//
//  Created by 康景炫 on 2020/12/20.
//

import UIKit

class BuildingDetailViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var artNameLabel: UILabel!
    @IBOutlet weak var theTable: UITableView!
    
    private var currentIndexPath: IndexPath?//Determine the clicked cell
    var building: Building?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return building?.artworks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "myCell")
        if let model = building?.artworks[indexPath.row]{
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.artist
        }
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        artNameLabel.text = building?.locationNotes
        artNameLabel.numberOfLines = 0

    }
    //Through the segue, click to jump to the multipleDetail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndexPath = indexPath
        performSegue(withIdentifier: "multipleDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "multipleDetail"{
            let detaildate = segue.destination as! ViewController
            detaildate.datasource = building!.artworks[currentIndexPath!.row]
    }


}
}
