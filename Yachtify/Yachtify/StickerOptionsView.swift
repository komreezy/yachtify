//
//  OptionsView.swift
//  Yachtify
//
//  Created by Komran Ghahremani on 10/26/16.
//  Copyright © 2016 Often. All rights reserved.
//

import UIKit

class StickerOptionsView: UIView {
    var titleLabel: UILabel
    var redoButton: UIButton
    var shareButton: UIButton
    var appShareButton: UIButton
    var feedbackButton: UIButton
    var stickerCollectionView: StickersCollectionViewController
    
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
        
        let redoString = NSAttributedString(string: "redo".uppercased(), attributes: attributes)
        let shareString = NSAttributedString(string: "share".uppercased(), attributes: attributes)
        
        redoButton = UIButton()
        redoButton.translatesAutoresizingMaskIntoConstraints = false
        redoButton.setAttributedTitle(redoString, for: .normal)
        
        shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setAttributedTitle(shareString, for: .normal)
        
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
        
        stickerCollectionView = StickersCollectionViewController()
        stickerCollectionView.view.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
    
        backgroundColor = UIColor(fromHexString: "#202020")
        
        addSubview(titleLabel)
        addSubview(redoButton)
        addSubview(shareButton)
        addSubview(appShareButton)
        addSubview(feedbackButton)
        addSubview(stickerCollectionView.view)
        
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
        
        redoButton.snp.makeConstraints({ make in
            make.left.equalTo(snp.left).offset(18.0)
            make.top.equalTo(snp.top).offset(33.5)
        })
        
        shareButton.snp.makeConstraints({ make in
            make.right.equalTo(snp.right).offset(-18.0)
            make.top.equalTo(snp.top).offset(33.5)
        })
        
        appShareButton.snp.makeConstraints({ make in
            make.left.equalTo(snp.left).offset(12.0)
            make.bottom.equalTo(snp.bottom).offset(-12.0)
        })
        
        feedbackButton.snp.makeConstraints({ make in
            make.right.equalTo(snp.right).offset(-12.0)
            make.bottom.equalTo(snp.bottom).offset(-12.0)
        })
        
        stickerCollectionView.view.snp.makeConstraints({ make in
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(150.0)
            make.centerY.equalTo(snp.centerY)
        })
    }
}
