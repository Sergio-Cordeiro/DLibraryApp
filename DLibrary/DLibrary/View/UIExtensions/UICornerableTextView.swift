//
//  UICornerableTextView.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 01/10/22.
//

import Foundation
import UIKit

class UICornerableTextView: UITextView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
     }
}
