//
//  WHReservaMiddleDetailView.swift
//  Wehave
//
//  Created by JS_Coder on 2018/5/3.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import TextFieldEffects
import SnapKit
protocol WHReservaMiddleDetailViewDelegate:NSObjectProtocol {
    func reservaMiddleDetailDidPopBoardKey(offsetY: CGFloat,duration: Double,isShowKeyBord: Bool, textField: UITextField?)
}

class WHReservaMiddleDetailView: UIView,LoadNibView {
    
    
    var delegate: WHReservaMiddleDetailViewDelegate?
    fileprivate var currentTextField: UITextField?
    @IBOutlet weak var habitacionView: UIView!
    @IBOutlet weak var contactoView: UIView!
    
    lazy var apellidoTextField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.placeholder = "First Name"
        textField.borderInactiveColor = UIColor.darkGray
        textField.placeholderColor = UIColor.darkGray
        textField.borderActiveColor = ThemeColor
        textField.tag = 101
        self.habitacionView.addSubview(textField)
        return textField
    }()
    lazy var nombreTextField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.placeholder = "Name"
        textField.borderInactiveColor = UIColor.darkGray
        textField.placeholderColor = UIColor.darkGray
        textField.borderActiveColor = ThemeColor
        textField.tag = 102
        self.habitacionView.addSubview(textField)
        return textField
    }()
    lazy var contactNombreTextField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.placeholder = "Name"
        textField.borderInactiveColor = UIColor.darkGray
        textField.placeholderColor = UIColor.darkGray
        textField.borderActiveColor = ThemeColor
        textField.tag = 103
        self.contactoView.addSubview(textField)
        return textField
    }()
    lazy var contactPhoneTextField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.placeholder = "Phone"
        textField.borderInactiveColor = UIColor.darkGray
        textField.placeholderColor = UIColor.darkGray
        textField.borderActiveColor = ThemeColor
        textField.keyboardType = UIKeyboardType.phonePad
        textField.tag = 104
        self.contactoView.addSubview(textField)
        return textField
    }()
    lazy var contactEmailTextField: HoshiTextField = {
        let textField = HoshiTextField()
        textField.placeholder = "Email"
        textField.borderInactiveColor = UIColor.darkGray
        textField.placeholderColor = UIColor.darkGray
        textField.borderActiveColor = ThemeColor
        textField.tag = 105
        self.contactoView.addSubview(textField)
        return textField
    }()
    @IBOutlet weak var timeCheckTextField: UITextField!
    @IBOutlet weak var habitacionConstrants: UITextField!
    
    
    
    
//    class func initViewWithNib()->WHReservaMiddleDetailView{
//        let nib = UINib(nibName: "WHReservaMiddleDetailView", bundle: nil)
//        let topView = nib.instantiate(withOwner: nil, options: nil)[0] as! WHReservaMiddleDetailView
//        return topView
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        apellidoTextField.delegate = self
        nombreTextField.delegate = self
        contactNombreTextField.delegate = self
        contactPhoneTextField.delegate = self
        contactEmailTextField.delegate = self
        timeCheckTextField.delegate = self
        
        setupUI()
        
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenKeyBoard(tap:)))
        self.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func removeFromSuperview() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func setupUI(){
        apellidoTextField.snp.makeConstraints { (make) in
            make.top.equalTo(habitacionConstrants.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5).offset(-1)
            make.height.equalTo(49)
        }
        
        nombreTextField.snp.makeConstraints { (make) in
            make.top.equalTo(apellidoTextField.snp.top)
            make.trailing.equalToSuperview()
            make.width.equalTo(apellidoTextField.snp.width).offset(-1)
            make.height.equalTo(49)
        }
        
        contactNombreTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(49)
        }
        
        contactPhoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(contactNombreTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(49)
        }
        
        contactEmailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(contactPhoneTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(49)
        }
    }
    
    @IBAction func selectedEspecialBtn(_ sender: UIButton) {
        
    }
    
    
}


// MARK: - Regex
extension WHReservaMiddleDetailView{
    private func predicateWith(text: String , regex: String) -> Bool{
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: text)
        return isValid
    }
}


// MARK: - Observer Keyboard
private extension WHReservaMiddleDetailView{
    @objc func keyBoardWillShow(_ notification: Notification){
        //userInfo
        let kbInfo = notification.userInfo
        //size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //contentOffset
        let changeY = kbRect.origin.y
        //duration
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        delegate?.reservaMiddleDetailDidPopBoardKey(offsetY: changeY, duration: duration, isShowKeyBord: true, textField: currentTextField)
        
    }
    
    @objc func keyBoardWillHide(_ notification: Notification){
        
        let kbInfo = notification.userInfo
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let changeY = kbRect.origin.y
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        delegate?.reservaMiddleDetailDidPopBoardKey(offsetY: changeY, duration: duration, isShowKeyBord: false, textField: nil)
    }
    
    @objc func hiddenKeyBoard(tap: UITapGestureRecognizer){
        
    }
    
}
extension WHReservaMiddleDetailView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        DigitalKeyboard.default.resignFirstResponder()
        return true
    }
}
