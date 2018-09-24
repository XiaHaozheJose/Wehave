//
//  WHProfileViewController.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/16.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import Kingfisher
enum MenuName: String {
    case Colección = "Colección"
    case Descarga = "Descarga"
    case Pedido = "Pedido"
    case Diario = "Diario"
    case Preguntas = "Preguntas"
    case Comentarios = "Comentarios"
    case Cupónes = "Cupónes"
    case Cartera = "Cartera"
    case Festivos = "Festivos"
}

class WHProfileViewController: UIViewController {


    
    fileprivate let cellMargin: CGFloat = 2.0
    
    fileprivate let menuDatos = [
        ["title":"Colección","image":#imageLiteral(resourceName: "coleccion")],
        ["title":"Descarga","image":#imageLiteral(resourceName: "download")],
        ["title":"Pedido","image":#imageLiteral(resourceName: "pedido")],
        ["title":"Diario","image":#imageLiteral(resourceName: "diario")],
        ["title":"Preguntas","image":#imageLiteral(resourceName: "dudas")],
        ["title":"Comentarios","image":#imageLiteral(resourceName: "login_comentario")],
        ["title":"Cupónes","image":#imageLiteral(resourceName: "oferta")],
        ["title":"Cartera","image":#imageLiteral(resourceName: "cartera")],
        ["title":"Festivos","image":#imageLiteral(resourceName: "festivo")]
    ]
    
    // Identifier
    fileprivate let menuCellIdentifier = "MenuCellIdentifier"
    
    // itemWH
    private var menuItemWH: CGFloat{ get{ return kScreenWidth / 3 }}
    // IBOutlet
    @IBOutlet weak var loginGifImageView: WHGifImage!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var oroCountLabel: UILabel!
    @IBOutlet weak var loginRegisterBtn: UIButton!
    @IBOutlet weak var topLoginView: UIView!
    @IBOutlet weak var topProfileView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var pushTextButton: UIButton!
    @IBOutlet weak var profileImageIcon: UIImageView!
    @IBOutlet weak var loginoutBtn: UIButton!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var goldLabel: UILabel!
    
    
    private var isLogin: Bool?{
        didSet{
            if isLogin == true {
                self.topLoginView.isHidden = true
                self.topProfileView.isHidden = false
                setDataProfile()
            }else{
                self.topProfileView.isHidden = true
                self.topLoginView.isHidden = false
            }}}
    
    // collectionView
    fileprivate lazy var menuCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: menuItemWH, height: menuItemWH)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let collection: UICollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: self.checkView.frame.maxY + kCommonMargin, width: kScreenWidth, height: kScreenHeight - self.checkView.frame.maxY - kCommonMargin - kTabBarHeight), collectionViewLayout: flowLayout)
        collection.backgroundColor = .clear
        collection.register(UINib.init(nibName: "WHProfileMenuCell", bundle: nil), forCellWithReuseIdentifier: menuCellIdentifier)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addSubChildsForMenuView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if !verificaProfile(){ loginGifImageView.start() }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if !verificaProfile(){ loginGifImageView.stop() }
    }
    
    // Login Button
    @IBAction func clickToLoginAndRegister(_ sender: UIButton) {
        showLoginView()
    }
    
    @IBAction func clickToSetting(_ sender: UIButton) {
   
    }
    
    @IBAction func clickToCustomEmail(_ sender: UIButton) {
    }
    
    @IBAction func clickToCheck(_ sender: UIButton) {
   
    }
    
    @IBAction func clickToLoginout(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Aviso".localized, message: "¿Está seguro de que desea cerrar la sesión?".localized, preferredStyle: .alert)
        let aceptAction = UIAlertAction(title: "Sí".localized, style: .destructive) { (action) in
            UserDefaults.standard.set(false, forKey: "autoLogin")
            self.showLoginView()
        }
        let cancelAction = UIAlertAction(title: "NO", style: .default, handler: nil)
        alertVC.addAction(aceptAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func showLoginView(){
        let loginVC = WHLoginViewController()
        let nav = WHNavigationController(rootViewController: loginVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    
}


// MARK: - Setup
extension WHProfileViewController{
    private func setup(){
        
        pushTextButton.setTitle("Gracias".localized, for: .normal)
        goldLabel.text = "Oro".localized
        // image Path
        guard let bundleURL = Bundle.main.url(forResource: "wehave_gif", withExtension: "gif") else { return }
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else { return }
        
        // set Gif
        loginGifImageView.gifData = imageData
        loginGifImageView.start()
        
        // Layer
        loginRegisterBtn.layer.cornerRadius = 5
        loginRegisterBtn.layer.masksToBounds = true
        
        checkButton.layer.cornerRadius = 5
        checkButton.layer.masksToBounds = true
        
        pushTextButton.layer.cornerRadius = pushTextButton.frame.height * 0.5
        pushTextButton.layer.masksToBounds = true
        
        profileImageIcon.layer.cornerRadius = profileImageIcon.frame.width * 0.5
        profileImageIcon.layer.masksToBounds = true
        profileImageIcon.addGestureRecognizer(UITapGestureRecognizer(target:self,
                                                                     action:#selector(loadProfileImageIcon)))
        
        loginoutBtn.layer.cornerRadius = loginoutBtn.frame.height * 0.5
        loginoutBtn.layer.masksToBounds = true
        
        
        
        
    }
    
    // CollectionView Menu
    private func addSubChildsForMenuView(){
        view.addSubview(menuCollectionView)
        
    }
    
    // Verifica IsLogin Auto
    private func verificaProfile()->Bool{
                if UserDefaults.standard.bool(forKey: "autoLogin") == true{
            guard let _ = Profile.default.loadAccountData() else {
                isLogin = false
                UserDefaults.standard.set(false, forKey: "autoLogin")
                return false}
            isLogin = true
            return isLogin!
        }else{
            isLogin = false
            return isLogin!
        }
    }
    
    // setProfile Data
    private func setDataProfile(){
        userNameLabel.text = Profile.default.userName
        descriptionLabel.text = "Master App Movil 17-18."
        descriptionLabel.textColor = .blue
        view.backgroundColor = .lightGray
        let url = WEHAVE_BASIC_LOCAL_APIs + "Images?path=\(Profile.default.imageUrl)"
        let resource = ImageResource(downloadURL: URL.init(string: url)!)
        profileImageIcon.kf.setImage(with:resource, placeholder:#imageLiteral(resourceName: "profileIcon")) { (image, error, cacheType, url) in
            // some thing
        }
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension WHProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuDatos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellIdentifier, for: indexPath) as! WHProfileMenuCell
        cell.image = menuDatos[indexPath.row]["image"] as? UIImage
        cell.title = menuDatos[indexPath.row]["title"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showAlert(title: "Esta Desarrollando 😊")
    }
}


// MARK: - Selector
extension WHProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   @objc private func loadProfileImageIcon(){
        handleSelectProfileImageView()
    }
    
    private func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true // can edit
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let userToken = Profile.default.token
        if let editImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            let imageCompress = editImage.compressImage(maxLength: 20480)
            guard let data = UIImagePNGRepresentation(imageCompress) else {return}
            Networking.sharedInstance.upLoadImageRequest(urlString: WEHAVE_BASIC_LOCAL_APIs + "upload/icon", params: ["userToken":userToken], data: [data], name: [userToken+"_icon"], success: { (response) in
                print(response)
                if let url = response["url"] as? String {
                    self.updateProfile(imageUrl: url)
                }
            }) { (error) in
                self.showAlert(title: "Upload Error")
            }
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let imageCompress = originalImage.compressImage(maxLength: 20480)
            guard let data = UIImagePNGRepresentation(imageCompress) else {return}
            Networking.sharedInstance.upLoadImageRequest(urlString: WEHAVE_BASIC_LOCAL_APIs + "upload/icon", params: ["userToken":userToken], data: [data], name: [userToken+"_icon"], success: { (response) in
                if let url = response["url"] as? String {
                    self.updateProfile(imageUrl: url)
                }
            }) { (error) in
                self.showAlert(title: "Upload Error")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func updateProfile(imageUrl: String){
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        Profile.default.imageUrl = imageUrl
        if Profile.default.saveAccountData(){
            self.setDataProfile()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
   private func showAlert(title: String){
        let alertController = UIAlertController(title: title,
                                                message: nil, preferredStyle: .alert)
        alertController.view.alpha = 0.8
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    
}


// MARK: - CameraDelegate
extension WHBaseGroupViewController: WHCameraViewDelegate{
    func didShutterImage(image: UIImage?) {
        
    }
}
