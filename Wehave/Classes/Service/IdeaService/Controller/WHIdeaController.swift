//
//  WHIdeaController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/9.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHIdeaController: UIViewController {
    
    
    let guiaCellIdentifier = "guiaIdentifier"
    var guiasModel:[GuiaModel]?{
        didSet{
            self.guiasTableView.reloadData()
        }
    }
    var htmlString = ""
    var isNeedAttribute: Bool = false
    var imagePath: [String] = [String]()
    
    lazy var guiasTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: kNavigationBarHeight, width: kScreenWidth, height: kScreenHeight - kNavigationBarHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "WHGuiaTableCell", bundle: nil), forCellReuseIdentifier: guiaCellIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Guias".localized
        view.backgroundColor = .white
        setNavigationButton()
        view.addSubview(guiasTableView)
        
        getGuias()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

private extension WHIdeaController{
    func setNavigationButton(){
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Volver".localized, style: .done, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Crear".localized, style: .done, target: self, action: #selector(crearGuia))
    }
    
    @objc func close(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func crearGuia(){
        if UserDefaults.standard.bool(forKey: "autoLogin") == true{
            _ = Profile.default.loadAccountData()
            let rich = UIStoryboard(name: "RichText", bundle: nil).instantiateViewController(withIdentifier: "RichTextViewController") as! RichTextViewController
            rich.rtDelegate = self
            rich.textType = RichTextType.htmlString
            rich.content = htmlString
            rich.finished = {[weak self](content,imagArr) in
                self?.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.pushViewController(rich, animated: true)
        }else{
            present(WHNavigationController(rootViewController: WHLoginViewController()), animated: true, completion: nil)
        }
        
    }
}

extension WHIdeaController: RichTextViewControllerDelegate{
    func uploadImageArray(_ imageArr: [Any]!, withCompletion completion: (([Any]?) -> String?)!) {
        
        if let imageArray = imageArr as? [UIImage], imageArray.count > 0{
            var pathsArray: [PictureModel] = [PictureModel]()
            var imageData:[Data] = [Data]()
            var imageName: [String] = [String]()
            var imageWidth:[String] = [String]()
            var imageHeight:[String] = [String]()
            for (_,image) in imageArray.enumerated() {
                let height = CGFloat(image.size.height)
                let width = CGFloat(image.size.width)
                var targetSize = CGSize(width: width, height: height)
                if height / kScreenHeight >= width / kScreenWidth{// scale height
                    let scale = kScreenHeight / height
                    targetSize = CGSize(width: width * scale - 20, height: height * scale - 20)
                }else{ // scale width
                    let scale = kScreenWidth / width
                    targetSize = CGSize(width: width * scale - 20, height: height * scale - 20)
                }
                guard let data = UIImagePNGRepresentation(image) else {return}
                imageName.append(Profile.default.token + "guiaImage")
                imageData.append(data)
                imageWidth.append("\(targetSize.width)")
                imageHeight.append("\(targetSize.height)")
            }
            let widths = imageWidth.joined(separator: ":")
            let heights = imageHeight.joined(separator: ":")
            Networking.sharedInstance.upLoadImageRequest(urlString: WEHAVE_BASIC_LOCAL_APIs + "upload/guia/image", params: ["user_token":Profile.default.token,"width":widths,"height":heights], data: imageData, name: imageName, success: { (response) in
                if let imagesPath = response["imagePaths"]as? [String],let width = response["width"] as? [String],let height = response["height"] as? [String]{
                    for (index,path) in imagesPath.enumerated(){
                        let model = PictureModel()
                        model.imageurl = WEHAVE_BASIC_LOCAL_APIs_Images + path
                        model.width = UInt(Double(width[index]) ?? Double(kScreenWidth))
                        model.height = UInt(Double(height[index]) ?? 200)
                        pathsArray.append(model)
                    }
                    
                    if let json = completion(pathsArray){
                        self.htmlString = json
                        self.uploadGuias()
                    }
                }
            }) { (error) in
                
            }
        }
    }
    
    private func uploadGuias(){
        LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation { [weak self](location, clp, error) in
            if let location = location{
                let url = WEHAVE_BASIC_LOCAL_APIs + "guia"
                let params:[String: Any] = ["html":self?.htmlString ?? "",
                                            "latitud":location.coordinate.latitude,
                                            "longitud":location.coordinate.longitude,
                                            "user_token":Profile.default.token]
                Networking.sharedInstance.postRequestSimple(urlString: url, params: params, success: { (response) in
                    if let code = response["code"] as? Int , code == 12000{
                        self?.getGuias()
                    }
                }) { (error) in
                    self?.showAlert(title: "Can't upload 😫😫")
                }
            }
        }
    }
    
    private func getGuias(){
        let url = WEHAVE_BASIC_LOCAL_APIs + "guia"
        Networking.sharedInstance.getRequest(urlString: url, success: { (response) in
            if let code = response["code"] as? Int , code == 12000,let body = response["guia"] as? [[String: Any]]{
                var models = [GuiaModel]()
                for guia in body{
                    let model = GuiaModel(dict: guia)
                    models.append(model)
                }
                self.guiasModel = models
            }
        }) { (error) in
            print(error)
            self.showAlert(title: "Error Server 😢😢")
        }
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

extension WHIdeaController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guiasModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: guiaCellIdentifier) as! WHGuiaTableCell
        if let model = guiasModel?[indexPath.row]{
            cell.setup(guia: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = guiasModel?[indexPath.row]{
            let showGuiaVC = WHShowGuiaViewController()
            let navi = WHNavigationController(rootViewController: showGuiaVC)
            self.present(navi, animated: true) {
                showGuiaVC.setWebView(guia: model)
            }
        }
    }
    
    
}
