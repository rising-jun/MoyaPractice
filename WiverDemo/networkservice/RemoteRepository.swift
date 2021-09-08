//
//  RemoteRepository.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/02.
//

import Foundation
import Moya

class RemoteRepository<API: TargetType>: PluginType {
    private let provider = MoyaProvider<API>()
    lazy var rx = provider.rx
    
    private let authProvider = MoyaProvider<API>(plugins: [ AccessTokenPlugin { _ in
                                                                if let token = UserDefaults.standard.string(forKey: "accessToken") {
                                                                    return token
                                                                } else {
                                                                    return ""
                                                                }}, NetworkLoggerPlugin()])
 
    lazy var authRx = authProvider.rx
}
