//
//  Book.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 24/09/22.
//

import Foundation

class Book {
    
    var id: String
    var description: String
    var title: String
    var type: String
    var pagesCount: Int64
    var language: String
    var images: [String: String]
    var previewLink: String
    
    init(
        id: String,
        description: String,
        title: String,
        type: String,
        pagesCount: Int64,
        language: String,
        images: [String : String],
        previewLink: String
    ) {
        self.id = id
        self.description = description
        self.title = title
        self.type = type
        self.pagesCount = pagesCount
        self.language = language
        self.images = images
        self.previewLink = previewLink
    }
    
    static func byDict(dict: [String : Any], id: String) -> Book? {
        guard let description = dict["description"] as? String,
              let title = dict["title"] as? String,
              let type = dict["printType"] as? String,
              let pagesCount = dict["pageCount"] as? Int64,
              let language = dict["language"] as? String,
              let images = dict["imageLinks"] as? [String: String],
              let previewLink = dict["previewLink"] as? String
        else {
            return nil
        }
        
        return Book(id: id, description: description, title: title, type: type, pagesCount: pagesCount, language: language, images: images, previewLink: previewLink)
    }
}
