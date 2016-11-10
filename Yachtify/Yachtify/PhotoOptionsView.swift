//
//  PhotoOptionsView.swift
//  Yachtify
//
//  Created by Komran Ghahremani on 10/31/16.
//  Copyright © 2016 Often. All rights reserved.
//

import UIKit

class PhotoOptionsView: UIView {
    var titleLabel: UILabel
    var photosButton: UIButton
    var cameraFlipButton: UIButton
    var appShareButton: UIButton
    var feedbackButton: UIButton
    var cameraButton: UIButton
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.setTextWith(UIFont(name: "Avenir-Heavy", size: 18.0),
                               letterSpacing: 1.0,
                               color: .white,
                               text: "yachtify".uppercased())
        
        photosButton = UIButton()
        photosButton.translatesAutoresizingMaskIntoConstraints = false
        photosButton.setImage(UIImage(named: "photos"), for: .normal)
        
        cameraFlipButton = UIButton()
        cameraFlipButton.translatesAutoresizingMaskIntoConstraints = false
        cameraFlipButton.setImage(UIImage(named: "flip"), for: .normal)
        
        appShareButton = UIButton()
        appShareButton.translatesAutoresizingMaskIntoConstraints = false
        appShareButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 13.0)
        appShareButton.setTitle("share w/ friends".uppercased(), for: .normal)
        appShareButton.setTitleColor(UIColor.white.withAlphaComponent(0.54), for: .normal)
        
        feedbackButton = UIButton()
        feedbackButton.translatesAutoresizingMaskIntoConstraints = false
        feedbackButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 13.0)
        feedbackButton.setTitle("feedback?".uppercased(), for: .normal)
        feedbackButton.setTitleColor(UIColor.white.withAlphaComponent(0.54), for: .normal)
        
        cameraButton = UIButton()
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.setImage(UIImage(named: "capture"), for: .normal)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#202020")
        
        addSubview(titleLabel)
        addSubview(photosButton)
        addSubview(cameraFlipButton)
        addSubview(cameraButton)
        addSubview(appShareButton)
        addSubview(feedbackButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints({ make in
            make.top.equalTo(snp.top).offset(30.0)
            make.centerX.equalTo(snp.centerX)
        })
        
        photosButton.snp.makeConstraints({ make in
            make.left.equalTo(snp.left).offset(18.0)
            make.top.equalTo(snp.top).offset(33.5)
            make.height.equalTo(37.0)
            make.width.equalTo(37.0)
        })
        
        cameraFlipButton.snp.makeConstraints({ make in
            make.right.equalTo(snp.right).offset(-18.0)
            make.top.equalTo(snp.top).offset(33.5)
            make.height.equalTo(24.5)
            make.width.equalTo(31.0)
        })
        
        appShareButton.snp.makeConstraints({ make in
            make.left.equalTo(snp.left).offset(12.0)
            make.bottom.equalTo(snp.bottom).offset(-12.0)
        })
        
        feedbackButton.snp.makeConstraints({ make in
            make.right.equalTo(snp.right).offset(-12.0)
            make.bottom.equalTo(snp.bottom).offset(-12.0)
        })
        
        cameraButton.snp.makeConstraints({ make in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(100)
            make.width.equalTo(100)
        })
    }
}
