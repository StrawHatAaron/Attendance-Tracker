//
//  RoundButton.swift
//  Cs131
//
//  Created by Aaron Miller on 6/6/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import UIKit

@IBDesignable
public class RoundButton:UIButton{
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderwidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderwidth
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.darkGray {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
            layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        }
    }
    
    @IBInspectable var masksToBounds: Bool = false {
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    
}
