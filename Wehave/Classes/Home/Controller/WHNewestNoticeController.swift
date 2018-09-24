//
//  WHNewestNoticeController.swift
//  Wehave
//
//  Created by 浩哲 夏 on 2018/2/18.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit

@objc protocol WHNewestTableViewDelegate: NSObjectProtocol {
    @objc optional func tableViewDidScroll(scrollY: CGFloat,newTable: WHMuiltipleGestureTableView)
}

class WHNewestNoticeController: UITableViewController {
    
    var products:[WHProductModel]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    weak var newestDelegate: WHNewestTableViewDelegate?
    fileprivate lazy var multiTableView: WHMuiltipleGestureTableView = {
        let multiTableView = WHMuiltipleGestureTableView(frame: self.tableView.bounds)
        return multiTableView
    }()
    
    fileprivate let newTabCell = "NEW_TAB_CELL"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = multiTableView
        tableView.bounces = false
        tableView.estimatedRowHeight = 300
        tableView.register(UINib.init(nibName: "WHBaseDetailCell", bundle: nil), forCellReuseIdentifier: newTabCell)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kHomeCellHeight
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: newTabCell, for: indexPath) as! WHBaseDetailCell
        if let product = products?[indexPath.row] {
            cell.setup(product: product)
        }
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.newestDelegate?.responds(to: #selector(newestDelegate?.tableViewDidScroll(scrollY:newTable:))) == true{
            newestDelegate?.tableViewDidScroll!(scrollY: scrollView.contentOffset.y, newTable: self.tableView as! WHMuiltipleGestureTableView)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let product = products?[indexPath.row]{
            let showVc = WHShowProductViewController()
            let nav = WHNavigationController(rootViewController: showVc)
            self.present(nav, animated: true) {
                showVc.setProductContent(product: product)
            }
        }
    }
  
}
