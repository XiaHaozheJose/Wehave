//
//  WHRegisterViewController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/5/10.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import CoreLocation
class WHRegisterViewController: UIViewController {
    enum USERS_KEY: String {
        case USER_NAME = "userName"
        case PASSWORD = "password"
        case PHONE = "phone"
        case LOCATION = "location"
    }
    
    // codigo del pais
    lazy var codeCountry: UILabel = {
        let code = UILabel()
        code.text = "ES +34"
        code.textColor = ThemeColor
        code.textAlignment = .center
        return code
    }()
    
    // telefono textfield
    lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Escribe teléfono".localized
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.keyboardType = .phonePad
        textField.delegate = self
        textField.addTarget(self, action: #selector(phoneTextFieldChanged), for: UIControlEvents.editingChanged)
        return textField
    }()
    
    //codigo Mensage
    lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Código".localized
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.textAlignment = .center
        return textField
    }()
    
    //button recibir mensage
    lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Recibir".localized, for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.addTarget(self, action: #selector(receiveSMS), for: UIControlEvents.touchUpInside)
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    // usuario Label
    lazy var userNameLabel: UILabel = {
        let userName = UILabel()
        userName.text = "UserName"
        return userName
    }()
    // usuario textField
    lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nombre".localized
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.delegate = self
        return textField
    }()
    // password Label
    lazy var passwordLabel: UILabel = {
        let userName = UILabel()
        userName.text = "Password"
        return userName
    }()
    // password textField
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Contrasena".localized
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()
    // show password
    lazy var eyeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "hidden_psw"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "show_psw"), for: .selected)
        button.addTarget(self, action: #selector(clickToShowPassword), for: .touchUpInside)
        return button
    }()
    // poliza label
    lazy var policyLabel: UILabel = {
        let policy = UILabel()
        policy.text = " * El registro se completa al aceptar Wehave política".localized
        policy.textColor = UIColor.lightGray
        policy.font = UIFont.systemFont(ofSize: 15)
        return policy
    }()
    // ok button
    lazy var finishRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(registerWithPhoneNumber), for: .touchUpInside)
        return button
    }()
    
    fileprivate var preTextField: UITextField?
    fileprivate var timer: Timer?
    fileprivate var count: Int = 60
    fileprivate var codeSMS = 0
    
    
    var isFinishedRegister:((_ isTrue: Bool)->())?

/*-------------------------------------------------------------------------------------------------*/
    
    // Life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Register Fast"
        setup()
        setLayout()
        setNavibarButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        preTextField?.resignFirstResponder()
    }
    
}

// MARK: - Setup UI
extension WHRegisterViewController{
    private func setup(){
        view.addSubview(codeCountry)
        view.addSubview(phoneTextField)
        view.addSubview(messageTextField)
        view.addSubview(messageButton)
        view.addSubview(userNameLabel)
        view.addSubview(userNameTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(eyeButton)
        view.addSubview(policyLabel)
        view.addSubview(finishRegisterButton)
    }
    
    private func setLayout(){
        codeCountry.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(64)
            make.top.equalToSuperview().offset(64)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        phoneTextField.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(codeCountry.snp.top)
            make.leading.equalTo(codeCountry.snp.trailing).offset(5)
            make.height.equalTo(codeCountry.snp.height)
        }
        
        
        messageTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(codeCountry.snp.leading).offset(5)
            make.top.equalTo(codeCountry.snp.bottom)
            make.height.equalTo(64)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        messageButton.snp.makeConstraints { (make) in
            make.top.equalTo(messageTextField.snp.top).offset(10)
            make.trailing.equalTo(phoneTextField.snp.trailing)
            make.height.equalTo(40)
            make.leading.equalTo(messageTextField.snp.trailing)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(messageTextField.snp.bottom)
            make.leading.equalTo(messageTextField.snp.leading)
            make.height.equalTo(64)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        userNameTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(userNameLabel.snp.trailing).offset(5)
            make.trailing.equalTo(messageButton.snp.trailing)
            make.top.equalTo(messageTextField.snp.bottom)
            make.height.equalTo(64)
        }
        passwordLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp.bottom)
            make.leading.equalTo(userNameLabel.snp.leading)
            make.height.equalTo(64)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        eyeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(passwordLabel.snp.centerY)
            make.trailing.equalTo(userNameTextField.snp.trailing).offset(-5)
            make.height.equalTo(32)
            make.width.equalTo(32)
        }
        passwordTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(passwordLabel.snp.trailing).offset(5)
            make.trailing.equalTo(eyeButton.snp.leading)
            make.height.equalTo(64)
            make.top.equalTo(passwordLabel.snp.top)
        }
        
        policyLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(passwordLabel.snp.leading)
            make.top.equalTo(passwordLabel.snp.bottom)
            make.trailing.equalTo(eyeButton.snp.trailing)
            make.height.equalTo(64)
        }
        
        finishRegisterButton.snp.makeConstraints { (make) in
            make.top.equalTo(policyLabel.snp.bottom).offset(10)
            make.leading.equalTo(policyLabel.snp.leading)
            make.trailing.equalTo(policyLabel.snp.trailing)
            make.height.equalTo(49)
        }
        
        addBottomLine(topView: phoneTextField)
        addBottomLine(topView: messageTextField)
        addBottomLine(topView: userNameTextField)
        addBottomLine(topView: passwordTextField)
        addRightLine(leftView: codeCountry)
    }
    
    
    private func setNavibarButton(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_login").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(backToLogin))
    }
    
    private func addBottomLine(topView: UIView){
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(topView.snp.bottom)
        }
    }
    
    private func addRightLine(leftView: UIView){
        let line = UIView()
        line.backgroundColor = .lightGray
        view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(leftView).multipliedBy(0.5)
            make.leading.equalTo(leftView.snp.trailing).offset(-1)
            make.centerY.equalTo(leftView.snp.centerY)
        }
    }
}


// MARK: - Selector | Target
extension WHRegisterViewController{
    @objc private func clickToShowPassword(){
        eyeButton.isSelected = !eyeButton.isSelected
        passwordTextField.isSecureTextEntry = !eyeButton.isSelected
    }
    @objc private func backToLogin(){
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension WHRegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        preTextField = textField
    }
    
    // phoneTextField ValueChanged
    @objc private func phoneTextFieldChanged(){
        guard let phone = phoneTextField.text else {
            return
        }
        if Validate.phoneNum(phone).isRight{
            messageButton.isEnabled = true
            messageButton.backgroundColor = ThemeColor
        }else{
            messageButton.isEnabled = false
            messageButton.backgroundColor = .lightGray
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let code = messageTextField.text, code.count == 4,  let name = userNameTextField.text?.count, name > 0, let password = passwordTextField.text?.count, password >= 6{
            finishRegisterButton.isEnabled = true
            finishRegisterButton.backgroundColor = ThemeColor
        }else{
            finishRegisterButton.isEnabled = false
            finishRegisterButton.backgroundColor = UIColor.lightGray
        }
        return true
    }
    
    // APIs SMS
    @objc private func receiveSMS(){
        Networking.sharedInstance.postRequestSimple(urlString: WEHAVE_BASIC_LOCAL_APIs+"sms", params: ["phone":phoneTextField.text!], success: { (response) in
            print(response)
            if let code = response["code"] as? Int{
                if let status = response["status"] as? Int, status == -10010 {
                    self.showAlert(title: "Número registrado".localized)
                }else{
                self.setTimerCount()
                self.showAlert(title: "Codigo Enviado".localized)
                self.codeSMS = code
                }
            }
        }) { (error) in
            self.showAlert(title: "Coneccion Error")
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
    
    @objc private func registerWithPhoneNumber(){
        if messageTextField.text! != "\(codeSMS)" {
            showAlert(title: "Error Codigo")
            return
        }
        LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation { (location, clpmark, error) in
            if let clp = clpmark,let direcName = clp.name,let postalCode = clp.postalCode{
                let direction = direcName + "," + postalCode + "," + (clp.locality ?? "")
                let params = [USERS_KEY.PHONE.rawValue : self.phoneTextField.text!,
                              USERS_KEY.USER_NAME.rawValue: self.userNameTextField.text!,
                              USERS_KEY.LOCATION.rawValue: direction,
                              USERS_KEY.PASSWORD.rawValue: self.passwordTextField.text!]
                Networking.sharedInstance.postRequestSimple(urlString: WEHAVE_BASIC_LOCAL_APIs+"register", params: params, success: { (response) in
                    if let token = response["user_Token"] as? String{
                        Networking.sharedInstance.getRequest(urlString: WEHAVE_BASIC_LOCAL_APIs + "users?userToken=\(token)", success: { (response) in
                            Profile.default.keyValueForDict(dicts: response)
                            if Profile.default.saveAccountData(){
                                print("is saved")
                                UserDefaults.standard.set(true, forKey: "autoLogin")
                            }
                            self.isFinishedRegister?(true)
                        }, failture: { (error) in
                            self.showAlert(title: "Error Account")
                            UserDefaults.standard.set(false, forKey: "autoLogin")
                        })
                    }
                }, failture: { (error) in
                    self.showAlert(title: "Error Server")
                    UserDefaults.standard.set(false, forKey: "autoLogin")
                })
            }
        }
    }
}

// MARK: - Logico
extension WHRegisterViewController{
    private func setTimerCount(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (currentTimer) in
            if self.count == 0{
                self.count = 60
                self.messageButton.setTitle("Recibir", for: .normal)
                self.messageButton.isEnabled = true
                currentTimer.invalidate()
                self.timer = nil
                return
            }
            self.count -= 1
            self.messageButton.setTitle("\(self.count)", for: .normal)
            self.messageButton.isEnabled = false
        })
        timer?.fire()
    }
}
