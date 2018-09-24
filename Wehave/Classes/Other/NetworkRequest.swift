//
//  NetworkRequest.swift
//  Wehave
//
//  Created by JS_Coder on 2018/3/12.
//  Copyright © 2018年 浩哲 夏. All rights reserved.
//

import Foundation
import Alamofire
private let shared = Networking()
class Networking{
    class var sharedInstance: Networking{
        return shared
    }
}
enum MethodType: String {
    case GET = "GET"
    case POST = "POST"
}

extension Networking{
    func postRequest(urlString : String, params:[String:AnyObject], data: [Data]?, name: [String]?, success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        
        request(urlString, method: .post, parameters: params).responseJSON(completionHandler: { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                }
            case .failure(let error):
                failture(error)
            }
        })
    }
    
    func upLoadImageRequest(urlString : String, params:[String:String], data: [Data], name: [String],success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()){
        
        let headers = ["content-type":"multipart/form-data"]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                //多张图片上传
                let fieldName = ".png"
                for (_,param) in params.enumerated(){
                  let key = param.key
                  let value = param.value
                    multipartFormData.append( (value.data(using: String.Encoding.utf8))!, withName: key)
                }
                
                for i in 0..<data.count {
                    multipartFormData.append(data[i], withName: fieldName, fileName: name[i], mimeType: "image/png")
                }
        },
            to: urlString,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: Any]{
                            success(value)
                        }
                    }
                case .failure(let encodingError):
                    failture(encodingError)
                }
        })
    }
    
    func getRequest(urlString: String, success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        request(urlString, method: .get)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    success(value as! [String : AnyObject])
                case .failure(let error):
                    failture(error)
                }
        }
    }
    
    
    func postRequestSimple(urlString: String, params: [String: Any], success : @escaping (_ response : [String:AnyObject])->(), failture : @escaping (_ error : Error)->()){
        request(urlString, method: .post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                success(value as! [String: AnyObject])
            case . failure(let error):
                failture(error)
            }
        }
}
}
