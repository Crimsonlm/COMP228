//
//  ViewController.swift
//  Dice rolling
//
//  Created by 康景炫 on 2020/12/15.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var inputbox: UITextField!
    @IBAction func guess(_ sender: Any) {
        let diceRoll = Int.random(in: 2..<13)
        let  guess = inputbox.text!
        if Int(guess) == diceRoll {
            outputbox.text = "猜对了,骰子的结果是\(diceRoll)"
           
        }else{
            outputbox.text = "猜错了,骰子的结果是\(diceRoll)"
            
        

        }
        inputbox.resignFirstResponder()
     
    }
    
    @IBOutlet weak var outputbox: UILabel!
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputbox.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputbox.delegate = self
        // Do any additional setup after loading the view.
    }


}

