//
//  descriptionBookViewController.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 01/10/22.
//

import UIKit
import AlamofireImage

class DescriptionBookViewController: UIViewController {

    var book: Book?
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var numberOfPages: UILabel!
    @IBOutlet weak var languageText: UILabel!
    @IBOutlet weak var typeText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UICornerableTextView!
    @IBOutlet weak var infoViews: UICornerableView!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadComponents()
        fixLayoutComponents()
    }

    //MARK: - Actions Methods
    
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
    
    private func fixLayoutComponents() {
//        infoViews.backgroundColor = UIColor.white
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
                //imageView.image = book.
            }
            
        }
     
    }
}
