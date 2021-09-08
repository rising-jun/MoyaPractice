//
//  UploadAPI.swift
//  WiverDemo
//
//  Created by 김동준 on 2021/09/07.
//

import Foundation
import Moya

public enum UploadAPI {
    case upload(image: Data)
}

extension UploadAPI: TargetType, AccessTokenAuthorizable {
    public var baseURL: URL { URL(string: ServerConfig.baseUrl)! }
    
    public var path: String {
        let servicePath = "/services/craft"
        switch self {
        case .upload(image: _):
            return servicePath + "/api/uploads"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .upload(image: _):
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .upload(image: let image):
            let jpegData = MultipartFormData(provider: .data(image), name: "upload", fileName: "iOS_UPLOAD_CONTENT_IMAGE_\(getTimeStamp())", mimeType: "image/jpeg")
            let formData: [Moya.MultipartFormData] = [jpegData]
            return .uploadMultipart(formData)

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
        return .bearer
    }
    
    private func getUserAgent() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "version nil"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "build nil"
        let osVersion = UIDevice.current.systemVersion
        let deviceName = UIDevice.current.model

        return "WitchWitch/\(appVersion)/\(build) iOS/\(osVersion)/\(deviceName)"
    }
    
    private func getTimeStamp() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: now)
    }
}

