//
//  detailViewControl.swift
//  Multiple
//
//  Created by 康景炫 on 2020/12/16.
//

import UIKit

class detailViewControl: UIViewController {
    
    var userName :String?//如果没？号，要初始化
    var userRoom :String?
    var userEmail :String?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var email: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = userName
        room.text = userRoom
        email.text = userEmail

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
