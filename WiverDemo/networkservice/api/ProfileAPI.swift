//
//  ProfileService.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/02.
//

import Foundation
import Moya

public enum ProfileAPI {
    case getProfile
    case setProfile(updateUserRequest: UserUpdateInfo)
    case nicknameCheck(nickname: String)
}
extension ProfileAPI: TargetType, AccessTokenAuthorizable {
    public var baseURL: URL { URL(string: ServerConfig.baseUrl)! }
    
    public var path: String {
        let servicePath = "/services/craft"
        switch self {
        case .getProfile, .setProfile:
            return servicePath + "/api/profile"
        case .nicknameCheck(nickname: let nickname):
            return servicePath + "/api/profile/check/\(nickname)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getProfile: return .get
        case .setProfile(_): return .put
        case .nicknameCheck(_): return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getProfile:
            return .requestPlain
        case .setProfile(updateUserRequest: let updateUserRequest) :
            return .requestCustomJSONEncodable(updateUserRequest, encoder: .init())
        case .nicknameCheck(_):
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
        case .getProfile: return .bearer
        case .setProfile: return .bearer
        case .nicknameCheck(_): return .bearer
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
