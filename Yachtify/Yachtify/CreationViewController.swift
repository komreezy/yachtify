//
//  CreationViewController.swift
//  Yachtify
//
//  Created by Komran Ghahremani on 10/26/16.
//  Copyright © 2016 Often. All rights reserved.
//

import UIKit
import SnapKit
import Social
import MessageUI
import AVFoundation
import PKHUD
import Photos

class CreationViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    StickerImageSelectable,
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    UIGestureRecognizerDelegate {
    
    enum CreationState {
        case photo
        case sticker
        case share
    }
    
    var imageView: UIImageView
    var stickerOptionsView: StickerOptionsView
    var photoOptionsView: PhotoOptionsView
    var shareOptionsView: ShareOptionsView
    var trash: UIImageView
    var stickers: [UIImageView] = []
    var watermarkLabel: UILabel
    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var input: AVCaptureDeviceInput = AVCaptureDeviceInput()
    var output: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var currentCameraPosition: AVCaptureDevicePosition = .back
    var imagePicked = false
    var state: CreationState = .photo {
        didSet {
            switch state {
            case .photo:
                watermarkLabel.alpha = 0
                setStickersUserInteraction(enabled: true)
                imagePicked = false
                photoOptionsView.isHidden = false
                stickerOptionsView.isHidden = true
                shareOptionsView.isHidden = true
            case .sticker:
                watermarkLabel.alpha = 0
                setStickersUserInteraction(enabled: true)
                photoOptionsView.isHidden = true
                stickerOptionsView.isHidden = false
                shareOptionsView.isHidden = true
            case .share:
                watermarkLabel.alpha = 1
                setStickersUserInteraction(enabled: false)
                photoOptionsView.isHidden = true
                stickerOptionsView.isHidden = true
                shareOptionsView.isHidden = false
            }
        }
    }
    
    init() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        
        photoOptionsView = PhotoOptionsView()
        photoOptionsView.translatesAutoresizingMaskIntoConstraints = false
        
        stickerOptionsView = StickerOptionsView()
        stickerOptionsView.translatesAutoresizingMaskIntoConstraints = false
        stickerOptionsView.isHidden = true
        
        shareOptionsView = ShareOptionsView()
        shareOptionsView.translatesAutoresizingMaskIntoConstraints = false
        shareOptionsView.isHidden = true
        
        watermarkLabel = UILabel()
        watermarkLabel.translatesAutoresizingMaskIntoConstraints = false
        watermarkLabel.textAlignment = .center
        watermarkLabel.alpha = 0
        watermarkLabel.setTextWith(UIFont(name: "Avenir-Heavy", size: 18.0),
                                   letterSpacing: 1.0,
                                   color: .white,
                                   text: "yachtify".uppercased())
        
        trash = UIImageView()
        trash.translatesAutoresizingMaskIntoConstraints = false
        trash.contentMode = .scaleAspectFit
        trash.isHidden = true
        trash.image = #imageLiteral(resourceName: "trash-can")
        
        super.init(nibName: nil, bundle: nil)
        
        addTargets()
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(CreationViewController.handleImagePan(recognizer:)))
        let scaleGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(CreationViewController.handleScale(recognizer:)))
        let rotateGesture = UIRotationGestureRecognizer(target: self,
                                                        action: #selector(CreationViewController.handleRotate(recognizer:)))
        
        panGesture.delegate = self
        scaleGesture.delegate = self
        rotateGesture.delegate = self
        
        stickerOptionsView.stickerCollectionView.delegate = self
        view.gestureRecognizers = [scaleGesture, rotateGesture]
        
        imageView.addSubview(watermarkLabel)
        view.addSubview(imageView)
        view.addSubview(trash)
        view.addSubview(photoOptionsView)
        view.addSubview(stickerOptionsView)
        view.addSubview(shareOptionsView)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fetchPhotoThumbnail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PKHUD.sharedHUD.contentView = HUDProgressView(image: nil, title: "yachtify-loader", subtitle: nil)
        PKHUD.sharedHUD.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !imagePicked && state == .photo {
            setupSession(position: currentCameraPosition)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Camera functionality & Setup
    
    func setupSession(position: AVCaptureDevicePosition) {
        PKHUD.sharedHUD.contentView = HUDProgressView(image: nil, title: "yachtify-loader", subtitle: nil)
        PKHUD.sharedHUD.show()
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto
            self.captureSession.removeInput(self.input)
            self.captureSession.removeOutput(self.output)
            
            self.captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera,
                                                          mediaType: AVMediaTypeVideo,
                                                          position: position)
            do {
                self.input = try AVCaptureDeviceInput(device: self.captureDevice)
            } catch {
                return
            }
            
            self.output = AVCaptureStillImageOutput()
            self.output.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            
            guard self.captureSession.canAddInput(self.input) || self.captureSession.canAddOutput(self.output) else {
                return
            }
            
            self.captureSession.addInput(self.input)
            self.captureSession.addOutput(self.output)
            
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.previewLayer?.frame = self.imageView.frame
            self.previewLayer?.connection?.videoOrientation = .portrait
            
            DispatchQueue.main.async { [unowned self] in
                guard let preview = self.previewLayer else {
                    return
                }
                
                PKHUD.sharedHUD.hide()
                self.view.layer.addSublayer(preview)
                self.captureSession.startRunning()
            }
        }
    }
    
    func captureImage() {
        guard let connection = output.connection(withMediaType: AVMediaTypeVideo) else {
            return
        }
        
        connection.videoOrientation = .portrait
        output.captureStillImageAsynchronously(from: connection, completionHandler: { (sampleBuffer, error) in
            guard sampleBuffer != nil && error == nil else { return }
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
            guard let image = UIImage(data: imageData!) else { return }
            let mirroredImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .leftMirrored)
            
            if self.currentCameraPosition == .back {
                self.imageView.image = image
            } else {
                self.imageView.image = mirroredImage
            }
            
            self.captureSession.stopRunning()
            self.previewLayer?.removeFromSuperlayer()
            self.previewLayer = nil
            self.captureDevice = nil
            self.state = .sticker
            self.imagePicked = true
        })
    }
    
    func getCurrentImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func photosButtonDidTap() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = image
            self.captureSession.stopRunning()
            self.previewLayer!.removeFromSuperlayer()
            self.previewLayer = nil
            state = .sticker
            imagePicked = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        PKHUD.sharedHUD.show()
    }
    
    func toggleCamera() {
        let newPosition = currentCameraPosition ==  AVCaptureDevicePosition.back ? AVCaptureDevicePosition.front : AVCaptureDevicePosition.back
        
        guard let camera = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera,
                                                         mediaType: AVMediaTypeVideo,
                                                         position: newPosition) else { return }
        
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: camera)
        } catch {
            return
        }
        
        captureSession.beginConfiguration()
        captureSession.removeInput(self.input)
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
            self.input = deviceInput
            self.currentCameraPosition = newPosition
        } else {
            captureSession.addInput(self.input)
        }
        
        if camera.supportsAVCaptureSessionPreset(AVCaptureSessionPresetPhoto) {
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        }
        
        do {
            try camera.lockForConfiguration()
        } catch {
            return
        }
        
        camera.isSubjectAreaChangeMonitoringEnabled = true
        camera.unlockForConfiguration()
        
        captureSession.commitConfiguration()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first
        let screenSize = view.bounds.size
        
        guard let point = touchPoint?.location(in: view),
            imageView.frame.contains(point) else { return }
        
        let focusPoint = CGPoint(x: point.y / screenSize.height, y: 1.0 - point.x / screenSize.width)
        
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
                
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = .autoFocus
                }
                
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = .autoExpose
                }
                
                device.unlockForConfiguration()
            } catch {
                return
            }
        }
    }
    
    func saveImageToLibrary() {
        let imageData = UIImageJPEGRepresentation(getCurrentImage(), 1.0)
        let compressedJPEG = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEG!, nil, nil, nil)
        
        PKHUD.sharedHUD.contentView = HUDProgressView(image: nil, title: "checkmark", subtitle: nil)
        PKHUD.sharedHUD.show()
        _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in
            PKHUD.sharedHUD.hide()
        })
    }
    
    func backButtonDidTap() {
        state = .sticker
    }
    
    func shareButtonDidTap() {
        state = .share
    }
    
    func cancelButtonDidTap() {
        imageView.image = UIImage()
        removeAllStickers()
        setupSession(position: currentCameraPosition)
        state = .photo
    }
    
    func removeAllStickers() {
        for sticker in stickers {
            sticker.removeFromSuperview()
        }
        
        stickers.removeAll()
    }
    
    func setStickersUserInteraction(enabled: Bool) {
        for sticker in stickers {
            sticker.isUserInteractionEnabled = enabled
        }
    }
    
    func remove(image: UIView) {
        for (index, sticker) in zip(stickers.indices, stickers) {
            if sticker == image {
                sticker.removeFromSuperview()
                stickers.remove(at: index)
            }
        }
    }
    
    func addSticker(with image: UIImage) {
        // create sticker view
        let sticker = UIImageView()
        sticker.contentMode = .scaleAspectFit
        sticker.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        sticker.center = imageView.center
        sticker.isUserInteractionEnabled = true
        sticker.image = image
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(CreationViewController.handleImagePan(recognizer:)))
        panGesture.delegate = self
        sticker.gestureRecognizers = [panGesture]
        
        stickers.append(sticker)
        view.insertSubview(sticker, belowSubview: trash)
    }
    
    // MARK: Handle Hair image resizing and positioning
    
    func handleImagePan(recognizer: UIPanGestureRecognizer) {
        // unhide the trash can with animation
        if recognizer.state == .changed {
            trash.isHidden = false
            
            let translation = recognizer.translation(in: self.view)
            if let view = recognizer.view {
                view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
                if trash.frame.contains(CGPoint(x: view.center.x, y: view.center.y - 10.0)) {
                    UIView.animate(withDuration: 0.25) { [unowned self] in
                        self.trash.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                        view.alpha = 0.5
                    }
                } else {
                    UIView.animate(withDuration: 0.25) { [unowned self] in
                        self.trash.transform = .identity
                        view.alpha = 1.0
                    }
                }
            }
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        // if the image view is on the trash can then remove it & hide trash can
        if recognizer.state == .ended {
            if let view = recognizer.view {
                if trash.frame.contains(CGPoint(x: view.center.x, y: view.center.y - 10.0)) {
                    remove(image: view)
                }
            }
            
            trash.isHidden = true
        }
    }
    
    func handleScale(recognizer: UIPinchGestureRecognizer) {
        let point = recognizer.location(in: view)
        guard let sticker = view.hitTest(point, with: nil),
            sticker != self.view else {
                return
        }
        
        sticker.transform = sticker.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
    }
    
    func handleRotate(recognizer: UIRotationGestureRecognizer) {
        let point = recognizer.location(in: view)
        guard let sticker = view.hitTest(point, with: nil),
            sticker != self.view else {
                return
        }
        
        sticker.transform = sticker.transform.rotated(by: recognizer.rotation)
        recognizer.rotation = 0
    }
    
    func didSelectSticker(image: UIImage) {
        addSticker(with: image)
    }
    
    func shareWithFriendsDidTap() {
        let shareSheet = UIActivityViewController(activityItems: ["Check out Yachtify here! http://itunes.apple.com/app/id1176353449"], applicationActivities: nil)
        present(shareSheet, animated: true, completion: nil)
    }
    
    func feedbackDidTap() {
        if MFMailComposeViewController.canSendMail() {
            launchEmail(self)
        }
    }
    
    // MARK: Handle share for Social Media
    
    func shareImageButtonDidTap(sender: UIButton) {
        let screenShot = getCurrentImage()
        
        switch sender.tag {
        case 0:
            shareWithiMessage(image: screenShot)
        case 1:
            shareWithTwitter(image: screenShot)
        case 2:
            shareWithFacebook(image: screenShot)
        case 3:
            shareWithInstagram(image: screenShot)
        default:
            break
        }
    }
    
    func shareWithiMessage(image: UIImage) {
        watermarkLabel.alpha = 1
        let vc = MFMessageComposeViewController()
        if MFMessageComposeViewController.canSendText() {
            vc.addAttachmentData(UIImageJPEGRepresentation(image, 1)!,
                                 typeIdentifier: "image/jpg",
                                 filename: "yachtify.jpg")
            vc.delegate = self
            vc.messageComposeDelegate = self
            present(vc, animated: true, completion: nil)
        }
    }
    
    func shareWithTwitter(image: UIImage) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        vc.completionHandler = { result in
            switch result {
            case SLComposeViewControllerResult.cancelled:
                print("cancelled")
            case SLComposeViewControllerResult.done:
                print("done")
                DispatchQueue.main.async {
                    PKHUD.sharedHUD.contentView = HUDProgressView(image: nil, title: "checkmark", subtitle: nil)
                    PKHUD.sharedHUD.show()
                    _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in
                        PKHUD.sharedHUD.hide()
                    })
                }
            }
        }
        
        present(vc, animated: true, completion: nil)
        vc.setInitialText("Share to Twitter")
        vc.add(image)
    }
    
    func shareWithFacebook(image: UIImage) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        vc.completionHandler = { result in
            switch result {
            case SLComposeViewControllerResult.cancelled:
                print("cancelled")
            case SLComposeViewControllerResult.done:
                print("done")
                DispatchQueue.main.async {
                    PKHUD.sharedHUD.contentView = HUDProgressView(image: nil, title: "checkmark", subtitle: nil)
                    PKHUD.sharedHUD.show()
                    _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in
                        PKHUD.sharedHUD.hide()
                    })
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        
        present(vc, animated: true, completion: nil)
        vc.setInitialText("Share to Facebook")
        vc.add(image)
    }
    
    func shareWithInstagram(image: UIImage) {
        saveImageToLibrary()
        let instagramHooks = "instagram://"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
        }
    }
    
    func dismissOverlayView() {
        stickerOptionsView.messageOverlay.alpha = 0
        stickerOptionsView.messageOverlay.removeFromSuperview()
    }
    
    // MARK: Setting the camera roll thumbnail
    
    func fetchPhotoThumbnail() {
        let imageManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        guard fetchResult.count > 0 else {
            return
        }
        
        imageManager.requestImage(for: fetchResult.object(at: fetchResult.count - 1) as PHAsset,
                                  targetSize: view.frame.size,
                                  contentMode: .aspectFit,
                                  options: requestOptions,
                                  resultHandler: { (image, _) in
                                    self.photoOptionsView.photosButton.setImage(image, for: .normal)
        })
    }
    
    // MARK: MFMailComposeViewControllerDelegate - (Does not work in Simulator)
    
    func launchEmail(_ sender: AnyObject) {
        let emailTitle = "Feedback"
        let messageBody = ""
        let toRecipents = ["dreamscape9817234@gmail.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        mc.modalTransitionStyle = .coverVertical
        present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {  }
    
    func addTargets() {
        addTargetsForPhotoView()
        addTargetsForStickerView()
        addTargetsForShareView()
        stickerOptionsView.messageOverlay.dismissButton.addTarget(self,
                                                                  action: #selector(CreationViewController.dismissOverlayView),
                                                                  for: .touchUpInside)
    }
    
    func addTargetsForPhotoView() {
        photoOptionsView.cameraButton.addTarget(self, action: #selector(CreationViewController.captureImage), for: .touchUpInside)
        photoOptionsView.photosButton.addTarget(self, action: #selector(CreationViewController.photosButtonDidTap), for: .touchUpInside)
        photoOptionsView.cameraFlipButton.addTarget(self, action: #selector(CreationViewController.toggleCamera), for: .touchUpInside)
        photoOptionsView.appShareButton.addTarget(self, action: #selector(CreationViewController.shareWithFriendsDidTap), for: .touchUpInside)
        photoOptionsView.feedbackButton.addTarget(self, action: #selector(CreationViewController.feedbackDidTap), for: .touchUpInside)
    }
    
    func addTargetsForStickerView() {
        stickerOptionsView.shareButton.addTarget(self, action: #selector(CreationViewController.shareButtonDidTap), for: .touchUpInside)
        stickerOptionsView.redoButton.addTarget(self, action: #selector(CreationViewController.cancelButtonDidTap), for: .touchUpInside)
        stickerOptionsView.appShareButton.addTarget(self, action: #selector(CreationViewController.shareWithFriendsDidTap), for: .touchUpInside)
        stickerOptionsView.feedbackButton.addTarget(self, action: #selector(CreationViewController.feedbackDidTap), for: .touchUpInside)
    }
    
    func addTargetsForShareView() {
        shareOptionsView.cancelButton.addTarget(self, action: #selector(CreationViewController.cancelButtonDidTap), for: .touchUpInside)
        shareOptionsView.backButton.addTarget(self, action: #selector(CreationViewController.backButtonDidTap), for: .touchUpInside)
        shareOptionsView.messageButton.addTarget(self, action: #selector(CreationViewController.shareImageButtonDidTap), for: .touchUpInside)
        shareOptionsView.twitterButton.addTarget(self, action: #selector(CreationViewController.shareImageButtonDidTap), for: .touchUpInside)
        shareOptionsView.facebookButton.addTarget(self, action: #selector(CreationViewController.shareImageButtonDidTap), for: .touchUpInside)
        shareOptionsView.instagramButton.addTarget(self, action: #selector(CreationViewController.shareImageButtonDidTap), for: .touchUpInside)
        shareOptionsView.saveButton.addTarget(self, action: #selector(CreationViewController.saveImageToLibrary), for: .touchUpInside)
        shareOptionsView.appShareButton.addTarget(self, action: #selector(CreationViewController.shareWithFriendsDidTap), for: .touchUpInside)
        shareOptionsView.feedbackButton.addTarget(self, action: #selector(CreationViewController.feedbackDidTap), for: .touchUpInside)
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    func setupLayout() {
        photoOptionsView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(imageView.snp.bottom)
        }
        
        stickerOptionsView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(imageView.snp.bottom)
        }
        
        shareOptionsView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(imageView.snp.bottom)
        }
        
        imageView.snp.makeConstraints({ make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(UIScreen.main.bounds.height * 0.566465257)
            make.top.equalTo(view.snp.top)
        })
        
        trash.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(15.0)
            make.top.equalTo(view.snp.top).offset(15.0)
            make.height.equalTo(35.0)
            make.width.equalTo(35.0)
        }
        
        watermarkLabel.snp.makeConstraints { make in
            make.right.equalTo(imageView.snp.right).offset(-7.0)
            make.bottom.equalTo(imageView.snp.bottom).offset(-7.0)
        }
    }
}
