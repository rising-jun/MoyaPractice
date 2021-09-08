//
//  AccountAPI.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/02.
//

import Foundation
import Moya

public enum AccountAPI {
    case getAccount
    case deactivate
    case tokenExchange(provider: String, request: TokenExchangeRequest)
    case tokenRefresh
}
extension AccountAPI: TargetType, AccessTokenAuthorizable {
    public var baseURL: URL { URL(string: ServerConfig.baseUrl)! }
    
    public var path: String {
        let servicePath = "/services/craft"
        switch self {
        case .getAccount:
            return servicePath + "/api/account"
        case .deactivate:
            return servicePath + "/api/deactivate"
        case .tokenExchange(provider: let provider, request: _):
            return servicePath + "/api/token/\(provider)/exchange"
        case .tokenRefresh:
            return servicePath + "/api/token/refresh"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getAccount: return .get
        case .deactivate: return .delete
        case .tokenExchange(provider: _): return .post
        case .tokenRefresh: return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getAccount:
            return .requestPlain
        case .deactivate:
            return .requestPlain
        case .tokenExchange(provider: let provider, request: let request):
            return .requestCustomJSONEncodable(request, encoder: .init())
        case .tokenRefresh:
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "X-USERAGENT": getUserAgent()
        ]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    public var authorizationType: AuthorizationType? {
        switch self {
        case .getAccount: return .bearer
        case .deactivate: return .bearer
        case .tokenExchange(provider: _): return .none
        case .tokenRefresh: return .none
        }
    }
    
    private func getUserAgent() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "version nil"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "build nil"
        let osVersion = UIDevice.current.systemVersion
        let deviceName = UIDevice.current.model

        return "WitchWitch/\(appVersion)/\(build) iOS/\(osVersion)/\(deviceName)"
    }
}

public struct TokenExchangeRequest: Codable {
    let serverAuthCode: Bool = false
    let token: String
}
