//
//  ViewController.swift
//  Research Papers
//
//  Created by 康景炫 on 2020/12/17.
//

import UIKit

class ViewController: UIViewController {
    var paperTitle :String?
    var paperYear :String?
    var paperAuthors :String?
    var paperEmail :String?
    var paperAbstract :String?
    var paperUrl :URL?
    @IBOutlet weak var Titel: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var abstract: UITextView!
    @IBOutlet weak var url: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Titel.text = paperTitle
        year.text = paperYear
        authors.text = paperAuthors
        email.text = paperEmail
        abstract.text = paperAbstract
        abstract.isEditable = false
        url.text = paperUrl?.absoluteString
        url.isEditable = false
                url.isSelectable = true
                url.dataDetectorTypes = .link
    }


}

