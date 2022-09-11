//
//  UICornerableView.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 10/09/22.
//

import Foundation
import UIKit

class UICornerableView: UIView {
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
     }
}
