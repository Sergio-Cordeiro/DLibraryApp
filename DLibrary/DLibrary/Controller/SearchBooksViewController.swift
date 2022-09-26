//
//  SearchBooksViewController.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 24/09/22.
//

import UIKit

class SearchBooksViewController: UIViewController {

    //MARK: - Properties
    
    private var books: [Book] = []
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchforFreeBooksSwith: UISwitch!
    
    
    //MARK: - overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBooks()
     
    }

    //MARK: - Outlets Actions
    
    @IBAction func searchForFreeBooksAction(_ sender: Any) {
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Public methods
    
    //MARK: - Private methods
    
    private func downloadImageFromLink(link: String) -> UIImage {
        
        
    }
    
    private func loadBooks() {
        GoogleBooksProvider.getAllBooks { success,data in
            if success, data != nil {
                if let data = data {
                    self.books = self.readBooksInJson(data: data)
                    self.tableView.reloadData()
                } else {
                    self.showErrorWhenLoadBooks()
                }
            } else {
                self.showErrorWhenLoadBooks()
            }
        }
    }
    
    private func readBooksInJson(data: Data) -> [Book] {
        var arrayBooks: [Book] = []
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return arrayBooks }
            guard let items = json["items"] as? [Dictionary<AnyHashable, Any>] else { return arrayBooks }
            for item in items {
                if let value = item["volumeInfo"] as? [String : Any],
                   let id = item["id"] as? String {
                    if let book = Book.byDict(dict: value, id: id) {
                        arrayBooks.append(book)
                    }
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
extension SearchBooksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! SearchBooksTableViewCell
        
        let book = books[indexPath.row]
        
        cell.clipsToBounds = true
        cell.bodyView.backgroundColor = UIColor.white
        cell.bodyView.layer.shadowColor = UIColor.black.cgColor
        cell.bodyView.layer.shadowOpacity = 0.24
        cell.bodyView.layer.shadowOffset = .zero
        cell.bodyView.layer.shadowRadius = 3
        cell.bodyView.layer.cornerRadius = 10
        if let imageBookLink: String  = book.images["smallThumbnail"] {
            cell.imageView?.image = downloadImageFromLink(link: imageBookLink)
        }
        cell.nameBookText.text = book.title
        
        return cell
        
    }
    
}
extension SearchBooksViewController: UITableViewDelegate {
    
}
