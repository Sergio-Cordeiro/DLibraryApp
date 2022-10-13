//
//  RegisterNewBookViewController.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 12/10/22.
//

import UIKit
import FirebaseDatabase

class RegisterNewBookViewController: UIViewController {

    //MARK: - Properties
    
    var ref: DatabaseReference?
    
    //MARK: - Outlets
    
    @IBOutlet weak var bookNameTf: UITextField!
    @IBOutlet weak var numberOfPagesTf: UITextField!
    @IBOutlet weak var bookType: UICornerableButton!
    @IBOutlet weak var languageButton: UICornerableButton!
    @IBOutlet weak var bookDescription: UITextView!
    
    //TODO: Transformar uiImage em botão
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    //MARK: - Actions Methods
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBook(_ sender: Any) {
        if let userUid = DLibraryManager.sharedInstance.user?.uid, let bookDict = returnBook() {
            self.ref?.child("users").child(userUid).setValue(["livro": bookDict])
        }
    }
    
    //MARK: - Private Methods
    
    private func returnBook() -> NSDictionary? {
        let dic: NSDictionary = [
            "id": "\(returnRandomId())",
            "description": "\(returnDescription())",
            "title": "\(returnBookName())",
            "type": "\(returnBookType())",
            "pagesCount": "\(returnNumberOfPages())",
            "language": "\(returnLanguage())",
            "images": "\(book.images)",
            "previewLink": "\(book.previewLink)",
        ]
        return dic
    }
    
    private func returnRandomId() -> Int {
        return Int(arc4random_uniform(6) + 1)
    }
    
    private func returnDescription() -> String {
        return bookDescription.text
    }
    
    private func returnBookName() -> String {
        return bookNameTf.text ?? ""
    }
    
    private func returnBookType() -> String {
        if bookType.currentTitle == "Revista" {
            return "MAGAZINE"
        } else {
            return "BOOK"
        }
    }
    
    private func returnNumberOfPages() -> String {
        return numberOfPagesTf.text ?? "0"
    }
    
    private func returnLanguage() -> String {
        return languageButton.currentTitle ?? "PT"
    }
    
}
