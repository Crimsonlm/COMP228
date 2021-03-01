//
//  ViewController.swift
//  Artworks on Campus
//
//  Created by 康景炫 on 2020/12/18.
//

import UIKit

class ViewController: UIViewController {
    
    var datasource: Artwork?
    
    //Artwork display page
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = datasource?.locationNotes
        self.authorLabel.text = datasource?.artist
        self.titleLabel.text = datasource?.title
        self.yearLabel.text = "Made in \(datasource?.yearOfWork ?? "")"
        self.yearLabel.textColor = .gray
        self.textView.text = datasource?.information
        self.textView.isEditable = false
        loadImage(name: datasource!.fileName!) { (result) in
                    switch result {
                    case .failure(_):
                        break
                    case .success(let image):
                        DispatchQueue.main.async {
                            self.imageview.image = image
                        }
                    }
        }
    }
    //Callback, load image asynchronously
    func loadImage(name: String, handler:@escaping (Result<UIImage, Error>) -> Void) {
            let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artwork_images/\(name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            URLSession.shared.downloadTask(with: url) { (url, response, error) in
                guard error == nil else {
                    handler(.failure(error!))
                    return
                }
                guard let fileURL = url else {
                    handler(.failure(NSError.init(domain: "API", code: 0, userInfo: [NSLocalizedDescriptionKey: "cannot find image url"])))
                    return
                }
                guard let data = NSData(contentsOf: fileURL), let image = UIImage.init(data: (data as Data), scale: UIScreen.main.scale) else {
                    handler(.failure(NSError.init(domain: "API", code: 0, userInfo: [NSLocalizedDescriptionKey: "Decode into uiimage failed"])))
                    return
                }
                handler(.success(image)) //Result
            }.resume()
        }
}


