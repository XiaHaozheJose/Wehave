//
//  WHOfferProductController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/27.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import SnapKit
import Photos
import TextFieldEffects
class WHOfferProductController: UIViewController {
    
    private var photosImage: [UIImage] = [#imageLiteral(resourceName: "uploadImage")]{
        didSet{
        }
    }
    private let photosCellId = "photoCellId"
    // ScrollView
    lazy var baseScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    // BottonBar
    lazy var bottomBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = ThemeColor
        return bar
    }()
    private var boardY: CGFloat?
    
    // Publish Button
    lazy var publicButton: UIButton = {
       let button = UIButton()
        button.setTitle("Publicar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(publishProduct), for: .touchUpInside)
        return button
    }()
    
    // contentView
    lazy var contentView: UIView = {
        let topView = UIView()
        topView.backgroundColor = .white
        return topView
    }()
    
    // priceView
    lazy var priceView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        return bottomView
    }()
    
    lazy var priceTxField:KaedeTextField = {
        let textField = KaedeTextField()
        textField.placeholder = "Precio".localized
        textField.placeholderColor = .darkGray
        textField.foregroundColor = ThemeColor
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
   
    // titleView
    lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.frame = CGRect(x: 0, y: kCommonMargin, width: kScreenWidth, height: 44)
        textView.placeholder = "Titulo,Marca....".localized
        textView.placeholdColor = .lightGray
        textView.placeholdFont = UIFont.systemFont(ofSize: 14)
        textView.limitLength = NSNumber(value: 64)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.returnKeyType = .done
        textView.delegate = self
        return textView
    }()
    
    // contentView
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.frame = CGRect(x: 0, y: self.titleTextView.frame.maxY + 1, width: kScreenWidth, height: kWheelHeight)
        textView.placeholder = "Descripcion del producto".localized
        textView.placeholdColor = .lightGray
        textView.placeholdFont = UIFont.systemFont(ofSize: 14)
        textView.limitLength = NSNumber(value: 256)
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.returnKeyType = .done
        textView.delegate = self
        return textView
    }()
    // Photo CollectionView
    lazy var photosView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWH = self.view.bounds.width / 5
        let margin = (self.view.bounds.width - (itemWH * 4)) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
      
        let collection: UICollectionView = UICollectionView(frame: CGRect(),collectionViewLayout: layout)
        collection.bounces = false
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .white
        collection.register(WHOfferPhotosCell.self, forCellWithReuseIdentifier: photosCellId)
        return collection
    }()
    
    
    // finished
     var published: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Publicar".localized
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
       
        
       
        setup()
        setNavigationBarItem()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @objc func keyBoardWillHide(_ notification: Notification){
        
        let kbInfo = notification.userInfo
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let changeY = kbRect.origin.y
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        
        UIView.animate(withDuration: duration) {
            self.priceView.transform = .identity
            NotificationCenter.default.removeObserver(self)
        }
}

    @objc func keyBoardWillShow(_ notification: Notification){
        //userInfo
        let kbInfo = notification.userInfo
        //size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //contentOffset
        let changeY = kbRect.origin.y
        //duration
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
       
        boardY = changeY
        UIView.animate(withDuration: duration) {
            self.priceView.transform = CGAffineTransform(translationX: 0, y: -changeY)
        }
}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // AutoLayout
    private func setup(){
        view.addSubview(baseScrollView)
        view.addSubview(bottomBar)
        baseScrollView.addSubview(contentView)
        baseScrollView.addSubview(priceView)
        priceView.addSubview(priceTxField)
        
        bottomBar.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(kTabBarHeight)
        }
        
        baseScrollView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.width.equalToSuperview()
            make.height.equalTo(kScreenHeight * 0.6)
        }
        
        priceView.snp.makeConstraints { (make) in
            
            make.width.equalToSuperview()
            make.top.equalTo(contentView.snp.bottom).offset(kCommonMargin)
            make.height.equalTo(kMenuHeight)
        }
        
        priceTxField.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(64)
            make.centerY.equalToSuperview()
        }
        
        setContentView()
        bottomBar.addSubview(publicButton)
        publicButton.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setContentView(){
        contentView.addSubview(titleTextView)
        contentView.addSubview(contentTextView)
        contentView.addSubview(photosView)
        let line = UIView()
        line.backgroundColor = UIColor(white: 0.95, alpha: 1)
        contentView.addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextView.snp.bottom)
            make.trailing.equalToSuperview().offset(-kCommonMargin)
            make.leading.equalToSuperview().offset(kCommonMargin)
            make.height.equalTo(0.5)
        }
        
        photosView.snp.updateConstraints { (make) in
            var height = kScreenHeight * 0.6 - (contentTextView.frame.maxY)
            if height < 64 + 2 * kCommonMargin{
                height = 64 + 2 * kCommonMargin
            }
            make.top.equalTo(contentTextView.snp.bottom)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    private func setPriceView(){
        
    }
    
    private func setNavigationBarItem(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "service_close").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(dissmissController))
    }
    
    @objc private func dissmissController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func publishProduct(){
        if titleTextView.text.count == 0 || contentTextView.text.count == 0 || photosImage.count <= 1{
            let alertController = UIAlertController(title: "Titulo o Descripcion o Fotos estan NULL",
                                                    message: nil, preferredStyle: .alert)
            
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }else{
            LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation {[weak self] (location, clpmark, error) in
                if let clp = clpmark,let direcName = clp.name,let postalCode = clp.postalCode{
                    let direction = direcName + "," + postalCode + "," + (clp.locality ?? "")
                    
                    let title = self?.titleTextView.text ?? "Null"
                    let content = self?.contentTextView.text ?? "Null"
                    let price = self?.priceTxField.text ?? "0.00"
                    var imagesData = [Data]()
                    var names = [String]()
                    for index in 0..<(self?.photosImage.count)! - 1{
                        if let image = self?.photosImage[index].compressImage(maxLength: 204800){
                        guard let data = UIImagePNGRepresentation(image) else {return}
                        names.append("\(index)")
                            imagesData.append(data)
                        }
                    }
                    let paramas = ["title":title,
                                   "content":content,
                                   "price":price,
                                   "localidad":direction,
                                   "userToken":Profile.default.token]
                    Networking.sharedInstance.upLoadImageRequest(urlString: WEHAVE_BASIC_LOCAL_APIs + "product", params: paramas, data: imagesData, name: names, success: { (response) in
                        self?.dismiss(animated: true, completion: nil)
                        self?.published?()
                        print(response)
                    }) { (error) in
                        print(error)
                    }
                }
            }
        }
    }
}

extension WHOfferProductController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let image = photosImage[indexPath.row]
        var isUpload = false
        if indexPath.row == photosImage.count - 1 {
            isUpload = true
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photosCellId, for: indexPath) as! WHOfferPhotosCell
        cell.setupImageView(photo:image , index: indexPath.row, isUploadImage: isUpload) { (cell,index) in
            // remove Cell
            if let indexPath = self.photosView.indexPath(for: cell){
                self.photosImage.remove(at: indexPath.item)
                self.photosView.deleteItems(at: [indexPath])
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isCanSelectPhotos() {
            let alertController = UIAlertController(title: "Maximo 6 photos",
                                                    message: nil, preferredStyle: .alert)
            
            self.present(alertController, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
            return }
        if indexPath.row == photosImage.count - 1 {
            let phManager = PHImageManager.default()
            var photos = [UIImage]()
            let maximoCount = 6 - (photosImage.count - 1)
            _ = self.presentHGImagePicker(maxSelected: maximoCount) { (assets:[PHAsset]) in
                for asset in assets{
                    let height = CGFloat(asset.pixelHeight)
                    let width = CGFloat(asset.pixelWidth)
                    var targetSize: CGSize?
                    if height / kScreenHeight >= width / kScreenWidth{// scale height
                        let scale = kScreenHeight / height
                        targetSize = CGSize(width: width * scale, height: height * scale)
                    }else{ // scale width
                        let scale = kScreenWidth / width
                        targetSize = CGSize(width: width * scale, height: height * scale)
                    }
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .highQualityFormat
                    options.resizeMode = .exact
                    options.isSynchronous = true
                    phManager.requestImage(for: asset, targetSize: targetSize!, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (targetImage, info) in
                        photos.append(targetImage!)
                    })
                }
                if self.photosImage.count > 1{
                    self.photosImage.insert(contentsOf: photos, at: self.photosImage.count - 1)
                }else{
                    self.photosImage.insert(contentsOf: photos, at: 0)
                }
                self.photosView.reloadData()
            }
        }else{
            print("select Images")
        }
    }
    
    // if can select more photosjm
    private func isCanSelectPhotos()->Bool{
        return photosImage.count < 7
    }
    
   
}

extension WHOfferProductController: UITextViewDelegate,UITextFieldDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.elementsEqual("\n") {
            textView.resignFirstResponder()
            return false
        }
     return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        priceView.transform = .identity
//        NotificationCenter.default.removeObserver(self)
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}









