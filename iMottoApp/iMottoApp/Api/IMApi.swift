//
//  IMApi.swift
//  iMottoApp
//
//  Created by sunht on 16/5/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation
import Alamofire
import KeychainAccess


typealias GeneralCallback = (_ resp:RespBase)->Void

class IMApi{
    var alamo = Alamofire.SessionManager.default
    let reachability:Reachability?
    let apiUrl="\(API_SCHEME)\(API_DOMAIN)/api/"
    static let instance=IMApi()
    fileprivate init(){
        reachability = Reachability()!
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        self.alamo = Alamofire.SessionManager(configuration: configuration)
    }
    
    var isReachable:Bool{
        if reachability == nil{
            return false
        }else{
            return reachability!.isReachable
        }
    }
    
    // MARK: - Common api
    
    
    /// 设备注册 CMN1001
    func registeDevice(_ completion:@escaping (_ resp:RegisteDeviceResp)->Void){
        
        if !self.isReachable{
            let result : Dictionary<String, AnyObject> = [ "Code" : "" as AnyObject, "State" : -3 as AnyObject, "Msg" : "网络连接不可用" as AnyObject ]
            let resp = RegisteDeviceResp(data: result as NSDictionary)
            completion(resp)
            return
        }
        
        var uuid:String = ""
        if let tmp = PropHelper.instance.uuid{
            debugPrint("uuid in keychain is: \(tmp)")
            uuid = tmp
        }else{
            uuid = (UIDevice.current.identifierForVendor?.uuidString)!
            PropHelper.instance.uuid = uuid
        }
        
        let size = UIScreen.main.bounds.size
        let screen = "\(size.width),\(size.height)"
        let model = UIDevice.current.localizedModel
        let os = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
        let tVersion = Bundle.main.infoDictionary!["CFBundleVersion"]
        
        let info:Dictionary<String, Any> = ["Brand" : "Apple" as AnyObject,
                                                  "Model" : model as AnyObject,
                                                  "OS" : os as AnyObject,
                                                  "OSVersion" : osVersion as AnyObject,
                                                  "Screen" : screen as AnyObject,
                                                  "Resolution" : screen as AnyObject,
                                                  "Midu" : "" as AnyObject,
                                                  "UniqueId" : uuid,
                                                  "OSId" : "",
                                                  "TVersion" : tVersion!,
                                                  "Type": "B"]
        printLog(info)
        doRequest("CMN1001", params: info, completion: completion)
        
    }
    
    ///检查更新 CMN1002
    func checkUpdate(_ completion:@escaping (_ resp:CheckUpdateResp)->Void){
        let tVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
        let params:Dictionary<String, AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                    "Type":"B" as AnyObject,
                                                    "Version":tVersion! as AnyObject]
        
        doRequest("CMN1002", params: params, completion: completion)
    }
    
    ///获取验证码 CMN1003
    func acquireVerifyCode(_ mobile:String,opcode:Int, completion:@escaping (_ resp:AcquireVerifyCodeResp)->Void){
        let params:Dictionary<String, AnyObject> = ["Sign" : PropHelper.instance.signature! as AnyObject,
                                                    "Mobile" : mobile as AnyObject,
                                                    "OpCode" : opcode as AnyObject]
        
        doRequest("CMN1003", params: params, completion: completion)
    }
    
    
    // MARK: - User
    
    ///加入黑名单 USR1001
    func addBanUser(_ targetUID:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "TargetUId":targetUID as AnyObject]
        
        doRequest("USR1001", params: params, completion: completion)
    }
    
    ///从黑名单移出用户 USR1002
    func removeBanUser(_ targetUID:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "TargetUId":targetUID as AnyObject]
        
        doRequest("USR1002", params: params, completion: completion)
    }
    
    ///关注用户 USR1003
    func followUser(_ targetUID:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "TargetUId":targetUID as AnyObject]
        
        doRequest("USR1003", params: params, completion: completion)
    }
    
    ///取关用户 USR1004
    func unfollowUser(_ targetUID:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "TargetUId":targetUID as AnyObject]
        
        doRequest("USR1004", params: params, completion: completion)
    }
    
    ///用户注册 USR1005
    func registerUser(mobile:String, password:String, userName:String, verifyCode:String, inviteCode:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "Mobile":mobile as AnyObject,
                                                   "Password":password as AnyObject,
                                                   "UserName":userName as AnyObject,
                                                   "VerifyCode":verifyCode as AnyObject,
                                                   "InviteCode":inviteCode as AnyObject]
        
        doRequest("USR1005", params: params, completion: completion)

    }
    
    ///用户登录 USR1006
    func userLogin(_ mobile:String, password pw:String, completion:@escaping (_ resp:LoginResp)->Void){
        let params:Dictionary<String, AnyObject> = ["Mobile":mobile as AnyObject,
                                                    "Password":pw as AnyObject,
                                                    "Sign":PropHelper.instance.signature! as AnyObject]
        
        doRequest("USR1006", params: params, completion: completion)
    }
    
    ///用户登出 USR1007
    func userLogout(_ completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject]
        
        doRequest("USR1007", params: params, completion: completion)
    }
    
    ///修改用户名称
    func modifyUserName(_ username:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "UserName": username as AnyObject]
        
        doRequest("USR1008", params: params, completion: completion)
    }
    
    ///修改头像
    func modifyThumb(_ thumb:UIImage, completion:@escaping GeneralCallback){
        let data = UIImageJPEGRepresentation(thumb, 0.3)

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(data!, withName: "Thumb", fileName: "thumb.jpg", mimeType: "image/jpeg")
                multipartFormData.append((PropHelper.instance.signature?.data(using: .utf8))!, withName: "Sign")
                multipartFormData.append((PropHelper.instance.userId?.data(using: .utf8))!, withName: "UserId")
                multipartFormData.append((PropHelper.instance.usertoken?.data(using: .utf8))!, withName: "Token")
            },
            to: "\(apiUrl)USR1009",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: { (response) in
                        debugPrint(response)
                        var resp : RespBase? = nil
                        if response.result.isSuccess{
                            if let result = response.result.value{
                                resp = RespBase(data:result as! NSDictionary)
                            }else{
                                let result : Dictionary<String, Any> = [ "Code" : "", "State" : -2, "Msg" : "读取返回数据失败" ]
                                resp = RespBase(data: result as NSDictionary)
                            }
                            
                        }else{
                            let result : Dictionary<String, Any> = [ "Code" : "", "State" : -1, "Msg" : "\(response.result.error?.localizedDescription)" ]
                            resp = RespBase(data: result as NSDictionary)
                        }
                        
                        completion(resp!)
                    })
                    break
                case .failure(let encodingError):
                    debugPrint("\(encodingError)")
                    let result : Dictionary<String, Any> = [ "Code" : "", "State" : -3, "Msg" : "数据编码失败" ]
                    let resp = RespBase(data: result as NSDictionary)
                    completion(resp)
                    break
                }
            }
        )
    }
    
    ///修改用户密码
    func modifyPassword(_ oldPass:String, newPass:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "OldPassword": oldPass as AnyObject,
                                                   "NewPassword": newPass as AnyObject]
        
        doRequest("USR1010", params: params, completion: completion)
    }
    
    ///修改用户性别
    func modifySex(_ sex:Int, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "Sex": sex as AnyObject]
        
        doRequest("USR1011", params: params, completion: completion)
    }
    
    ///发送消息
    func sendMsg(_ tuid:String, content:String,  completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "TUID": tuid as AnyObject,
                                                   "Content": content as AnyObject]
        
        doRequest("USR2001", params: params, completion: completion)
    }
    
    ///将通知消息设为已读
    func setNoticeRead(_ nid:Int64, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "ID": NSNumber(value: nid as Int64)]
        
        doRequest("USR2002", params: params, completion: completion)
    }
    
    ///重置密码
    func resetPassword(_ mobile:String, vcode:String, password:String, completion:@escaping (_ resp:RespBase)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "Mobile": mobile as AnyObject,
                                                   "VerifyCode": vcode as AnyObject,
                                                   "Password": password as AnyObject]
        
        doRequest("USR3001", params: params, completion: completion)

    }
    
    ///添加收货地址
    func addAddress(_ province:String,city:String,district:String,addr:String,zip:String,contact:String,mobile:String,
                    completion:@escaping (AddExchangeInfoResp)->Void){
        let params:Dictionary<String,Any> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "Province":province as AnyObject,
                                                   "City":city as AnyObject,
                                                   "District":district as AnyObject,
                                                   "Address":addr as AnyObject,
                                                   "Zip":zip,
                                                   "Contact":contact,
                                                   "Mobile":mobile]
        
        doRequest("USR4001", params: params, completion: completion)
    }
    
    ///添加关联账户
    func addRelAccount(_ platform:Int, accountNo:String, accountName:String, completion:@escaping (AddExchangeInfoResp)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "Platform":platform as AnyObject,
                                                   "AccountNo":accountNo as AnyObject,
                                                   "AccountName":accountName as AnyObject]
        
        doRequest("USR4002", params: params, completion: completion)
    }
    
    ///准备进行礼品兑换
    func prepareExchange(_ giftId:Int, reqInfoType:Int,  completion:@escaping (PEResultModel)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "GiftId": giftId as AnyObject,
                                                   "ReqInfoType": reqInfoType as AnyObject]
        
        doRequest("USR4004", params: params, completion: completion)
    }
    
    ///兑换礼品
    func doExchange(_ giftId:Int, reqInfoId:Int64, amount:Int,  completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "GiftId": giftId as AnyObject,
                                                   "ReqInfoId": NSNumber(value: reqInfoId as Int64),
                                                   "Amount":amount as AnyObject]
        
        doRequest("USR4005", params: params, completion: completion)
    }
    
    // 礼品确认签收
    func doSignature(_ exchangeId:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "ExchangeId": exchangeId as AnyObject]
        
        doRequest("USR4006", params: params, completion: completion)
    }
    
    // 添加礼品评价
    func doExchangeComment(_ exchangeId:String, rate:Float, comment:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "ExchangeId": exchangeId as AnyObject,
                                                   "Rate": rate as AnyObject,
                                                   "Comment": comment as AnyObject]
        
        doRequest("USR4007", params: params, completion: completion)
    }
    
    ///举报不良信息
    func addReport(_ tid:String, type:Int, reason:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "TargetID": tid as AnyObject,
                                                   "Type": type as AnyObject,
                                                   "Reason": reason as AnyObject]
        
        doRequest("USR9001", params: params, completion: completion)
    }

    // MARK: - Motto
    
    /// 添加Motto
    func addMotto(_ rid: Int, content:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "RID":rid as AnyObject,
                                                   "Content":content as AnyObject]
        
        doRequest("MOT1001", params: params, completion: completion)
    }
    
    //为motto 投票
    func supportMotto(_ mid:Int64, theDay:Int, action:VoteAction, completion:@escaping GeneralCallback) {
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "MID":NSNumber(value: mid as Int64),
                                                   "TheDay":theDay as AnyObject,
                                                   "Support":NSNumber(value:action.rawValue)]
        doRequest("MOT1002", params: params, completion: completion)
    }
    
    func addVote(_ mid:Int64, theDay:Int, support:Bool, completion:@escaping GeneralCallback) {
        var vote = 0
        if support{
            vote = 1
        }
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "MID":NSNumber(value: mid as Int64),
                                                   "TheDay":theDay as AnyObject,
                                                   "Support":vote as AnyObject]
        
        doRequest("MOT1002", params: params, completion: completion)
    }
    
    /// 喜欢Motto
    func loveMotto(_ mid:Int64, theDay:Int, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "MID":NSNumber(value: mid as Int64),
                                                   "TheDay":theDay as AnyObject]
        
        doRequest("MOT1003", params: params, completion: completion)
    }
    
    /// 取消喜欢Motto
    func unloveMotto(_ mid:Int64, theDay:Int, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "MID":NSNumber(value: mid as Int64),
                                                   "TheDay":theDay as AnyObject]
        
        doRequest("MOT1004", params: params, completion: completion)
    }
    
    /// 添加评论
    func addReview(_ mid:Int64,theDay:Int, content:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "MID":NSNumber(value: mid as Int64),
                                                   "TheDay":theDay as AnyObject,
                                                   "Content":content as AnyObject]
        
        doRequest("MOT1005", params: params, completion: completion)
    }
    
    ///删除评论
    func removeReview(_ mid:Int64, rid:Int64, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "MID":NSNumber(value: mid as Int64),
                                                   "RID":NSNumber(value: rid as Int64)]
        
        doRequest("MOT1006", params: params, completion: completion)
    }
    
    ///添加评论投票
    func addReviewVote(_ mid:Int64, rid:Int64, support:Bool, completion:@escaping GeneralCallback){
        var supportState:Int = 0
        if support{
            supportState = 1
        }
        
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "MID":NSNumber(value: mid as Int64),
                                                   "RID":NSNumber(value: rid as Int64),
                                                   "Support": supportState as AnyObject]
        
        doRequest("MOT1007", params: params, completion: completion)
    }
    
    // MARK: - Collection(Album)
    
    ///创建珍藏
    func addCollectin(_ title:String, tags:String, summary:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "Title":title as AnyObject,
                                                   "Tags":tags as AnyObject,
                                                   "Summary":summary as AnyObject]
        
        doRequest("MOT2001", params: params, completion: completion)
    }
    
    ///喜欢珍藏
    func loveCollection(_ cid:Int64, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "CID":NSNumber(value: cid as Int64)]
        
        doRequest("MOT2002", params: params, completion: completion)
    }
    
    ///取消喜欢珍藏
    func unloveCollection(_ cid:Int64, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "CID":NSNumber(value: cid as Int64)]
        
        doRequest("MOT2003", params: params, completion: completion)
    }
    
    ///将Motto加入珍藏
    func addMottoToCollection(_ mid:Int64, cid:Int64, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "MID":NSNumber(value: mid as Int64),
                                                   "CID":NSNumber(value: cid as Int64)]
        
        doRequest("MOT2004", params: params, completion: completion)
    }
    
    ///从珍藏中移除指定motto
    func removeMottoFromCollection(_ mid:Int64, cid:Int64, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "MID":NSNumber(value: mid as Int64),
                                                   "CID":NSNumber(value: cid as Int64)]
        
        doRequest("MOT2005", params: params, completion: completion)
    }
    
    // 修改珍藏信息
    func updateCollection(_ cid:Int64, title:String, tags:String, summary:String, completion:@escaping GeneralCallback){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "Title":title as AnyObject,
                                                   "Tags":tags as AnyObject,
                                                   "Summary":summary as AnyObject,
                                                   "CID":NSNumber(value: cid as Int64)]
        
        doRequest("MOT2006", params: params, completion: completion)
    }
    
    // MARK: - 征集
    
    
    
    // MARK: - Readers
    
    ///按天读取Motto
    func readMottos(_ theday:Int, pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<MottoModel>)->Void){
        let params:Dictionary<String, AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                    "UserId":PropHelper.instance.userId! as AnyObject,
                                                    "TheDay":theday as AnyObject,
                                                    "PIndex":pindex as AnyObject,
                                                    "PSize":psize as AnyObject]
        
        doRequest("RED2001", params: params, completion: completion)
    }
    
    ///查询motto的相关评论
    func readReviews(_ mid:Int64, pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<ReviewModel>)->Void){
        let params:Dictionary<String, AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                    "UserId":PropHelper.instance.userId! as AnyObject,
                                                    "MID": NSNumber(value: mid as Int64),
                                                    "PIndex": pindex as AnyObject,
                                                    "PSize": psize as AnyObject]
        
        doRequest("RED2002", params: params, completion: completion)
    }
    
    // 查询指定作品的投票记录
    func readVotes(_ mid:Int64, pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<VoteModel>)->Void) {
        let params:Dictionary<String, AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                    "MID": NSNumber(value: mid as Int64),
                                                    "PIndex": pindex as AnyObject,
                                                    "PSize": psize as AnyObject]
        
        doRequest("RED2003", params: params, completion: completion)
    }
    
    
    ///查询珍藏排行（发现珍藏）
    func readAlbum(_ pindex:Int, psize:Int,completion:@escaping (_ resp:ReadResp<AlbumModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED4001", params: params, completion: completion)
    }
    
    ///查询珍藏中的作品
    func readAlbumMottos(_ cid:Int64, pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<MottoModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "CID": NSNumber(value: cid as Int64),
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED4002", params: params, completion: completion)
    }
    
    ///查询用户排行榜
    func readUsers(_ pindex:Int, psize:Int, completion: @escaping (_ resp: ReadResp<UserScoreModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED5001", params: params, completion: completion)
    }
    
    ///查询用户详细信息
    func readUserInfo(_ uid:String, completion:@escaping (_ resp:ReadResp<UserModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "UID":uid as AnyObject]
        
        doRequest("RED5002", params: params, completion: completion)
    }
    
    ///查询用户的作品
    func readUserMottos(_ uid:String, pindex:Int, psize:Int, completion: @escaping (_ resp:ReadResp<MottoModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "UID":uid as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED5003", params: params, completion: completion)
    }
    
    ///读取关注用户的人 RED5004
    func readUserFollowers(_ uid:String, pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<RelatedUserModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "UID":uid as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED5004", params: params, completion: completion)
    }
    
    
    ///读取用户关注的人 RED5005
    func readUserFollows(_ uid:String, pindex:Int, psize:Int, completion: @escaping (_ resp:ReadResp<RelatedUserModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "UID":uid as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED5005", params: params, completion: completion)
    }
    
    ///读取用户的黑名单 RED5006
    func readUserBans(_ uid:String, pindex:Int, psize:Int, completion: @escaping (_ resp:ReadResp<RelatedUserModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "UID":uid as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED5006", params: params, completion: completion)
    }
    
    ///查询当前用户创建的珍藏
    func readUserAlbum(_ uid:String, mid:Int64, pindex:Int, psize:Int,completion:@escaping (_ resp:ReadResp<AlbumModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "UID":uid as AnyObject,
                                                   "MID":NSNumber(value: mid as Int64),
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED5007", params: params, completion: completion)
    }
    
    ///查询指定用户喜欢的作品
    func readLovedMottos(_ uid:String, pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<MottoModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "UID":uid as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED5009", params: params, completion: completion)
    }

    
    ///查询指定用户喜欢的珍藏
    func readLovedAlbums(_ uid:String, pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<AlbumModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "UID":uid as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED5010", params: params, completion: completion)
    }
    
    ///查询用户的积分记录
    func readScoreRecord(_ pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<ScoreRecordModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED5020", params: params, completion: completion)

    }
    
    ///查询用户的收支记录
    func readBillRecord(_ pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<BillRecordModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED5021", params: params, completion: completion)
        
    }
    
    ///读取最近的交谈列表
    func readRecentTalk(_ pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<RecentTalkModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED6001", params: params, completion: completion)
        
    }
    
    ///读取与指定用户的消息记录
    func readTalkMsgs(_ withUid:String, start:Int64, take:Int, completion:@escaping (_ resp:ReadResp<TalkMsgModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "UID": withUid as AnyObject,
                                                   "Start": NSNumber(value: start as Int64),
                                                   "Take": take as AnyObject]
        printLog("\(params)")
        doRequest("RED6002", params: params, completion: completion)
    }
    
    ///读取当前用户的提醒通知
    func readNotices(_ pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<NoticeModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED6003", params: params, completion: completion)
    }
    
    ///读取礼品列表
    func readGifts(_ pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<GiftModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED7001", params: params, completion: completion)
    }
    
    ///读取礼品兑换记录
    func readGiftExchanges(_ giftId:Int, pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<GiftExchangeModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject,
                                                   "GiftId": giftId as AnyObject ]
        
        doRequest("RED7002", params: params, completion: completion)
    }
    
    ///读取当前用户兑换记录
    func readUserExchanges(_ pindex:Int, psize:Int, completion:@escaping (_ resp:ReadResp<GiftExchangeModel>)->Void){
        let params:Dictionary<String,AnyObject> = ["Sign":PropHelper.instance.signature! as AnyObject,
                                                   "UserId":PropHelper.instance.userId! as AnyObject,
                                                   "Token":PropHelper.instance.usertoken! as AnyObject,
                                                   "PIndex": pindex as AnyObject,
                                                   "PSize": psize as AnyObject]
        
        doRequest("RED7003", params: params, completion: completion)
    }
    
    
    ///发送通用Api调用请求
    ///
    /// - parameter code: 业务代码
    /// - parameter params: 请求参数
    /// - parameter completion: 回调方法
    ///
    /// - returns: void
    func doRequest<T:IMModelProtocol>(_ code:String, params:Dictionary<String,Any>, completion:@escaping (_ resp:T)->Void){
        alamo.request("\(apiUrl)\(code)", method: .post, parameters: params).responseJSON { (response) in
            debugPrint(response)
            var resp : T? = nil
            if response.result.isSuccess{
                if let result = response.result.value{
                    resp = T(data:result as! NSDictionary)
                }else{
                    let result : Dictionary<String, Any> = [ "Code" : "", "State" : -2, "Msg" : "好像出了点问题，稍后再试吧" ]
                    resp = T(data: result as NSDictionary)
                }
                
            }else{
                debugPrint("error occured: \(response.result.error?.localizedDescription)")
                let result : Dictionary<String, Any> = [ "Code" : "", "State" : -1, "Msg" : "网络不太给力啊！" ]
                resp = T(data: result as NSDictionary)
            }
            
            completion(resp!)
        }
    }
    
}




















