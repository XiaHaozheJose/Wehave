//
//  WHLoginViewController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/5/10.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

class WHLoginViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginAnimationView: WHLoginAnimationView!
    @IBOutlet weak var olvidaPasswordBtn: UIButton!
    @IBOutlet weak var RegisterImageBtn: UIImageView!
    fileprivate var resignTextField: UITextField?
    private let USER_NAME_KEY = "userName"
    private let PASSWORD_KEY = "password"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome To Wehave"
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.RegisterImageBtn.transform = .identity
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignTextField?.resignFirstResponder()
    }
}


// MARK: - setup
extension WHLoginViewController{
    private func setup(){
        accountTextField.delegate = self
        pwTextField.delegate = self
        
        accountTextField.placeholder = "Telefono / Email".localized
        pwTextField.placeholder  = "Contraseña".localized
        olvidaPasswordBtn.setTitle( "Olvido Contraseña".localized, for: .normal)
        loginBtn.setTitle("Iniciar Sesión".localized, for: .normal)
        
        // add tapGesture to registerImage
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickToRegister))
        RegisterImageBtn.addGestureRecognizer(tap)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancelar".localized, style: .done, target: self, action: #selector(clickToBack))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        
        accountTextField.addTarget(self, action: #selector(accountValidate), for: .editingChanged)
        pwTextField.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
    }
}


// MARK: - Selector || Target
extension WHLoginViewController: UITextFieldDelegate{

    @objc private func clickToRegister(){
        UIView.animate(withDuration: 0.25, animations: {
            self.RegisterImageBtn.transform = CGAffineTransform(translationX: kScreenWidth, y: 0)
        }) {[weak self] (_) in
            let register = WHRegisterViewController()
            register.isFinishedRegister = {(isFinish: Bool) in
                if isFinish{
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            self?.navigationController?.pushViewController(register, animated: true)
        }
    }
    
    @objc private func clickToBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func clickToLogin(_ sender: UIButton) {
        validateAccount(params: [USER_NAME_KEY : accountTextField.text!,
            PASSWORD_KEY : pwTextField.text!] as [String : AnyObject])
        }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == pwTextField {
            loginAnimationView.doAnimation(isStart: true)
        }
        resignTextField = textField
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        loginAnimationView.doAnimation(isStart: false)
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    
    @objc func accountValidate(){
        if (Validate.phoneNum(accountTextField.text ?? "").isRight || Validate.email(accountTextField.text ?? "").isRight) && pwTextField.text?.count != 0{
            loginBtn.backgroundColor = ThemeColor
            loginBtn.isEnabled = true
        }else{
            loginBtn.backgroundColor = UIColor(hexString: "#DBDBDB")
            loginBtn.isEnabled = false
        }
    }
    
    
    @objc func passwordValidate(){
        if (Validate.phoneNum(accountTextField.text ?? "").isRight || Validate.email(accountTextField.text ?? "").isRight) && (pwTextField.text?.count)! > 0{
            loginBtn.backgroundColor = ThemeColor
            loginBtn.isEnabled = true
        }else{
            loginBtn.backgroundColor = UIColor(hexString: "#DBDBDB")
            loginBtn.isEnabled = false
        }
    }
}

// MARK: - HTTP CLIENT
extension WHLoginViewController{
    private func validateAccount(params: [String: AnyObject]){
        Networking.sharedInstance.postRequest(urlString: WEHAVE_BASIC_LOCAL_APIs + "login", params: params, data: nil, name: nil, success: { (response: [String : AnyObject]) in
            if let code = response["code"] as? Int{
                if code == 12000 , let body = response["body"] as? [String: AnyObject]{
                    Profile.default.keyValueForDict(dicts: body)
                    if Profile.default.saveAccountData(){
                        print("is saved")
                        UserDefaults.standard.set(true, forKey: "autoLogin")
                    }
                    self.dismiss(animated: true, completion: nil)
                }else{
                    if let error = response["status"] as? String{
                        self.showAlert(title: error)
                    }
                }
            }
        }) { (error: Error) in
            self.showAlert(title: "Error Server")
            UserDefaults.standard.set(false, forKey: "autoLogin")
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
