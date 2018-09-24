//
//  String-Extension.swift
//  Wehave
//
//  Created by JS_Coder on 2018/5/30.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import Foundation
extension String{
    
    func cacheDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        return (path?.appending("/\(self)"))!
    }
    
    func documentDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        return (path?.appending("/\(self)"))!
    }
    
    func TmpDir() -> String {
        let path = NSTemporaryDirectory()
        return (path.appending("/\(self)"))
    }
    
    func getSizeWithTextWith(textFont:CGFloat, maxSize: CGSize) -> CGSize{
        let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        let estimatedFrame = self.boundingRect(with: maxSize, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)], context: nil)
        return estimatedFrame.size
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
    
    func localized(tableName: String) -> String{
        return NSLocalizedString(self, tableName: tableName, bundle: Bundle.main, value: "", comment: "")
    }
    
    
}

extension Data {
    var hexString: String {
        get {
            return self.map { String(format: "%02.2hhx", $0) }.joined()
        }
    }
}

