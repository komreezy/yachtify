//
//  MessageOverlayView.swift
//  Yachtify
//
//  Created by Komran Ghahremani on 11/14/16.
//  Copyright © 2016 Often. All rights reserved.
//

import UIKit
import SnapKit

class MessageOverlayView: UIView {
    var messageLabel: UILabel
    var dismissButton: UIButton
    
    override init(frame: CGRect) {
        messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        messageLabel.setTextWith(UIFont(name: "Avenir-Heavy", size: 18.0),
                                 letterSpacing: 1.0,
                                 color: .white,
                                 text: "Pick your favorite look to\n drag, resize & rotate!")
        
        let attributes = [
            NSKernAttributeName: 1.0,
            NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 15.0)!,
            NSForegroundColorAttributeName: UIColor.white
        ] as [String : Any]
        
        dismissButton = UIButton()
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.backgroundColor = UIColor(fromHexString: "#E34D4F")
        dismissButton.layer.cornerRadius = 2.0
        dismissButton.setAttributedTitle(NSAttributedString(string: "got it".uppercased(), attributes: attributes), for: .normal)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.74)
        
        addSubview(messageLabel)
        addSubview(dismissButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        messageLabel.snp.makeConstraints({ make in
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(UIScreen.main.bounds.height * 0.129154079)
        })
        
        dismissButton.snp.makeConstraints({ make in
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(messageLabel.snp.bottom).offset(21.0)
            make.width.equalTo(120.0)
            make.height.equalTo(42.0)
        })
    }
}
