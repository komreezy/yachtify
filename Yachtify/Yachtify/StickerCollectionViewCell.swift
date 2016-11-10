//
//  StickerCollectionViewCell.swift
//  Yachtify
//
//  Created by Komran Ghahremani on 10/26/16.
//  Copyright © 2016 Often. All rights reserved.
//

import UIKit

class StickerCollectionViewCell: UICollectionViewCell {
    var image: UIImage? {
        didSet {
            imageView.image = self.image
        }
    }
    var imageView: UIImageView
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#303030")
        layer.cornerRadius = 3.0
        
        addSubview(imageView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        imageView.snp.makeConstraints({ make in
            make.left.equalTo(snp.left).offset(12.0)
            make.bottom.equalTo(snp.bottom).offset(-12.0)
            make.top.equalTo(snp.top).offset(12.0)
            make.right.equalTo(snp.right).offset(-12.0)
        })
    }
}
