//
//  RegisterNewBookViewController.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 12/10/22.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class RegisterNewBookViewController: UIViewController {

    //MARK: - Properties
    
    var ref: DatabaseReference?
    var storage: Storage?
    var storageRef: StorageReference?
    var userStorageRef: StorageReference?
    var linkImage: String?
    
    //MARK: - Outlets
    
    @IBOutlet weak var bookNameTf: UITextField!
    @IBOutlet weak var numberOfPagesTf: UITextField!
    @IBOutlet weak var bookType: UICornerableButton!
    @IBOutlet weak var languageButton: UICornerableButton!
    @IBOutlet weak var bookDescription: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        storage = Storage.storage()
        storageRef = storage?.reference()
        if let userUid = DLibraryManager.sharedInstance.user?.uid {
            userStorageRef = storageRef?.child("images/\(userUid)/")
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(imageTapped(tapGestureRecognizer:))
        )
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
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
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        uploadAndGenerateUrlImage(image: imageView.image!)
    }
    
    private func returnBook() -> NSDictionary? {
        let dic: NSDictionary = [
            "id": "\(returnRandomId())",
            "description": "\(returnDescription())",
            "title": "\(returnBookName())",
            "type": "\(returnBookType())",
            "pagesCount": "\(returnNumberOfPages())",
            "language": "\(returnLanguage())",
            "images": "\(linkImage ?? "")",
            "previewLink": "",
        ]
        return dic
    }
    
    private func uploadAndGenerateUrlImage(image: UIImage) {
        guard let imageData = image.pngData() else { return }
        let uploadTask = userStorageRef?.putData(imageData, metadata: nil) { (metadata, error) in
          if error != nil {
              print(error?.localizedDescription as Any)
          }
            self.userStorageRef?.downloadURL { (url, error) in
              guard let downloadURL = url else {
                  print("Erro ao obter link da imagem:")
                  print(error?.localizedDescription as Any)
                return
              }
                self.linkImage = "\(downloadURL)"
                print("Sucesso ao obter link da imagem:\(downloadURL)")
            }
        }
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
