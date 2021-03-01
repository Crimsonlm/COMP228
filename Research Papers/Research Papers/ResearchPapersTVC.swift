//
//  ResearchPapersTVC.swift
//  Research Papers
//
//  Created by 康景炫 on 2020/12/17.
//

import UIKit
var currentcell = -1
class ResearchPapersTVC: UITableViewController{
    var reports:technicalReports? = nil
    
    @IBOutlet var theTable: UITableView!
    override func viewDidLoad() {
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/techreports/data.php?class=techreports2") {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let reportList = try decoder.decode(technicalReports.self, from: jsonData)
                    self.reports = reportList
                    DispatchQueue.main.async {
                        self.updateTheTable()
                    }
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
            }.resume()
        }
    
    }
    
    func updateTheTable() {
        theTable.reloadData()
     }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reports?.techreports2.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "theCell")
        //deque 和init区别。
         cell.textLabel?.text = reports?.techreports2[indexPath.row].title ?? "no title"
        cell.detailTextLabel?.text = reports?.techreports2[indexPath.row].authors ?? "no authors"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentcell = indexPath.row
        performSegue(withIdentifier: "detail", sender: nil)//在理解下nil
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            let detaildate = segue.destination as! ViewController
                detaildate.paperTitle = reports?.techreports2[currentcell].title ?? "no title"
                detaildate.paperYear = reports?.techreports2[currentcell].year ?? "no year"
                detaildate.paperAuthors = reports?.techreports2[currentcell].authors ?? "no authors"
                detaildate.paperEmail = reports?.techreports2[currentcell].email ?? "no email"
                detaildate.paperAbstract = reports?.techreports2[currentcell].abstract ?? "no abstract"
                detaildate.paperUrl = reports?.techreports2[currentcell].pdf 
            
            }
//            print(currentcell)
//            detaildate.paperTitle = reports?.techreports2[currentcell].title ?? "no title"
//            detaildate.paperYear = reports?.techreports2[currentcell].year ?? "no year"
//            detaildate.paperAuthors = reports?.techreports2[currentcell].authors ?? "no authors"
//            detaildate.paperEmail = reports?.techreports2[currentcell].email ?? "no email"
//            detaildate.paperAbstract = reports?.techreports2[currentcell].abstract ?? "no abstract"
            
        }
    }
    
    

