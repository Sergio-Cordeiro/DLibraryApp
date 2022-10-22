//
//  descriptionBookViewController.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 01/10/22.
//

import UIKit
import FirebaseAuth
import AlamofireImage
import FirebaseDatabase

class DescriptionBookViewController: UIViewController {

    //MARK: - Properties
    
    var book: Book?
    var isOptionSaveScreenAvaliable: Bool = true
    var ref: DatabaseReference?
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var numberOfPages: UILabel!
    @IBOutlet weak var languageText: UILabel!
    @IBOutlet weak var typeText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UICornerableTextView!
    @IBOutlet weak var infoViews: UICornerableView!
    @IBOutlet weak var saveButton: UICornerableButton!
    @IBOutlet weak var preBookVisualizer: UICornerableButton!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        ref = Database.database().reference()
        loadComponents()
        fixLayoutComponents()
    }

    //MARK: - Actions Methods
    
    @IBAction func saveBook(_ sender: Any) {
        if let userUid = DLibraryManager.sharedInstance.user?.uid, let bookDict = returnBook() {
            self.ref?.child("users").child(userUid).child("livros").childByAutoId().setValue(bookDict)
            successSaveAlert()
        }
    }
    
    @IBAction func openBookLink(_ sender: Any) {
        if let link = book?.previewLink {
            guard let url = URL(string: link) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private Methods
    
    private func successSaveAlert() {
        let alert = UIAlertController(title: "Livro salvo com sucesso ", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok!", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func returnBook() -> NSDictionary? {
        guard let book = book else { return nil }
        let dic: NSDictionary = [
            "id": "\(book.id)",
            "description": "\(book.description)",
            "title": "\(book.title)",
            "printType": "\(book.type)",
            "pageCount": book.pagesCount,
            "language": "\(book.language)",
            "imageLinks": book.images,
            "previewLink": "\(book.previewLink)",
        ]
        return dic
    }
    
    private func fixLayoutComponents() {
        if !isOptionSaveScreenAvaliable {
            saveButton.isHidden = true
            if book?.previewLink == "" {
                preBookVisualizer.isHidden = true
            }
        }
        overrideUserInterfaceStyle = .light
        infoViews.layer.shadowColor = UIColor.black.cgColor
        infoViews.layer.shadowOpacity = 5.24
        infoViews.layer.shadowOffset = .zero
        infoViews.layer.shadowRadius = 3
        infoViews.layer.cornerRadius = 10
        
        descriptionText.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        descriptionText.layer.opacity = 0.8
        descriptionText.backgroundColor = UIColor.white
        descriptionText.layer.shadowColor = UIColor.black.cgColor
        descriptionText.layer.shadowOpacity = 5.24
        descriptionText.layer.shadowOffset = .zero
        descriptionText.layer.shadowRadius = 3
        descriptionText.layer.cornerRadius = 10
    }
    
    
    private func loadComponents() {
        if let book = book {
            titleText.text = book.title
            numberOfPages.text = "Numero de paginas: \(book.pagesCount)"
            languageText.text = "Linguagem do Livro: \(book.language)"
            typeText.text = "Tipo do livro: \(book.type)"
            descriptionText.text = book.description
            
            if let imageBookLink: String  = book.images["thumbnail"] {
                
                let http = URL(string: imageBookLink)!
                var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)!
                comps.scheme = "https"
                let https = comps.url!
                
                imageView.af.setImage(
                                withURL: https,
                                placeholderImage: UIImage(named: "Placeholder Image"),
                                filter: nil,
                                imageTransition: UIImageView.ImageTransition.crossDissolve(0.5),
                                runImageTransitionIfCached: false) {_ in }
            }
            
        }
     
    }
}
