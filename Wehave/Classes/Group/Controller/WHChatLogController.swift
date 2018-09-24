//
//  WHChatLogController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/6/19.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import CoreData
import SnapKit
private let chatLogCell = "ChatLogCell"

class WHChatLogController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var friend: Friend?{
        didSet{
            navigationItem.title = friend?.name
//            messages = friend?.messages?.allObjects as? [Message]
//            messages?.sort(by: ({$0.date!.compare($1.date!) == .orderedAscending}))
        }
    }
    
//    private var messages: [Message]?

    private var isShowKeyboard: Bool = false

    lazy var fetchedResultsManager: NSFetchedResultsController = { () -> NSFetchedResultsController<Message> in
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friends.name = %@", friend!.name!)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    lazy var messageInputContainerView: UIView = {
        let messageInputView = UIView()
        messageInputView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return messageInputView
    }()
    
    lazy var messageInputTextField: UITextField = {
        let inputTF = UITextField()
        inputTF.backgroundColor = .white
        inputTF.layer.cornerRadius = 5
        inputTF.layer.masksToBounds = true
        return inputTF
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(ThemeColor, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    lazy var hubView: UIView = {
        let hub = UIView()
        hub.backgroundColor = UIColor(white: 1, alpha: 0.01)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hubViewTapGestureToregisnFirstResponder))
        hub.addGestureRecognizer(tap)
        return hub
    }()
    
    private var bottomConstraint:NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        do {
            try fetchedResultsManager.performFetch()
        }catch let err{
            print(err)
        }
        
        collectionView?.backgroundColor = .white
        collectionView?.register(WHChatLogCell.self, forCellWithReuseIdentifier: chatLogCell)
        
        // observer keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        view.layoutIfNeeded()
        
        if let contentHeight = collectionView?.contentSize.height, contentHeight >= kScreenHeight - kTabBarHeight - kCommonMargin {
            let layout = collectionView?.collectionViewLayout as! WHChatLogFlowLayout
            layout.offset = contentHeight + kTabBarHeight + kCommonMargin - kScreenHeight
        }
    }
    
    
    deinit {// remove observer
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setup(){
        collectionView?.contentInset = UIEdgeInsetsMake(kCommonMargin, 0, kTabBarHeight + kCommonMargin, 0)
        view.autoresizingMask = .flexibleHeight
        view.addSubview(messageInputContainerView)
        messageInputContainerView.addSubview(messageInputTextField)
        messageInputContainerView.addSubview(sendButton)
        view.addSubview(hubView)
        messageInputContainerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(kTabBarHeight)
        }
        messageInputTextField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(kCommonMargin)
            make.height.equalTo(35)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(sendButton.snp.leading).offset(-kCommonMargin)
        }
        sendButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-kCommonMargin)
            make.width.equalTo(60)
        }
        
       bottomConstraint =  NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
    }
    
    @objc private func handleKeyboardNotification(notification: Notification){
        if let userInfo = notification.userInfo{
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            {
               isShowKeyboard = notification.name == Notification.Name.UIKeyboardWillShow
                if isShowKeyboard{
                    hubView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - keyboardFrame.height - kTabBarHeight)
                    view.addSubview(hubView)
                    
                    messageInputContainerView.snp.updateConstraints { (update) in
                        update.bottom.equalTo(-keyboardFrame.height)
                    }}else{
                    hubView.removeFromSuperview()
                    messageInputContainerView.snp.updateConstraints { (update) in
                        update.bottom.equalToSuperview()
                    }}
                UIView.animate(withDuration: duration, animations: {
                    self.view.layoutIfNeeded()
                }){(_) in // completed
                    if self.isShowKeyboard,(self.fetchedResultsManager.sections?[0].numberOfObjects ?? 0) > 0{
                        let indexPath = IndexPath(row: (self.fetchedResultsManager.sections?[0].numberOfObjects ?? 1)-1, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
                    }
                }
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    
    @objc private func sendMessage(){
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate,let text = messageInputTextField.text{
            let context = delegate.managedObjectContext
            let _ = createMessageWithText(text: text, friend: friend!, minutesAgo: 0, context: context, isSender: true)
            do {
                messageInputTextField.text = nil
                try context.save()
                simulateResponseMessage()
            }catch let err{
               print(err)
            }
        }
    }
    
    private func simulateResponseMessage(){
        if let delegate = UIApplication.shared.delegate as? AppDelegate{
            let context = delegate.managedObjectContext
            let _ = createMessageWithText(text: "Here's a test message", friend: friend!, minutesAgo: 0, context: context)
            do {
                try context.save()
            }catch let err{
                print(err)
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return fetchedResultsManager.sections?[0].numberOfObjects ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatLogCell, for: indexPath) as! WHChatLogCell
        cell.message = fetchedResultsManager.object(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = fetchedResultsManager.object(at: indexPath)
        if let text = message.text {
            let estimatedSize = text.getSizeWithTextWith(textFont: 18, maxSize: CGSize(width: kScreenWidth * 2 / 3, height: CGFloat(MAXFLOAT)))
            return CGSize(width: kScreenWidth, height: estimatedSize.height + kCommonMargin * 2)
        }
        return CGSize(width: kScreenWidth, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
   
}

extension WHChatLogController:NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert , let indexPath = newIndexPath {
            collectionView?.insertItems(at: [indexPath])
            collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
        
        
    }
}

// MARK: - Action Selector
extension WHChatLogController{
    @objc private func hubViewTapGestureToregisnFirstResponder(){
        messageInputTextField.resignFirstResponder()
    }
}


// MARK: - Gestion CoreData
extension WHChatLogController{
    // Create Message
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext,isSender: Bool = false) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friends = friend
        message.text = text
        message.date = Date(timeIntervalSinceNow: -(minutesAgo * 60))
        message.isSender = NSNumber(value: isSender)
        friend.lastMessage = message
        return message
    }
    
    private func getContentSize()->CGSize{
        var width: CGFloat = 0
        var height: CGFloat = 0
        for message in fetchedResultsManager.sections?[0].objects as! [Message]{
           let size =  message.text?.getSizeWithTextWith(textFont: 18, maxSize: CGSize(width: kScreenWidth * 2 / 3, height: CGFloat(MAXFLOAT)))
            width += size?.width ?? 0
            height += (size?.height ?? 0) + (kCommonMargin * 4)
        }
        return CGSize(width: width, height: height)
    }
    
}
