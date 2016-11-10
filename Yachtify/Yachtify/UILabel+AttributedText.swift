//
//  UILabel+AttributedText.swift
//  Yachtify
//
//  Created by Komran Ghahremani on 10/27/16.
//  Copyright © 2016 Often. All rights reserved.
//

import Foundation

extension UILabel {
    func setTextWith(_ font: UIFont?, letterSpacing: Float, color: UIColor, lineHeight: CGFloat = 1.0, text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(value: letterSpacing as Float),
            NSFontAttributeName: font!,
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
