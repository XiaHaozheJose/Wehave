//
//  WHCameraViewController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/3.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol WHCameraViewDelegate: NSObjectProtocol {
    @objc optional func didShutterImage(image: UIImage?)
}

class WHCameraViewController: UIViewController {
    
    // MARK: - Variable
    var delegate: WHCameraViewDelegate?
    private let actionSize = CGSize(width: 70, height: 70)
    private let startPoint = CGPoint(x: kScreenWidth / 2, y: kScreenHeight - 70)
    private let endPoint = CGPoint(x: kScreenWidth / 2 + 70, y: kScreenHeight - 50)
    private let imageFrame = CGRect(x: kCommonMargin, y: kScreenHeight - 100 - kCommonMargin, width: 70, height: 100)
    private let MAXRECORD_TIME = 6000   // maximo Record Time => Secons
    private lazy var captureSession = AVCaptureSession()    //Session Coordinate input and output
    private var camera: AVCaptureDevice?    //Device Camera
    private var previewLayer: AVCaptureVideoPreviewLayer! //Show Layer
    private var headerView: UIView! // HeaderView
    private var audioDevide: AVCaptureDevice!   //Device Audio
    private lazy var fileOut = AVCaptureMovieFileOutput()   //outPut File
    private var startRecord: UIButton!   //Action Record
    private var cameraSideButton, flashLightButton: UIButton!   //Other Action Of Camera
    var totalTimeLabel: UILabel!    //RecordTime => Label
    var timer: Timer?   //RecordTime => Timer
    private var second = 0 // timer Second
    private var isRecording = false  //
    
    //    var operatorView: OperatorView!
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(editPhoto(tap:)))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    // PhotoSetting
    lazy var cameraSetting: AVCapturePhotoSettings = {
        let setting = AVCapturePhotoSettings()
        return setting
    }()
    // Focus View
    private var autoFocus: UIView!
    // Rimind View
    private var newRimind: UIView!
    // Button Shutter Photo
    private var shutter: UIButton!
    // Button ManagerVideo
    private var managerVideo: UIButton!
    //AVCaptureStillImageOutput  (Before iOS10.0)
    private var shutterOutPut: AVCaptureStillImageOutput!
    
    // Show Camera o Video
    var isVideo: Bool?{
        didSet{ if isVideo! {
            shutter.isHidden = true
            startRecord.isHidden = false
            managerVideo.isHidden = false
        }  else{
            shutter.isHidden = false
            startRecord.isHidden = true
            managerVideo.isHidden = true
            }}}
    
    
    // MARK: - Ciclo De Vida
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setDefaultSettins()
        setActionButton()
        setHeaderView()
        setFocus()
        isVideo = false
        totalTimeLabel.isHidden = true
    }
    
}

// MARK: - UI
extension WHCameraViewController{
    fileprivate func setDefaultSettins(){
        // Get Camera => Back
        self.camera = cameraWithPosition(position: AVCaptureDevice.Position.back)
        audioDevide = AVCaptureDevice.default(for: AVMediaType.audio)
        guard let camera = self.camera else {  return }
        // Get Microfono
        self.audioDevide = AVCaptureDevice.default(for: .audio)
        guard let audioDevide = self.audioDevide else {return}
        
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080 // For Video Quality
        // Set VideoInput
        if let videoInput = try? AVCaptureDeviceInput(device: camera){
            captureSession.addInput(videoInput)
        }
        //Set AudioInput
        if let audioInput = try? AVCaptureDeviceInput(device: audioDevide){
            captureSession.addInput(audioInput)
        }
        // Set FileOutPut
        captureSession.addOutput(fileOut)
        
        // Set ShowLayer
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
        previewLayer = videoLayer
        
        
        shutterOutPut = AVCaptureStillImageOutput()
        shutterOutPut.outputSettings = [AVVideoCodecKey:AVVideoCodecType.jpeg]
        if captureSession.canAddOutput(shutterOutPut){
            captureSession.addOutput(shutterOutPut)
        }
        
        //Start Session
        captureSession.startRunning()
    }
    
    // Action Button
    fileprivate func setActionButton(){
        
        //StartAction
        startRecord = initRecordButton(normalImage: #imageLiteral(resourceName: "record_start"), selectImage: #imageLiteral(resourceName: "record_stop"), size: actionSize, center: startPoint, target: self, action: #selector(starAction(action:)))
        view.addSubview(startRecord)
        
        shutter = initRecordButton(normalImage: #imageLiteral(resourceName: "shutter"), selectImage:#imageLiteral(resourceName: "shutter_h") , size: actionSize, center: startPoint, target: self, action: #selector(shutterPhoto))
        view.addSubview(shutter)
    }
    
    // HeaderView
    fileprivate func setHeaderView(){
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 64))
        headerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.addSubview(headerView)
        
        let centerY = headerView.center.y + 5.0
        let defaultWidth: CGFloat = 40.0
        
        /**
         * Tools Button In HeaderView
         */
        managerVideo = initToolsButton(width: 30, height: 30, image: #imageLiteral(resourceName: "video"), selectedImage: nil, centerPoint: CGPoint.init(x:30 , y: startRecord.center.y), target: self, action: #selector(managerAction))
        newRimind = UIView(frame: CGRect(x: managerVideo.bounds.width-10, y: -10, width: 20, height: 20))
        newRimind.layer.cornerRadius = 10
        newRimind.clipsToBounds = true
        newRimind.backgroundColor = .red
        newRimind.isHidden = true
        managerVideo.addSubview(newRimind)
        view.addSubview(managerVideo)
        cameraSideButton = initToolsButton(width: defaultWidth, height: defaultWidth * 3 / 4, image: #imageLiteral(resourceName: "camera_side"), selectedImage: nil, centerPoint: CGPoint.init(x: 100, y: centerY), target: self, action: #selector(changeCamera(action:)))
        headerView.addSubview(cameraSideButton)
        
        flashLightButton = initToolsButton(width: defaultWidth, height: defaultWidth * 3 / 4, image: #imageLiteral(resourceName: "flash_off"), selectedImage: #imageLiteral(resourceName: "flash_on"), centerPoint: CGPoint.init(x: headerView.bounds.width - 100, y: centerY), target: self, action: #selector(switchFlashLight(action:)))
        headerView.addSubview(flashLightButton)
        
        let backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back_white"), for: .normal)
        backButton.setImage(#imageLiteral(resourceName: "back_black"), for: .highlighted)
        backButton.sizeToFit()
        backButton.frame.origin = CGPoint(x: kCommonMargin, y:self.headerView.centerY)
        backButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        headerView.addSubview(backButton)
        
        
        totalTimeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        totalTimeLabel.center = CGPoint(x: headerView.center.x, y: centerY)
        totalTimeLabel.textColor = .white
        totalTimeLabel.textAlignment = .center
        totalTimeLabel.font = UIFont.systemFont(ofSize: 15)
        totalTimeLabel.text = "00:00:00"
        view.addSubview(totalTimeLabel)
    }
    
    // Focus View
    fileprivate func setFocus(){
        autoFocus = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        autoFocus.backgroundColor = .clear
        
        let line1 = UIView(frame: CGRect(x: 0, y: 29.5, width: 60, height: 1))
        line1.backgroundColor = .white
        autoFocus.addSubview(line1)
        let line2 = UIView(frame: CGRect(x: 29.5, y: 0, width: 1, height: 60))
        line2.backgroundColor = .white
        autoFocus.addSubview(line2)
        
        autoFocus.isHidden = true
        
        let focusTap = UITapGestureRecognizer(target: self, action: #selector(focus(tap:)))
        view.addGestureRecognizer(focusTap)
        view.addSubview(autoFocus)
        
    }
    
    /// Get Camera With Position
    private func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice?{
        
        if let device = AVCaptureDevice.default(.builtInDuoCamera, for: .video, position: position){
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position){
            return device
        } else {
            return nil
        }
    }
    
    /// init Default Button
    private func initRecordButton(normalImage: UIImage, selectImage: UIImage, size: CGSize, center: CGPoint, target: Any?, action: Selector)->UIButton{
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        btn.center = center
        btn.layer.cornerRadius = 35
        btn.clipsToBounds = true
        btn.setBackgroundImage(normalImage, for: .normal)
        btn.setBackgroundImage(selectImage, for: .selected)
        btn.addTarget(target, action:action, for: .touchUpInside)
        return btn
        
    }
    
    private func initShutterButton(normalImage: UIImage, hImage: UIImage, target: Any?, action: Selector)->UIButton{
        
        let btn = UIButton(frame: CGRect(x: kScreenWidth - kCommonMargin - actionSize.width, y: kScreenHeight - actionSize.height - kCommonMargin, width: actionSize.width, height: actionSize.height))
        btn.setBackgroundImage(normalImage, for: .normal)
        btn.setBackgroundImage(hImage, for: .highlighted)
        btn.addTarget(target, action: action, for: .touchUpInside)
        return btn
    }
    
    // init Tools Button
    private func initToolsButton(width: CGFloat, height: CGFloat, image: UIImage, selectedImage: UIImage?, centerPoint: CGPoint, target: Any?, action: Selector) -> UIButton{
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
        if selectedImage != nil {
            btn.setBackgroundImage(selectedImage, for: .selected)
        }
        btn.setBackgroundImage(image, for: .normal)
        btn.center = centerPoint
        btn.addTarget(centerPoint, action: action, for: .touchUpInside)
        return btn
    }
    
   @objc private func dismissController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

// MARK: - SELECTOR
extension WHCameraViewController{
    
    @objc fileprivate func starAction(action: UIButton){
        if action.isSelected {
            endAction(action: action)
        }else{
            hiddenHeaderView(isHidden: true)
            // timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(recordTime), userInfo: nil, repeats: true)
            if !isRecording {
                isRecording = true
                captureSession.startRunning()
                
                // Save To Document
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                
                guard let documentDirectory = path.last else{return}
                let filePath = "\(documentDirectory)/\(Date().timeIntervalSince1970)_wehave.mp4"
                let fileUrl = URL(fileURLWithPath: filePath)
                //Start FileOutPut
                fileOut.startRecording(to: fileUrl, recordingDelegate: self)
            }
        }
        action.isSelected = !action.isSelected
    }
    
    // End Record
    @objc fileprivate func endAction(action: UIButton){
        hiddenHeaderView(isHidden: false)
        timer?.invalidate()
        timer = nil
        second = 0
        totalTimeLabel.text = "00:00:00"
        newRimind.isHidden = false
        
        if isRecording {
            // For No Main Plot
            DispatchQueue.global().async {
                self.captureSession.stopRunning()
                DispatchQueue.main.async {
                    self.captureSession.startRunning()
                }
            }
            isRecording = false
        }
        if flashLightButton.isSelected{
            switchFlashLight(action: flashLightButton)
        }
    }
    
    @objc fileprivate func managerAction(){
        
        if isRecording {
            starAction(action: startRecord)
        }
        newRimind.isHidden = true
        let managerVideo = ManagerVideo()
        managerVideo.modalTransitionStyle = .flipHorizontal
        present(managerVideo, animated: true, completion: nil)
    }
    
    //Change Camera
    @objc fileprivate func changeCamera(action: UIButton){
        cameraSideButton.isSelected = !cameraSideButton.isSelected
        captureSession.stopRunning()
        
        if let allInputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in allInputs{
                captureSession.removeInput(input)
            }
        }
        cameraAnimation()
        
        if let audio = try? AVCaptureDeviceInput(device: audioDevide){
            captureSession.addInput(audio)
        }
        if cameraSideButton.isSelected{
            camera = cameraWithPosition(position: .front)
            if let input = try? AVCaptureDeviceInput(device: camera!){
                captureSession.addInput(input)
            }
            
            if flashLightButton.isSelected{
                flashLightButton.isSelected = false
            }
            flashLightButton.isHidden = true
        }else{
            camera = cameraWithPosition(position: .back)
            if let input = try? AVCaptureDeviceInput(device: camera!){
                captureSession.addInput(input)
            }
            flashLightButton.isHidden = false
        }
    }
    
    // Set Flash
    @objc fileprivate func switchFlashLight(action: UIButton){
        if camera?.position == AVCaptureDevice.Position.front {
            return
        }
        
        let backCamera = cameraWithPosition(position: .back)
        if backCamera?.torchMode == .off {
            do{
                try backCamera?.lockForConfiguration()
            }catch let error {
                print("Error Flash: \(error)")
            }
            backCamera?.torchMode = .on
            cameraSetting.flashMode = .on
            backCamera?.unlockForConfiguration()
            
            flashLightButton.isSelected = true
        }else{
            do{
                try backCamera?.lockForConfiguration()
            }catch let error{
                print("Close Flash Error: \(error)")
            }
            backCamera?.torchMode = .off
            cameraSetting.flashMode = .off
            backCamera?.unlockForConfiguration()
            flashLightButton.isSelected = false
        }
    }
    
    //tap focus
    @objc fileprivate func focus(tap: UITapGestureRecognizer){
        if camera?.position == AVCaptureDevice.Position.front {
            return
        }
        
        if tap.state == UIGestureRecognizerState.recognized {
            let location = tap.location(in: self.view)
            
            focusOnPoint(point: location, completionHangler: {[weak self] in
                self?.autoFocus.center = location
                self?.autoFocus.alpha = 0.0
                self?.autoFocus.isHidden = false
                UIView.animate(withDuration: 0.25, animations: {
                    self?.autoFocus.alpha = 1.0
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.25, animations: {
                        self?.autoFocus.alpha = 0
                    })
                })
            })
        }
    }
    // click to shutter
    @objc fileprivate func shutterPhoto(){
        if let connection = shutterOutPut.connection(with: .video){
            shutterOutPut.captureStillImageAsynchronously(from: connection, completionHandler: { [weak self](buffer, error) in
                if buffer != nil{
                    guard  let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer!)else{return}
                    guard let image = UIImage.init(data: imageData)else{return}
                    self?.shutterAlert()
                    self?.showCaptureImage(image: image)
                    
                    if self?.delegate?.responds(to: #selector(self?.delegate?.didShutterImage(image:))) == true {
                        self?.delegate?.didShutterImage!(image: image)
                    }
                }
            })
        }
        
    }
    
    // tap to edit photo
    @objc fileprivate func editPhoto(tap:UITapGestureRecognizer){
        let editImage = JS_ImageContainer(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        editImage.imageData(data: UIImageJPEGRepresentation(imageView.image!, 1)!)
        editImage.isUserInteractionEnabled = true
        editImage.editBackImage = {[weak self](image) in
            UIView.animate(withDuration: 0.25, animations: {
                editImage.alpha = 0.0
                self?.imageView.alpha = 0.0
            }, completion: { (_) in
                editImage.removeFromSuperview()
                self?.imageView.image = nil
            })
        }
        view.addSubview(editImage)
    }
    
    // Hidden HeaderView When Recording
    private func hiddenHeaderView(isHidden: Bool){
        if isHidden {
            UIView.animate(withDuration: 0.2, animations: {
                self.headerView.frame.origin.y -= 64
            })
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.headerView.frame.origin.y += 64
            })
        }
    }
    
    // sound Camera
    private func shutterAlert(){
        guard let filePath = Bundle.main.path(forResource: "sound.mp3", ofType: nil)else{return}
        let url = URL.init(fileURLWithPath: filePath)
        var sound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL,&sound)
        AudioServicesPlaySystemSound(sound)
    }
    
    
    // show picture small
    private func showCaptureImage(image: UIImage){
        imageView.frame = view.bounds
        imageView.image = image
        view.addSubview(imageView)
        UIView.animate(withDuration: 0.25) {
            self.imageView.frame = self.imageFrame
            self.imageView.alpha = 1.0
        }
    }
    
    // remove photo capture
    private func dissImageView(imageView: UIImageView){
        UIView.animate(withDuration: 0.5, animations: {
            imageView.alpha = 0.0
        }, completion: { (finish) in
            imageView.removeFromSuperview()
        })
    }
    
    // save photo to album
    @objc private func savePhoto(){
        guard let image = imageView.image else{return}
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dissImageView(imageView: imageView)
    }
    
    // Update Time
    @objc private func recordTime(){
        second += 1
        if second == MAXRECORD_TIME {
            timer?.invalidate()
            let alert = UIAlertController(title: "Over Time" , message: "Maximo Recoding 10 Minutes", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        let hours = second / 3600
        let minutes = (second % 3600) / 60
        let seconds = second % 60
        
        totalTimeLabel.text = String(format: "%02d", hours) + ":" + String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
    
    // ChangeCamera Animation
    private func cameraAnimation(){
        let changeAnimate = CATransition()
        changeAnimate.delegate = self
        changeAnimate.duration = 0.5
        changeAnimate.type = "oglFlip"
        changeAnimate.subtype = kCATransitionFromRight
        previewLayer.add(changeAnimate, forKey: "changeAnimate")
    }
    
}

// MARK: - AVCaptureFileOutputRecordingDelegate
extension WHCameraViewController: AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
    }
    
    @objc fileprivate func focusOnPoint(point: CGPoint,completionHangler: (()->())?){
        guard let device = camera else {
            return}
        
        var pointOfInterest = CGPoint.zero
        let frameSize = view.bounds.size
        
        pointOfInterest = CGPoint(x: point.y/frameSize.height, y: 1 - (point.x / frameSize.width))
        if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.autoFocus) {
            // Obligatorio  ##IMPORTANT lockForConfiguration
            do{
                try device.lockForConfiguration()
            }catch let error{
                print("Error: \(error)")
            }
            if device.isWhiteBalanceModeSupported(AVCaptureDevice.WhiteBalanceMode.autoWhiteBalance){
                device.whiteBalanceMode = .autoWhiteBalance
            }
            if device.isFocusModeSupported(.autoFocus){
                device.focusMode = .autoFocus
                device.focusPointOfInterest = pointOfInterest
            }
            if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(.autoExpose){
                device.exposureMode = .autoExpose
                device.exposurePointOfInterest = pointOfInterest
            }
            device.unlockForConfiguration()
            completionHangler?()
        }else{
            completionHangler?()
        }
    }
    
}


// MARK: - CAAnimationDelegate
extension WHCameraViewController: CAAnimationDelegate{
    func animationDidStart(_ anim: CAAnimation) {
        captureSession.startRunning()
    }
}

