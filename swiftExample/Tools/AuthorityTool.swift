//
//  AuthorityTool.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/6/20.
//

import Foundation
import Photos

class AuthorityTool: NSObject {
    
    static func requestPhotoAuthority() async -> PHAuthorizationStatus {
        // 获取当前的授权状态
        var status = PHPhotoLibrary.authorizationStatus(for: .addOnly)

        // 如果权限状态是未确定的情况，进行请求
        if status == .notDetermined {
            // 使用 await 等待请求结果
            status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        }

        // 返回最终的授权状态
        return status
    }
    
    static func requestPhotoAuthority(completion: @escaping (PHAuthorizationStatus) -> Void) {
        // 获取当前的授权状态
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        // 如果权限状态是未确定的情况，进行请求
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                // 在主线程回调新的权限状态
                DispatchQueue.main.async {
                    completion(newStatus)
                }
            }
        default:
            // 当前已知的权限状态直接回调
            completion(status)
        }
    }
}

