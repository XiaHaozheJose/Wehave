//
//  WHNearbyViewController.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/18.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

// MARK: - Protocol
@objc protocol WHNearbyTableViewDelegate: NSObjectProtocol {
    @objc optional func tableViewDidScroll(scrollY: CGFloat,nearbyTab: WHMuiltipleGestureTableView)
}


final class WHNearbyViewController: UITableViewController {

    
    var products:[WHProductModel]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    /// Attributes
    weak var nearbyDelegate: WHNearbyTableViewDelegate?
   
    fileprivate lazy var multiTableView: WHMuiltipleGestureTableView = {
        let multiTableView = WHMuiltipleGestureTableView(frame: self.tableView.bounds)
        return multiTableView
    }()
    
    fileprivate let nearTabCell = "NEAR_TAB_CELL"
    
    
    
    /// viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = multiTableView
        self.tableView.bounces = false
        tableView.register(UINib.init(nibName: "WHBaseDetailCell", bundle: nil), forCellReuseIdentifier: nearTabCell)
    }
    
}


// MARK: - Tableview Data Source
extension WHNearbyViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nearTabCell, for: indexPath) as! WHBaseDetailCell
        if let product = products?[indexPath.row] {
            cell.setup(product: product)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kHomeCellHeight
    }
    
}

// MARK: - Tableview Delegate
extension WHNearbyViewController{
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.nearbyDelegate?.responds(to: #selector(nearbyDelegate?.tableViewDidScroll(scrollY:nearbyTab:))) == true{
            nearbyDelegate?.tableViewDidScroll!(scrollY: scrollView.contentOffset.y, nearbyTab: self.tableView as! WHMuiltipleGestureTableView)
        }
    }
}
