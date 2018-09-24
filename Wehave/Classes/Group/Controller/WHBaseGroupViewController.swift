
//
//  WHBaseGroupViewController.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/16.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
class WHBaseGroupViewController: UIViewController {

   private enum MENU_ITEM: Int {
        case ADD_FRIEND
        case SCAN_QR
        case MI_QR
    }
    
    var friends: [Friend]?
    private let cellId = "friendCellId"
    
    lazy var fetchedResultsManager: NSFetchedResultsController = { () -> NSFetchedResultsController<Friend> in
        let fetchRequest = NSFetchRequest<Friend>(entityName: "Friend")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessage.date", ascending: false)]
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    lazy var friendCollection: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kScreenWidth, height: 100.0)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = kCommonMargin
        flowLayout.minimumInteritemSpacing = kCommonMargin
        
        let frame = CGRect(x: 0, y: kNavigationBarHeight, width: kScreenWidth, height: kScreenHeight - (kNavigationBarHeight + kTabBarHeight))
        let collection: UICollectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collection.register(WHFriendCell.self, forCellWithReuseIdentifier: cellId)
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    
    lazy var flowLayout: WHChatLogFlowLayout = {
        let layout = WHChatLogFlowLayout()
        layout.estimatedItemSize = CGSize(width: kScreenWidth, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = kCommonMargin * 2
        return layout
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let _ = fetchedResultsManager.fetchedObjects else {
            return
        }
        do {try fetchedResultsManager.performFetch() } catch {}
        friendCollection.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupMessageData()
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}


// MARK: - Setup
extension WHBaseGroupViewController{
    private func setup(){
        setNaviBarItem()
        setChildView()
    }
    
    private func setNaviBarItem(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "category").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(showGroupMenu))
    }
    
    private func setChildView(){
        view.addSubview(friendCollection)
    }
}


// MARK: - Setup CoreData
extension WHBaseGroupViewController: NSFetchedResultsControllerDelegate{
    //
    private func setupMessageData(){
        clearData()
        if let delegate = UIApplication.shared.delegate as? AppDelegate{
            let context = delegate.managedObjectContext
            let jose = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            jose.name = "JS_Coder"
            jose.profileIcon = "placeholder_icon_image"
            createMessageWithText(text: "Hi, I'm Jose,how are you.", friend: jose, minutesAgo: 0, context: context)
            createMessageWithText(text: "Hello, I'm fine!!!.", friend: jose, minutesAgo: 0, context: context,isSender: true)
            let eva = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            eva.name = "Eva"
            eva.profileIcon = "profileIcon"
            do {
                try context.save()
            }catch let err{
                print(err)
            }
        }
        do { try fetchedResultsManager.performFetch() }catch let err{ print(err) }
    }
    
   
    
    // Clear Data
    private func clearData(){
        if let delegate = UIApplication.shared.delegate as? AppDelegate{
            let entityNames = ["Friend", "Message"]
            
            let context = delegate.managedObjectContext
            do{
            for entityName in entityNames{
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
                    let objects = try context.fetch(fetchRequest)
                    for object in objects {
                        context.delete(object)
                    }
                }
                try context.save()
            }catch let err{
                print(err)
            }
        }
    }
    
    // fetch Friend
    private func fetchFriends()->[Friend]?{
        if let delegate = UIApplication.shared.delegate as? AppDelegate{
            let context = delegate.managedObjectContext
            let fetchRequest = NSFetchRequest<Friend>(entityName: "Friend")
            do{
                return try context.fetch(fetchRequest)
            }catch let err{
                print(err)
            }
    }
        return nil
}
    
    // Create Message
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext,isSender: Bool = false){
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friends = friend
        message.text = text
        message.date = Date(timeIntervalSinceNow: -(minutesAgo * 60))
        message.isSender = NSNumber(value: isSender)
        friend.lastMessage = message
    }
    
}


// MARK: - Selector Action
extension WHBaseGroupViewController{
    @objc private func showGroupMenu(){
        //设置每一个弹出cell的大小跟坐标 - frmae
        let popViewCell_w = UIScreen.main.bounds.size.width/3.0
        let popViewCell_h:CGFloat = 35.0
        let popViewCell_x = UIScreen.main.bounds.size.width*2/3.0 - 8.0
        let popViewCell_y:CGFloat = kNavigationBarHeight + 8.0
        
        var popViewCell_rect = CGRect.init()
        popViewCell_rect.origin.x = popViewCell_x
        popViewCell_rect.origin.y = popViewCell_y
        popViewCell_rect.size.width = popViewCell_w
        popViewCell_rect.size.height = popViewCell_h
        
        //图片数组名
        let imageNameArr = ["addFriend","scanQR","codeQR"]
        //label显示标题名
        let titleArr = ["Add Friend","Scan","Code QR"]
        
        let popView = JS_PopMenuView.init(frame: popViewCell_rect, imageNameArr: imageNameArr, titleArr: titleArr)
        popView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension WHBaseGroupViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WHFriendCell
       let friend = fetchedResultsManager.object(at: indexPath)
        cell.friend = friend
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsManager.sections?[section].numberOfObjects {
            return count
            }
        return 0
    }
}

// MARK: -UICollectionViewDelegate
extension WHBaseGroupViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let chatLogController = WHChatLogController(collectionViewLayout: flowLayout)
        let friend = fetchedResultsManager.object(at: indexPath)
        chatLogController.friend = friend
        chatLogController.view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavigationBarHeight - kTabBarHeight)
        chatLogController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatLogController, animated: true)
    }
}


// MARK: - MenuViewDelegate
extension WHBaseGroupViewController: JSPopMenuItemClickDelegate{
    func popMenuItemClick(tag: Int) {
        switch tag {
        case MENU_ITEM.ADD_FRIEND.rawValue:
            print("addFriend")
        case MENU_ITEM.SCAN_QR.rawValue:
            print("scan")
            
            let scanVC = WHNavigationController(rootViewController: WHQRViewController())
            self.present(scanVC, animated: true, completion: nil)
            
            
            
        case MENU_ITEM.MI_QR.rawValue:
            let qrVc = CreatQR()
            let createQR = WHNavigationController(rootViewController: qrVc)
            self.present(createQR, animated: true) {
                qrVc.createQR(qrContent: Profile.default.token, qrImage: Profile.default.imageUrl)
            }
            
        default: break
        }}
}




