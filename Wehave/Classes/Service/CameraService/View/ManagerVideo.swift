//
//  ManagerVideo.swift
//  Camera_Video
//
//  Created by 浩哲 夏 on 2017/11/25.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos

let identifier = "videoCell"
let statusHeight = UIApplication.shared.statusBarFrame.height
let topHeight: CGFloat = 49
let bottomHeight: CGFloat = 44

class ManagerVideo: UIViewController {

    private var allVideosPath: [String]?    // Path Of Videos
    private var allImageArray = [UIImage]() //
    
    private var numberArray = [NSNumber]()  // Selected Video
    private var videosCollectionView: UICollectionView? // collectionView
    private var isSelectedAble = false // is can Select
    private var operatorVideoArray = [String]() //Videos Lists
    private var operatorVideoImages = [UIImage]() // ScreenShot List
    private var bottomView: UIView?
    private var countLabel = UILabel()
    lazy var topView: UIView = {
        let bar = UIView()
        bar.frame = CGRect(x: 0, y: statusHeight, width: kScreenWidth, height: 49)
        bar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return bar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        allVideosPath = getVideosPaths()
        videosCollectionView = setCollectionView()
        setChooseButton()
        setBottomView()
        getScreenShots(videoUrls: allVideosPath!)
        
        
    }
}

extension ManagerVideo{

    fileprivate func getVideosPaths()->[String]{
        var pathArr = [String]()
        let pathFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        guard let pathString = pathFolder else {return [String]()}
        if let lists = try? FileManager.default.contentsOfDirectory(atPath: pathString) {
            for fileName in lists{
                if fileName.contains("_wehave"){
                pathArr.append(pathString + "/" + fileName)
                }
            }
        }
        for _ in pathArr{
            numberArray.append(1)
        }
        return pathArr
    }
    
    
    fileprivate func setCollectionView()->UICollectionView{
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.init(x: 0, y:topHeight + statusHeight, width: kScreenWidth, height: kScreenHeight - topHeight - statusHeight), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        flowLayout.itemSize = CGSize(width: (kScreenWidth - (5 * kCommonMargin)) / 4, height: (kScreenHeight - (5 * kCommonMargin)) / 4)
        collectionView.contentInset = UIEdgeInsetsMake(kCommonMargin, kCommonMargin, kCommonMargin, kCommonMargin)
        flowLayout.minimumLineSpacing = kCommonMargin
        flowLayout.minimumInteritemSpacing = kCommonMargin
        collectionView.register(VideoCollectionCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        return collectionView
    }
    
    //SelectButton
    fileprivate func setChooseButton(){
        let chooseBtn = UIButton(frame: CGRect(x: kScreenWidth - 90, y: 10, width: 80, height: 30))
        chooseBtn.setTitle("SELECT", for: .normal)
        chooseBtn.setTitle("CANCEL", for: .selected)
        chooseBtn.setTitleColor(.white, for: .normal)
        chooseBtn.setTitleColor(.red, for: .selected)
        
        chooseBtn.addTarget(self, action: #selector(chooseAction(btn:)), for: .touchUpInside)
        
        let cancelBtn = UIButton(frame: CGRect(x: 20, y: 10, width: 50, height: 30))
        cancelBtn.setTitle("BACK", for: .normal)
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.addTarget(self, action: #selector(dismissButton), for: .touchUpInside)
        
        view.addSubview(topView)
        topView.addSubview(chooseBtn)
        topView.addSubview(cancelBtn)
    }
    
    //Bottom View
    fileprivate func setBottomView(){
        bottomView = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: bottomHeight))
        view.addSubview(bottomView!)
        bottomView?.addSubview(setBottomBtn(title: "Submit", center: CGPoint.init(x: kScreenWidth / 4, y: bottomHeight / 2), target: self, action: #selector(submitAction)))
        bottomView?.addSubview(setBottomBtn(title: "Delete", center: CGPoint.init(x: kScreenWidth * 3 / 4, y: bottomHeight / 2), target: self, action: #selector(deleteAction)))
        setCountLabel()
       
    }
    
    // Get Image With FilePath
    fileprivate func getScreenshot(videoUrl: URL)->UIImage?{
        let videoAsset = AVURLAsset(url: videoUrl)
        let cmTime = CMTime(seconds: 1, preferredTimescale: 10)
        let imageGenerator = AVAssetImageGenerator(asset: videoAsset)
        if let cgImage = try? imageGenerator.copyCGImage(at: cmTime, actualTime: nil){
           return UIImage(cgImage: cgImage)
        }else{
            print("Can't Get screenShot")
        }
        return nil
    }
    // Get Image With FilePath
    fileprivate func getScreenShots(videoUrls: [String]){
        DispatchQueue.global().async {
            for path in videoUrls{
                let url = URL.init(fileURLWithPath: path)
                if let image = self.getScreenshot(videoUrl: url){
                    self.allImageArray.append(image)
                }
            }
            DispatchQueue.main.async {
                self.videosCollectionView?.reloadData()
            }
        }
    }
    
    private func setBottomBtn(title: String, center: CGPoint,target: Any?, action: Selector)->UIButton{
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenWidth / 3, height: bottomHeight - 10))
        btn.center = center
        btn.setTitle(title, for: .normal)
        btn.backgroundColor = .red
        btn.clipsToBounds = true
        btn.layer.cornerRadius  = 15
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        return btn
    }
    
    private func setCountLabel(){
        countLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        countLabel.layer.cornerRadius = 15
        countLabel.clipsToBounds = true
        countLabel.backgroundColor = .red
        countLabel.textColor = .white
        countLabel.text = "0"
        countLabel.textAlignment = .center
        countLabel.center = CGPoint.init(x: kScreenWidth / 2, y: bottomHeight / 2)
        bottomView?.addSubview(countLabel)
    }
    
    fileprivate func showBottomView(isShow: Bool){
        if isShow {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                self.bottomView?.frame.origin.y -= bottomHeight
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomView?.frame.origin.y += bottomHeight
            })
        }
    }
}


extension ManagerVideo{
    @objc fileprivate func chooseAction(btn: UIButton){
        btn.isSelected = !btn.isSelected
        showBottomView(isShow:btn.isSelected)
        handleChooseActionn(isChoose: btn.isSelected)
    }
    
    @objc fileprivate func dismissButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // Sava To Album // You Can Submit To ICLOUD And Nube
    @objc fileprivate func submitAction(){
        var message: String = ""

        if operatorVideoArray.count != 0 {
            for path in operatorVideoArray{
                let url = URL(fileURLWithPath: path)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                    }, completionHandler: { (seccess, error) in
                        if error == nil && seccess{
                            message = "Saved In Album "
                        }else{
                            message = "Failed: \(error.debugDescription)"
                        }
                    })
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Finished", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @objc fileprivate func deleteAction(){
        if operatorVideoArray.count != 0 {
        
            for path in operatorVideoArray{
            do{
                try FileManager.default.removeItem(atPath: path)
            }catch let error{
                print("Failed Delete \(error)")
                
                }
                
            }
        
            for index in 0..<operatorVideoArray.count{
            let img = operatorVideoImages[index]
            if let currentIndex = allImageArray.index(of: img){
            allImageArray.remove(at: currentIndex)
            }
          }
        
        allVideosPath?.removeAll()
        operatorVideoImages.removeAll()
        allVideosPath = getVideosPaths()
        
        operatorVideoArray.removeAll()
        countLabel.text = "0"
        
        handleChooseActionn(isChoose: true)
        }
    }
    
    private func handleChooseActionn(isChoose: Bool){
        isSelectedAble = isChoose
        operatorVideoArray.removeAll()
        if isSelectedAble {
            for index in 0..<numberArray.count{
                numberArray[index] = 0
            }
        }else{
            for index in 0..<numberArray.count{
                numberArray[index] = 1
            }
        }
        
        videosCollectionView?.reloadData()
    }
    
}

extension ManagerVideo: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allVideosPath?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! VideoCollectionCell
        if allVideosPath?.count == allImageArray.count {
            cell.videoInterface?.image = allImageArray[indexPath.row]
        }
        if isSelectedAble {
            cell.selectedButton.isHidden = false
            cell.videoIsChoose = numberArray[indexPath.row].boolValue
        }else{
            cell.selectedButton.isHidden = true
            cell.videoIsChoose = numberArray[indexPath.row].boolValue
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! VideoCollectionCell
        guard isSelectedAble else {
            let url = URL.init(fileURLWithPath: allVideosPath![indexPath.row])
            let player = AVPlayer(url:url)
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true, completion: nil)
            return
        }
        
        
        cell.videoIsChoose = !cell.videoIsChoose!
        
        if cell.videoIsChoose == true {
            operatorVideoArray.append(allVideosPath![indexPath.row])
            operatorVideoImages.append(allImageArray[indexPath.row])
        }else{
            if let index = operatorVideoArray.index(of: allVideosPath![indexPath.row]){
            operatorVideoArray.remove(at: index)
            operatorVideoImages.remove(at: index)
            }
        }
        countLabel.text = "\(operatorVideoArray.count)"
        numberArray[indexPath.row] = NSNumber(value: cell.videoIsChoose!)
    }
    
}
extension ManagerVideo: UICollectionViewDelegate{
    
}
