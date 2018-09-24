//
//  WHHotelDescriptionController.swift
//  Wehave
//
//  Created by JS_Coder on 2018/4/5.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
import SnapKit

class WHHotelDescriptionController: UIViewController {
    fileprivate let cellIdentifier = "photoCell"
    fileprivate let roomCell = "roomCell"
    
    
    fileprivate var roomsList: [subRoomsModel]?{
        didSet{
            roomsTableView.reloadData()
        }
    }
    var hotelModel: HotelDataModel?{
        didSet{
            guard let link = hotelModel?._links?.more_rooms_at_this_hotel?.href else { return }
            networkingToHotel(link: link)
            nameLabel.text = hotelModel?.property_name
            contentLabel.text = hotelModel?.marketing_text
        }
    }
    
    fileprivate var currentHotel: HotelDataModel?
    
    // Show Photos
    lazy var photoCollection: UICollectionView = {
        let flowLayout = JS_FlowLayout()
        
        let itemWH = kScreenWidth / 2
        let margin = kScreenWidth - (kScreenWidth - kWheelHeight) * 0.5
        flowLayout.itemSize = CGSize(width: itemWH, height: itemWH)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 30
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 20, width: kScreenWidth, height: itemWH), collectionViewLayout: flowLayout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .white
        collection.register(UINib.init(nibName: "WHHotelPhotoCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    //Hotel Detail View
    lazy var titleView: UIView = {
        let title = UIView()
        return title
    }()
    
    // Hotel Name
    lazy var nameLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 20, weight: .black)
        name.textColor = .black
        name.textAlignment = .left
        name.numberOfLines = 0
        return name
    }()
    // Hotel Description
    lazy var contentLabel: UILabel = {
        let content = UILabel()
        content.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        content.textColor = .lightGray
        content.textAlignment = .justified
        content.numberOfLines = 0
        return content
    }()
    
    //backButton
    lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "back_black"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "back_white"), for: .highlighted)
        btn.setTitle("Back", for: .normal)
        btn.setTitleColor(ThemeColor, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(backToHotelLists), for: .touchUpInside)
        return btn
    }()
    
    // RoomsList
    lazy var roomsTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 110
        table.register(UINib(nibName: "WHRoomViewCell", bundle: nil), forCellReuseIdentifier: roomCell)
        return table
    }()
    
    
    // Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        setLayout()
        photoCollection.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        
    }
}


// MARK: - Setup UI
private extension WHHotelDescriptionController{
    func setup(){
        view.addSubview(photoCollection)
        view.addSubview(titleView)
        titleView.addSubview(nameLabel)
        titleView.addSubview(contentLabel)
        view.addSubview(backButton)
        view.addSubview(roomsTableView)
    }
    
    func setLayout(){
        let nameSize = nameLabel.sizeWithText(maxSize: CGSize(width: kScreenWidth, height: kScreenHeight))
        let contentSize = contentLabel.sizeWithText(maxSize: CGSize(width: kScreenWidth, height: kScreenHeight))
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(photoCollection.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(5)
            make.height.equalTo(nameSize.height + contentSize.height + kCommonMargin)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(kCommonMargin)
            make.trailing.equalToSuperview().offset(-kCommonMargin)
            make.height.equalTo(nameSize.height)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(nameLabel.snp.trailing)
            make.height.equalTo(contentSize.height)
        }
        backButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(kCommonMargin)
        }
        roomsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.width.equalToSuperview()
            print(titleView.frame.maxY)
            make.height.equalToSuperview().offset(-(nameSize.height + contentSize.height + kCommonMargin + photoCollection.frame.height))
            make.leading.equalToSuperview()
        }
        
        // add height to table
        print(roomsTableView.contentSize.height)
        
    }
    
}

// MARK: - UICollectionViewDataSource,UICollectionViewDelegate
extension WHHotelDescriptionController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! WHHotelPhotoCell
        cell.photoImageView.image = UIImage.init(named:"\(indexPath.row)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}

extension WHHotelDescriptionController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: roomCell, for: indexPath) as! WHRoomViewCell
        if let room = roomsList?[indexPath.row]{
            cell.room = room
        }
        cell.setBlockWithReserva { [weak self](subModel) in
            let vc = WHReservaRoomController()
            vc.roomModel = subModel
            vc.hotelName = self?.nameLabel.text ?? ""
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    
    /**
     * Delegate
     */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}


// MARK: - Target Action
private extension WHHotelDescriptionController{
    @objc func backToHotelLists(){
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - Networking
private extension WHHotelDescriptionController{
    func networkingToHotel(link:String){
        print(link)
        Networking.sharedInstance.getRequest(urlString: link, success: { (response) in
            self.currentHotel = HotelDataModel(dict: response)
            self.roomsList = self.currentHotel?.rooms
        }) { (error) in
            print(error)
        }
    }
}
