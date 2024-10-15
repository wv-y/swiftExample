//
//  FaceIDTestVC.swift
//  swiftExample
//
//  Created by 魏凌云 on 2024/9/27.
//

import UIKit
import SnapKit
import LocalAuthentication

class FaceIDTestVC: UIViewController {

    let confirmButton:UIButton = UIButton(type: .system)
    
    //var context = LAContext();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.secondarySystemBackground;
        
        self.confirmButton.setTitle("Face ID", for: .normal)
        self.confirmButton.addTarget(self, action: #selector(checkFace), for: .touchUpInside)
        
        self.view.addSubview(confirmButton)
        
        self.confirmButton.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.size.equalTo(CGSizeMake(80, 30))
        }
    }
    
    @objc private func checkFace() {
        let reason = "使用 Face ID 登录"
        let context = LAContext();
        context.localizedFallbackTitle = "识别生物密码";
        context.localizedCancelTitle = "cancel"
        
        var error :NSError?
        let permissions = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error);
        if permissions {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    NSLog("识别成功")
                } else {
                    
                }
            }
        }
    }
}
