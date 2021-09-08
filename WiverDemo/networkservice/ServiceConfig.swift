//
//  ServiceConfig.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/02.
//

import Foundation

struct ServerConfig {
    static let baseUrl = "https://dev.wcraft.io"
    //static let baseUrl = "https://dev.witchwitch.io"
    static let naverUrl = "https://openapi.naver.com"
    static let apiScheme = "https"
    static let socketScheme = "wss"
    static let apiPort = 8000
    static let timeOutInterval: TimeInterval = 5.0
    
    static let headerUserAgent = "X-USERAGENT"
    static let headerContentType = "Content-Type"
    static let headerAuthorization = "Authorization"
    static let headerXDUID = "X-DUID"
    
    static func getMyDeviceInfo() -> String {
        var uuid:String = "uuid"
        if UserDefaults.standard.value(forKey: Key.DEVICE_UUID_KEY) != nil {
            uuid = UserDefaults.standard.value(forKey: Key.DEVICE_UUID_KEY) as! String
        }
        
        return "witchiPhone;\(uuid)"
    }
}
