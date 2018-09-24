//
//  JS_PageView.swift
//  pageView


import UIKit

@objc protocol JS_PageViewDelegate: class ,NSObjectProtocol {
    @objc optional func pageViewScrollProgress(contentView: JS_ContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat)
}

class JS_PageView: UIView {
    // MARK: - 属性
    var titles : [String]
    var style : JS_PageStyle
    var childController : [UIViewController]
    var parentController : UIViewController
    var titleView: JS_TitleView!
    var contentView: JS_ContentView!
    weak var delegate: JS_PageViewDelegate?
    
    
    private lazy var pageTitle: UILabel = {
       let label = UILabel()
        label.text = "Hay algo que quieres".localized
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private lazy var pageTileLine: UIView = {
       let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    // MARK: - 构造函数
    init(frame: CGRect,titles:[String],style:JS_PageStyle,childController:[UIViewController],parentController:UIViewController) {
        self.titles = titles
        self.style = style
        self.childController = childController
        self.parentController = parentController
        super.init(frame: frame)
        //设置UI<需要在super 之后>
        setupUI()
    }
    
    func setdatas(titles:[String],style:JS_PageStyle,childController:[UIViewController],parentController:UIViewController){
        self.titles = titles
        self.style = style
        self.childController = childController
        self.parentController = parentController
        //设置UI<需要在super 之后>
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - 设置UI
extension JS_PageView{
    
    fileprivate func setupUI(){
        backgroundColor = .white
       
        
        
        //TitleView
        if let titleFrame = style.titleFrame,let contentFrame = style.contentFrame{
            titleView = JS_TitleView(frame: titleFrame, titles: titles, style: style)
            contentView = JS_ContentView(frame: contentFrame, childController: childController, parentController: parentController)
            
            // pageTitle
            pageTitle.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height:titleFrame.height)
            addSubview(pageTitle)
            
            pageTileLine.frame = CGRect(x: 0, y: titleFrame.height - 0.5, width: self.bounds.width, height: 0.5)
            addSubview(pageTileLine)
            
        }else{
            let titleFrame = CGRect(x: 0, y: 0, width:bounds.width, height: style.titleHeight)
            titleView = JS_TitleView(frame: titleFrame, titles: titles, style: style)
            
            //ContentView
            let contentFrame = CGRect(x: 0, y: titleFrame.maxY, width: bounds.width, height: bounds.height - style.titleHeight)
            contentView = JS_ContentView(frame: contentFrame, childController: childController, parentController: parentController)
        }
        titleView.backgroundColor = UIColor.white
        if style.isTitleAddSuperView {
            parentController.view.addSubview(titleView)
            addSubview(contentView)
        }else{
            addSubview(titleView)
            addSubview(contentView)
        }
        
        if style.isTitleHidden{
            titleView.alpha = 0.0
        }
        //交互
        titleView.delegate = self
        contentView.delegate = self
    }
}

// MARK: - JS_ContentViewDelegate
extension JS_PageView:JS_ContentDelegate{
    func contentView(contentView: JS_ContentView, didEndScroll index: Int) {
        titleView.titleViewToTarget(didEndScroll: index)
    }
    
    func contentView(contentView: JS_ContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        if delegate?.responds(to: #selector(delegate?.pageViewScrollProgress(contentView:sourceIndex:targetIndex:progress:))) == true {
            delegate?.pageViewScrollProgress!(contentView: contentView, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
        }
        if  style.titleHeight == 0{
            return
        }
        titleView.titltView( sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
}

// MARK: - JS_TitleViewDelegate
extension JS_PageView:JS_TitleViewDelegate{
    func titleView(titleView: JS_TitleView, targetIndex: Int) {
        contentView.contentViewToTargetView(titleView: titleView, targetIndex: targetIndex)
    }
    
}





