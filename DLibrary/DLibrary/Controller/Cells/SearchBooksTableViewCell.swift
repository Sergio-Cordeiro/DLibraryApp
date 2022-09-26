//
//  SearchBooksTableViewCell.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 25/09/22.
//

import UIKit

class SearchBooksTableViewCell: UITableViewCell {

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var nameBookText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
