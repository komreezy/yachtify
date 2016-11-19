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
    static let defaultSquareBaseViewFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 125.0, height: 125.0))
    var title: String = ""
    var customImageView: UIImageView
    
    public override init(image: UIImage? = nil, title: String? = nil, subtitle: String? = nil) {
        customImageView = UIImageView()
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        customImageView.alpha = 0.85
        customImageView.clipsToBounds = true
        customImageView.contentMode = .scaleAspectFit
        
        if let title = title {
            self.title = title
        }
        
        super.init(frame: HUDProgressView.defaultSquareBaseViewFrame)
        
        imageView.alpha = 0
        
        switch self.title {
        case "yachtify-loader":
            customImageView.image = UIImage.animatedImageNamed("yachtify-loader", duration: 1.0)
        default:
            customImageView.image = UIImage(named: "checkmark")
        }
        
        backgroundColor = UIColor(fromHexString: "#202020")
        
        addSubview(customImageView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        customImageView.snp.makeConstraints({ make in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
            if title == "yachtify-loader" {
                make.width.equalTo(220.0)
                make.height.equalTo(72.0)
            } else {
                make.width.equalTo(60.0)
                make.height.equalTo(60.0)
            }
        })
    }
}
