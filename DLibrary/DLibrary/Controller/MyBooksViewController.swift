//
//  MyBooksViewController.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 12/10/22.
//

import UIKit
import FirebaseDatabase

class MyBooksViewController: UIViewController {
    
    //MARK: - Properties
    
    var ref: DatabaseReference?
    private var books: [Book] = []
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        loadBooks()
    }

    //MARK: - Outlets Actions
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    
    private func loadBooks() {
        if let userUid = DLibraryManager.sharedInstance.user?.uid {
            ref = Database.database().reference(withPath: "users/\(userUid)/")
        }
        
        ref?.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            if let data: Data = snapshot.data {
                self.books = self.readBooksInJson(data: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    private func readBooksInJson(data: Data) -> [Book] {
        var arrayBooks: [Book] = []
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return arrayBooks }
            guard let items = json["livros"] as? [String:[String:Any]] else { return arrayBooks }
            for item in items {
                let bookFromFireBase = item.value
                if let book = Book.byDict(dict: bookFromFireBase, id: item.key) {
                    arrayBooks.append(book)
                }
            }
        } catch {
            showErrorWhenLoadBooks()
        }
         return arrayBooks
    }
    
    private func showErrorWhenLoadBooks() {
        let alert = UIAlertController(title: "Algo deu errado...", message: "Por favor tente novamento mais tarde", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok!", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
extension MyBooksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! SearchBooksTableViewCell
        
        let book = books[indexPath.row]
        
        if let imageBookLink: String  = book.images["smallThumbnail"] {
            
            let http = URL(string: imageBookLink)!
            var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)!
            comps.scheme = "https"
            let https = comps.url!
            
            cell.imageView?.af.setImage(
                            withURL: https,
                            placeholderImage: UIImage(named: "Placeholder Image"),
                            filter: nil,
                            imageTransition: UIImageView.ImageTransition.crossDissolve(0.5),
                            runImageTransitionIfCached: false) {
                                response in
                                    if response.response != nil {
                                        self.tableView.beginUpdates()
                                        self.tableView.endUpdates()
                                    } else {
                                        if response.error != nil {
                                            self.tableView.beginUpdates()
                                            self.tableView.endUpdates()
                                        }
                                    }
                            }
        }
        
        cell.nameBookText.text = book.title
        
        cell.clipsToBounds = false
        cell.bodyView.backgroundColor = UIColor.white
        cell.bodyView.layer.shadowColor = UIColor.black.cgColor
        cell.bodyView.layer.shadowOpacity = 0.24
        cell.bodyView.layer.shadowOffset = .zero
        cell.bodyView.layer.shadowRadius = 3
        cell.bodyView.layer.cornerRadius = 10
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let book = books[indexPath.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if let controller = storyBoard.instantiateViewController(withIdentifier: "DescriptionBookViewController") as? DescriptionBookViewController {
            controller.book = book
            controller.isOptionSaveScreenAvaliable = false
            self.present(controller, animated: true, completion: nil)
        }
    }
}
extension MyBooksViewController: UITableViewDelegate {
    
}
