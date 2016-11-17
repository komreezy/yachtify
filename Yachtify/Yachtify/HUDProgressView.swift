//
//  HUDProgressView.swift
//  Yachtify
//
//  Created by Komran Ghahremani on 11/11/16.
//  Copyright © 2016 Often. All rights reserved.
//

import UIKit
import PKHUD
import SnapKit

class HUDProgressView: PKHUDSquareBaseView {
    static let defaultSquareBaseViewFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 156.0, height: 156.0))
    
    public override init(image: UIImage? = nil, title: String? = nil, subtitle: String? = nil) {
        super.init(frame: HUDProgressView.defaultSquareBaseViewFrame)
        
        if title == "yachtify-loader" {
            imageView.image = UIImage.animatedImageNamed("yachtify-loader", duration: 1.1)
        } else {
            imageView.image = UIImage(named: "checkmark")
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 1.0
        imageView.contentMode = .scaleAspectFit
        
        backgroundColor = UIColor(fromHexString: "#202020")
        
        addSubview(imageView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        imageView.snp.makeConstraints({ make in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
            make.width.equalTo(200.0)
            make.height.equalTo(70.0)
        })
    }
}
