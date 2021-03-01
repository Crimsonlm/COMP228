//
//  ViewController.swift
//  Multiple
//
//  Created by 康景炫 on 2020/12/16.
//

import UIKit
var currentcell = -1
var stuff = [("Phil","A1.20","phil@liverpool.ac.uk"),("Terry","A2.18","trp@liverpool.ac.uk"),("Valli","A2.12","V.Tamma@liverpool.ac.uk"),("Boris","A1.15","Konev@liverpool.ac.uk")]

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stuff.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "myCell")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = stuff[indexPath.row].0
        
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentcell = indexPath.row
        performSegue(withIdentifier: "detail", sender: nil)
        
    }
    //这三个label还没加载就prepare了，所以这里nil强制解包了
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
        let detaildata = segue.destination as! detailViewControl
            detaildata.userName  = stuff[currentcell].0
            detaildata.userRoom  = stuff[currentcell].1
            detaildata.userEmail  = stuff[currentcell].2
        }
    }
    

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                stuff.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }

}

