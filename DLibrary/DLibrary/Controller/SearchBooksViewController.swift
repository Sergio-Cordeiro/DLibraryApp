//
//  SearchBooksViewController.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 24/09/22.
//

import UIKit
import AlamofireImage

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
        overrideUserInterfaceStyle = .light
        searchforFreeBooksSwith.isOn = false
        loadBooks()
    }

    //MARK: - Outlets Actions
    
    @IBAction func searchTextView(_ sender: Any) {
        guard let searchText: String = searchTextField.text else { return }
        
        let searchWithoutSpaces = searchText.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let cleanString = searchWithoutSpaces.folding(options: .diacriticInsensitive, locale: .current)
        
        GoogleBooksProvider.searchWithParameters(searchParameter: cleanString, isFreeBooks: searchforFreeBooksSwith.isOn) { success,data in
            if success, data != nil {
                if let data = data {
                    self.books = self.readBooksInJson(data: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func searchForFreeBooksAction(_ sender: Any) {
        if !searchforFreeBooksSwith.isOn {
            searchforFreeBooksSwith.isOn = false
            loadBooks()
        } else {
            searchforFreeBooksSwith.isOn = true
            GoogleBooksProvider.searchFreeBooks() { success,data in
                if success, data != nil {
                    if let data = data {
                        self.books = self.readBooksInJson(data: data)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        self.searchforFreeBooksSwith.isOn = false
                        self.showErrorWhenLoadBooks()
                    }
                } else {
                    self.searchforFreeBooksSwith.isOn = false
                    self.showErrorWhenLoadBooks()
                }
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    
    private func loadBooks() {
        GoogleBooksProvider.getAllBooks { success,data in
            if success, data != nil {
                if let data = data {
                    self.books = self.readBooksInJson(data: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
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
            controller.isOptionSaveScreenAvaliable = true 
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}
extension SearchBooksViewController: UITableViewDelegate {
    
}
