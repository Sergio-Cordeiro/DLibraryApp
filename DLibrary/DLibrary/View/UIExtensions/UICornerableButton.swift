//
//  UICornerableButton.swift
//  DLibrary
//
//  Created by Sergio Cordeiro on 24/09/22.
//

import Foundation
import UIKit

class UICornerableButton: UIButton {

        @IBInspectable var borderWidth: CGFloat {
            set {
                layer.borderWidth = newValue
            }
            get {
                return layer.borderWidth
            }
        }

        @IBInspectable var cornerRadius: CGFloat {
            set {
                layer.cornerRadius = newValue
            }
            get {
                return layer.cornerRadius
            }
        }
    
        @IBInspectable var borderColor: UIColor {
            get {
                return UIColor(cgColor: self.layer.borderColor!)
            }
            set {
                self.layer.borderColor = newValue.cgColor
            }
        }
}
