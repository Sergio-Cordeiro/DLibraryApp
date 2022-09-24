//
//  GoogleBooksProvider.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 24/09/22.
//

import Foundation

class GoogleBooksProvider {
    
    //MARK: - Properties
    
    private static let session = URLSession.shared
    private static let basePath = "https://www.googleapis.com/books/v1/volumes?q="
    private static let basePathBooks = "https://www.googleapis.com/books/v1/volumes?q=book" // MARK: - Catch all Books
    
    class func getAllBooks(completion: @escaping (_ success: Bool,_ data: Data?) -> Void) {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=book") else {
            completion(false, nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                completion(false, nil)
            } else {
                completion(true, data)
            }
        }
        dataTask.resume()
    }
}
