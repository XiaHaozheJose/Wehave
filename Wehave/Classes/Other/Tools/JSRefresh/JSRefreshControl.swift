//
//  JSRefreshControl.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/4.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import UIKit
// MARK: - Attribute

/// Refresh Status
///
/// - Normal: none
/// - Pulling: draging to refresh
/// - Refreshing: begin to refresh
enum JSRefreshState {
    case Normal
    case Pulling
    case Refreshing
}

private let JSRefreshOffset: CGFloat = 64
class JSRefreshControl: UIControl {
    
    
    
    // SuperView -> scrollView
    private weak var scrollview: UIScrollView?
    // RefreshView
    private lazy var refreshView: JSRefreshView = JSRefreshView.refreshView()
    
    // MARK: - Life
    init() {
        super.init(frame:CGRect())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // addSubview | removeFromSuperview
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let sv = newSuperview as? UIScrollView else { return }
        scrollview = sv
        
        scrollview?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    // removeFromSuperview -> removeObserve
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
    
    // KVO ObserveValue -> ContentOffset
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let sv = scrollview else { return }
        
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        if height < 0 { return }
        // Set Frame
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        // 临界点 ( 判断一次 )
        if sv.isDragging {
            if height > JSRefreshOffset && refreshView.refreshStatus == .Normal{
                refreshView.refreshStatus = .Pulling
                print("放手刷新")
            }else if height <= JSRefreshOffset && (refreshView.refreshStatus == .Pulling){
                refreshView.refreshStatus = .Normal
                print("继续拉")
            }
        }else{
            if refreshView.refreshStatus == .Pulling{
                print("开始刷新")
                beginRefreshing()
                // SendAction for Observer -> valueChanged
                sendActions(for: .valueChanged)
            }
        }
        
    }
}


extension JSRefreshControl{
    private func setupUI(){
        backgroundColor = superview?.backgroundColor
        
        //add RefreshView
        addSubview(refreshView)
        
        // Layout
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        setRefreshLayout()
    }
    
    // Start Refresh
    func beginRefreshing(){
        print("beginRefresing")
        guard let sv = scrollview else { return }
        if refreshView.refreshStatus == .Refreshing{ return }
        
        refreshView.refreshStatus = .Refreshing
        sv.contentInset.top += JSRefreshOffset
    }
    
    // End Refresh
    func endRefreshing(){
        print("endRefresing")
        
        guard let sv = scrollview else { return }
        if refreshView.refreshStatus != .Refreshing { return }
      
        refreshView.refreshStatus = .Normal
        sv.contentInset.top -= JSRefreshOffset
        
    }
    
    private func setRefreshLayout(){
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
    }
}





