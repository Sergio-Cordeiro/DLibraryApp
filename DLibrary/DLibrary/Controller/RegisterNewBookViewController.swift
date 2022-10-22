//
//  RegisterNewBookViewController.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 12/10/22.
//

import UIKit
import iOSDropDown
import FirebaseStorage
import FirebaseDatabase
import ALCameraViewController

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
    @IBOutlet weak var typeBook: DropDown!
    @IBOutlet weak var languageBook: DropDown!
    @IBOutlet weak var bookDescription: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        ref = Database.database().reference()
        hideKeyboardWhenTappedAround()
        storage = Storage.storage()
        storageRef = storage?.reference()
        if let userUid = DLibraryManager.sharedInstance.user?.uid {
            userStorageRef = storageRef?.child("images/\(userUid)/")
        }
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(imageTapped(tapGestureRecognizer:))
        )
        typeBook.optionArray = ["Livro", "Revista"]
        languageBook.optionArray = ["EN", "PT", "ES"]
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    //MARK: - Actions Methods
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBook(_ sender: Any) {
        if let userUid = DLibraryManager.sharedInstance.user?.uid, let bookDict = returnBook() {
            self.ref?.child("users").child(userUid).child("livros").childByAutoId().setValue(bookDict)
            confirmSaveBook()
        }
    }
    
    //MARK: - Private Methods
    
    private func confirmSaveBook() {
        successSaveAlert()
        dismiss(animated: true, completion: nil)
    }
    
    private func successSaveAlert() {
        let alert = UIAlertController(title: "Livro salvo com sucesso ", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok!", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        _ = tapGestureRecognizer.view as! UIImageView
        takePhotofuncion()
    }
    
    private func takePhotofuncion() {
        let cameraViewController = CameraViewController { [weak self] image, asset in
           if let image = image {
               self?.imageView.image = image
               self?.uploadAndGenerateUrlImage(image: image)
          }
           self?.dismiss(animated: true, completion: nil)
       }
        DispatchQueue.main.async {
            self.present(cameraViewController, animated: true, completion: nil)
        }
    }
    
    private func returnBook() -> NSDictionary? {
        let dic: NSDictionary = [
            "id": "\(returnRandomId())",
            "description": "\(returnDescription())",
            "title": "\(returnBookName())",
            "printType": "\(returnBookType())",
            "pageCount": returnNumberOfPages(),
            "language": "\(returnLanguage())",
            "imageLinks": ["smallThumbnail":"\(linkImage ?? "")",
                           "thumbnail":"\(linkImage ?? "")"
                          ],
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
        uploadTask?.resume()
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
        if typeBook.text == "Revista" {
            return "MAGAZINE"
        } else {
            return "BOOK"
        }
    }
    
    private func returnNumberOfPages() -> Int {
        return Int(numberOfPagesTf.text ?? "0") ?? 0
    }
    
    private func returnLanguage() -> String {
        return languageBook.text ?? "PT"
    }
    
}
