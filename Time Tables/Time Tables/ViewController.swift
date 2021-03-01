//
//  ViewController.swift
//  Time Tables
//
//  Created by 康景炫 on 2020/12/16.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var mytable: UITableView!//tableview里的通过这个刷新
    @IBOutlet weak var inputbox: UITextField!
    @IBAction func go(_ sender: Any) {
        mytable.reloadData()
        inputbox.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "myCell")
        //if let 判断空
        if let text = inputbox.text, let num = Int(text){
            myCell.textLabel?.text = "\(num)x\(indexPath.row+1)= \(num*indexPath.row)"
        }
          
        
        return myCell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
	

}
