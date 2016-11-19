//
//  ShareOptionsView.swift
//  Yachtify
//
//  Created by Komran Ghahremani on 10/27/16.
//  Copyright © 2016 Often. All rights reserved.
//

import UIKit
import SnapKit

class ShareOptionsView: UIView {
    var titleLabel: UILabel
    var backButton: UIButton
    var cancelButton: UIButton
    var messageButton: UIButton
    var twitterButton: UIButton
    var facebookButton: UIButton
    var instagramButton: UIButton
    var saveButton: UIButton
    var appShareButton: UIButton
    var feedbackButton: UIButton
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.setTextWith(UIFont(name: "Avenir-Heavy", size: 18.0),
                               letterSpacing: 1.0,
                               color: .white,
                               text: "yachtify".uppercased())
        
        let attributes = [
            NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 13.0)!,
            NSForegroundColorAttributeName: UIColor.white,
            NSKernAttributeName: 0.8
        ] as [String : Any]
        
        let backString = NSAttributedString(string: "back".uppercased(), attributes: attributes)
        let cancelString = NSAttributedString(string: "finish".uppercased(), attributes: attributes)
        
        backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setAttributedTitle(backString, for: .normal)
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setAttributedTitle(cancelString, for: .normal)
        
        messageButton = UIButton()
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.setImage(UIImage(named: "imessage"), for: .normal)
        messageButton.tag = 0
        
        twitterButton = UIButton()
        twitterButton.translatesAutoresizingMaskIntoConstraints = false
        twitterButton.setImage(UIImage(named: "twitter"), for: .normal)
        twitterButton.tag = 1
        
        facebookButton = UIButton()
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.setImage(UIImage(named: "facebook"), for: .normal)
        facebookButton.tag = 2
        
        instagramButton = UIButton()
        instagramButton.translatesAutoresizingMaskIntoConstraints = false
        instagramButton.setImage(UIImage(named: "instagram"), for: .normal)
        instagramButton.tag = 3
        
        saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.layer.cornerRadius = 2.0
        saveButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 12.0)
        saveButton.backgroundColor = UIColor(red: 48.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        saveButton.setTitle("save to photos".uppercased(), for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        
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
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#202020")
        
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(cancelButton)
        addSubview(messageButton)
        addSubview(twitterButton)
        addSubview(facebookButton)
        addSubview(instagramButton)
        addSubview(saveButton)
        addSubview(appShareButton)
        addSubview(feedbackButton)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let itemWidth = screenWidth * 0.25
        let itemHeight = screenWidth * 0.212
        var topMargin = screenHeight * 0.044809559
        let bottomMargin = screenHeight * 0.02
        let modelName = UIDevice.current.modelName
        if modelName == "iPhone 5" ||
            modelName == "iPhone 5c" ||
            modelName == "iPhone 5s" ||
            modelName == "iPod Touch 5" ||
            modelName == "iPod Touch 6"{
            topMargin -= 10
        }
        
        titleLabel.snp.makeConstraints({ make in
            make.top.equalTo(snp.top).offset(topMargin)
            make.centerX.equalTo(snp.centerX)
        })
        
        backButton.snp.makeConstraints({ make in
            make.left.equalTo(snp.left).offset(18.0)
            make.top.equalTo(snp.top).offset(topMargin + 3.5)
        })
        
        cancelButton.snp.makeConstraints({ make in
            make.right.equalTo(snp.right).offset(-18.0)
            make.top.equalTo(snp.top).offset(topMargin + 3.5)
        })
        
        messageButton.snp.makeConstraints({ make in
            make.left.equalTo(snp.left)
            make.bottom.equalTo(saveButton.snp.top).offset(-7.0)
            make.width.equalTo(itemWidth)
            make.height.equalTo(itemHeight)
        })
        
        twitterButton.snp.makeConstraints({ make in
            make.left.equalTo(messageButton.snp.right)
            make.bottom.equalTo(saveButton.snp.top).offset(-7.0)
            make.width.equalTo(itemWidth)
            make.height.equalTo(itemHeight)
        })
        
        facebookButton.snp.makeConstraints({ make in
            make.right.equalTo(instagramButton.snp.left)
            make.bottom.equalTo(saveButton.snp.top).offset(-7.0)
            make.width.equalTo(itemWidth)
            make.height.equalTo(itemHeight)
        })
        
        instagramButton.snp.makeConstraints({ make in
            make.right.equalTo(snp.right)
            make.bottom.equalTo(saveButton.snp.top).offset(-7.0)
            make.width.equalTo(itemWidth)
            make.height.equalTo(itemHeight)
        })
        
        saveButton.snp.makeConstraints({ make in
            make.left.equalTo(messageButton.snp.left).offset(4.0)
            make.right.equalTo(instagramButton.snp.right).offset(-4.0)
            make.bottom.equalTo(appShareButton.snp.top).offset(-bottomMargin)
            make.height.equalTo(itemHeight)
        })
        
        appShareButton.snp.makeConstraints({ make in
            make.left.equalTo(snp.left).offset(12.0)
            make.bottom.equalTo(snp.bottom).offset(-12.0)
        })
        
        feedbackButton.snp.makeConstraints({ make in
            make.right.equalTo(snp.right).offset(-12.0)
            make.bottom.equalTo(snp.bottom).offset(-12.0)
        })
    }
}
