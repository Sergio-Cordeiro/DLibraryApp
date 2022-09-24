//
//  SearchBooksViewController.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 24/09/22.
//

import UIKit

class SearchBooksViewController: UIViewController {

    //MARK: - Properties
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchforFreeBooksSwith: UISwitch!
    
    
    //MARK: - overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }

    //MARK: - Outlets Actions
    
    @IBAction func searchForFreeBooksAction(_ sender: Any) {
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Public methods
    
    //MARK: - Provate methods
}
