//
//  DynamicDemoVC.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/7/11.
//

import UIKit
import CoreMotion

class DynamicDemoViewController: UIViewController {

    let backDynamicView : UIView = UIView()
    var balls : Array<UIImageView> = Array()
    
    // 动画控制器
    private var animator: UIDynamicAnimator!
    // 重力行为
    private var gravity: UIGravityBehavior!
    // 碰撞行为
    private var collision: UICollisionBehavior!
    // 物体行为（弹性等）
    private var itemBehavior: UIDynamicItemBehavior!
    // 运动管理器
    private var motionManager: CMMotionManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backDynamicView.layer.borderWidth = 2;
        self.backDynamicView.layer.borderColor = UIColor.white.cgColor
        
        self.view.backgroundColor = .lightGray
        self.view.addSubview(self.backDynamicView)
        
        self.backDynamicView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(10)
            make.left.right.equalTo(self.view)
        }
        
        self.createBalls()
        self.setupMotionDetection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 停止运动检测
        motionManager.stopDeviceMotionUpdates()
    }
    
    func createBalls() {
        let imageNames = ["cloud.sun.fill", "cloud.sun.circle", "cloud.sun.rain.fill", "cloud.sun.rain.circle", "cloud.sun.bolt.fill", "cloud.sun.bolt.circle"]
        for i in 0..<imageNames.count {
            let x = Int.random(in: 0...Int(UIScreen.main.bounds.width - 80))
            let y = Int.random(in: 0...50)
            let imageV = UIImageView(frame: CGRect(x: x, y: y, width: 80, height: 80))
            imageV.backgroundColor = .white
            imageV.image = UIImage(systemName: imageNames[i])
            imageV.layer.cornerRadius = 40
            imageV.layer.masksToBounds = true
            self.backDynamicView.addSubview(imageV)
            self.balls.append(imageV)
        }
        
        // 创建动画控制器
        animator = UIDynamicAnimator(referenceView: self.backDynamicView)
        
        // 重力动态特性
        gravity = UIGravityBehavior(items: self.balls)
        animator.addBehavior(gravity)
        
        // 碰撞特性
        collision = UICollisionBehavior(items: self.balls)
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        // 弹性和其他物理属性
        itemBehavior = UIDynamicItemBehavior(items: self.balls)
        itemBehavior.allowsRotation = true // 允许旋转
        itemBehavior.elasticity = 0.5 // 弹性量
        itemBehavior.friction = 0.1 // 摩擦力
        itemBehavior.resistance = 0.1 // 阻力
        animator.addBehavior(itemBehavior)
    }
    
    func setupMotionDetection() {
        // 初始化运动管理器
        motionManager = CMMotionManager()
        
        // 确保设备支持运动检测
        guard motionManager.isDeviceMotionAvailable else {
            print("设备不支持运动检测")
            return
        }
        
        // 设置更新频率
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0 // 60Hz
        
        // 开始运动更新
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
            guard let self = self, let motion = motion else { return }
            
            // 获取重力数据
            //let gravity = motion.gravity
            
            // 将重力数据转换为UI坐标系
            // 注意：设备坐标系和UI坐标系不同，需要转换
            // x轴：左右方向，正值向右
            // y轴：上下方向，正值向下
//            let x = CGFloat(gravity.x)
//            let y = CGFloat(gravity.y)
//            // 更新重力行为的方向和大小
//            self.gravity.gravityDirection = CGVector(dx: x, dy: -y) // y轴反转
//            // 调整重力大小
//            let magnitude = sqrt(x*x + y*y)
//            self.gravity.magnitude = min(magnitude * 2.0, 5.0) // 限制最大重力
            
            let yaw = motion.attitude.yaw
            let pitch = motion.attitude.pitch
            let roll = motion.attitude.roll
            let rotation = atan2(pitch, roll)
            // 重力角度
            self.gravity.angle = rotation
        }
    }
}
