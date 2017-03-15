//
//  PropHelper.swift
//  iMottoApp
//
//  Created by sunht on 16/5/21.
//  Copyright © 2016年 imotto. All rights reserved.
//

import Foundation
import KeychainAccess


class PropHelper{
    static let instance = PropHelper()
    
    var appInitialized : Bool{
        didSet{
            debugPrint("appInitialized is set to:\(appInitialized)")
            if appInitialized != oldValue{
                UserDefaults.standard.set(appInitialized, forKey: UserDefaultsKeyAppInit)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    ///用户是否已登录
    var isLogin : Bool{
        get{
            if let utoken = self.usertoken{
                return utoken != ""
            }
            
            return false
        }
    }
    
    ///用户ID，成功登录后获得
    var userId : String?{
        didSet{
            debugPrint("userId in keychain is set to : \(userId)")
            if userId != oldValue{
                let keychain = Keychain(service:BUNDLE_IDENTIFIER)
                do{
                    try keychain.set(userId!, key:KEYCHAIN_USERID_KEY)
                    debugPrint("save userId to keychain success.")
                }catch let error{
                    print("save userId to keychain failure: \(error).")
                }
            }
        }
    }
    
    ///设备
//    var deviceToken : String?{
//        didSet{
//            debugPrint("deviceToken is set to:\(deviceToken)")
//            if deviceToken != oldValue{
//                let defaults = NSUserDefaults.standardUserDefaults()
//                defaults.setObject(deviceToken, forKey: UserDefaultsKeyDeviceToken)
//                defaults.synchronize()
//            }
//        }
//    }
    
    ///设备签名lo
    var signature : String?{
        didSet{
            debugPrint("signature is set to:\(signature)")
            if signature != oldValue{
                let keychain = Keychain(service: BUNDLE_IDENTIFIER)
                do{
                    try keychain.set(signature!, key: KEYCHAIN_SIGNATURE_KEY)
                    debugPrint("save signature to keychain success.")
                } catch let error{
                    print("save signature to keychain failure:\(error).")
                }
            }
        }
    }
    
    ///设备UUID
    var uuid : String?{
        didSet{
            debugPrint("uuid in keychain is set to : \(uuid)")
            if uuid != oldValue{
                let keychain = Keychain(service:BUNDLE_IDENTIFIER)
                do{
                    try keychain.set(uuid!, key:KEYCHAIN_UUID_KEY)
                    debugPrint("save uuid to keychain success.")
                }catch let error{
                    print("save uuid to keychain failure: \(error).")
                }
            }
        }
    }
    
    ///用户名
    var user : String?{
        didSet{
            debugPrint("username is set to:\(user)")
            if user != oldValue{
                let defaults = UserDefaults.standard
                if user == nil{
                    self.user = ""
                    defaults.removeObject(forKey: UserDefaultsKeyUser)
                }
                else{
                    defaults.set(user, forKey: UserDefaultsKeyUser)
                }
            
                defaults.synchronize()
            }
        }
   }
    
    ///用户头像
    var userThumb: String?{
        didSet{
            debugPrint("userthumb is set to:\(userThumb)")
            if userThumb != oldValue{
                let defaults = UserDefaults.standard
                if userThumb == nil{
                    self.userThumb = ""
                    defaults.removeObject(forKey: UserDefaultsKeyUserThumb)
                }
                else{
                    defaults.set(userThumb, forKey: UserDefaultsKeyUserThumb)
                }
                
                defaults.synchronize()
            }
        }
    }
    
    ///用户密码
    var password : String?{
        didSet{
            debugPrint("password in keychain is set to : \(password)")
            if password != oldValue{
                let keychain = Keychain(service: BUNDLE_IDENTIFIER)
                do{
                    try keychain.set(password!, key:KEYCHAIN_PASSWORD_KEY)
                    debugPrint("save password to keychain success.")
                }catch let error{
                    print("save password to keychain failure: \(error)")
                }
            }
        }
    }
    
    ///用户令牌
    var usertoken : String?{
        didSet{
            debugPrint("usertoken in keychain is set to : \(usertoken)")
            if usertoken != oldValue{
                let keychain = Keychain(service: BUNDLE_IDENTIFIER)
                do{
                    try keychain.set(usertoken!,key: KEYCHAIN_USERTOKEN_KEY)
                    debugPrint("save usertoken to keychain success.")
                }catch let error{
                    print("save usertoken to keychain failure: \(error)")
                }
            }
        }
    }
    
    ///用户手机号码(作为用户名)
    var mobile : String?{
        didSet{
            debugPrint("mobile in keychain is set to : \(mobile)")
            if mobile != oldValue{
                let keychain = Keychain(service: BUNDLE_IDENTIFIER)
                do{
                    try keychain.set(mobile!,key: KEYCHAIN_MOBILE_KEY)
                    debugPrint("save mobile to keychain success.")
                }catch let error{
                    print("save mobile to keychain failure: \(error)")
                }
            }
 
        }
    }
    
    
    fileprivate init(){
        let defaults = UserDefaults.standard
        defaults.register(defaults: [UserDefaultsKeyAppInit: false])
        
        appInitialized = defaults.bool(forKey: UserDefaultsKeyAppInit)
        //self.deviceToken = defaults.stringForKey(UserDefaultsKeyDeviceToken)
        self.user = defaults.string(forKey: UserDefaultsKeyUser)
        self.userThumb = defaults.string(forKey: UserDefaultsKeyUserThumb)
        
        let keychain = Keychain(service: BUNDLE_IDENTIFIER)
        self.signature = keychain[KEYCHAIN_SIGNATURE_KEY]
        self.uuid = keychain[KEYCHAIN_UUID_KEY]
        if let tmp = keychain[KEYCHAIN_USERID_KEY]{
            self.userId = tmp
        }else{
            self.userId = ""
        }
        self.mobile = keychain[KEYCHAIN_MOBILE_KEY]
        self.password = keychain[KEYCHAIN_PASSWORD_KEY]
        self.usertoken = keychain[KEYCHAIN_USERTOKEN_KEY]
        
    }
    
    func deleteKeychainItem(_ key:String){
        let keychain = Keychain(service: BUNDLE_IDENTIFIER)
        
        do{
            try keychain.remove(key)
            debugPrint("remove keychain item \(key) success.")
        }catch let error{
            print("remove keychain item \(key) failure: \(error).")
        }
        
    }
    
    
    
}
