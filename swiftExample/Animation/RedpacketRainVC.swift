//
//  RedpacketRainVC.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/5/22.
//
import UIKit

class RedpacketRainVC: UIViewController {
    
    var redpacketLayer: CAEmitterLayer?
    var controlButton: UIButton!
    var isAnimating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景色为白色
        view.backgroundColor = .white
        setupButton()
    }
    
    func setupButton() {
        controlButton = UIButton(type: .system)
        controlButton.setTitle("开始红包雨", for: .normal)
        controlButton.addTarget(self, action: #selector(toggleAnimation), for: .touchUpInside)
        view.addSubview(controlButton)
        
        controlButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX);
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10);
        }
    }
    
    @objc func toggleAnimation() {
        isAnimating = !isAnimating
        if isAnimating {
            // 开始动画
            if (redpacketLayer == nil) {
                self.redpacketRain() // 初始化红包雨层，但不开始动画
            }
            redpacketLayer?.birthRate = 1
            controlButton.setTitle("停止红包雨", for: .normal)
        } else {
            // 停止动画
            redpacketLayer?.birthRate = 0
            controlButton.setTitle("开始红包雨", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    // 创建红包雨特效
    func redpacketRain() {
        // 1. 设置CAEmitterLayer
        let redpacketLayer = CAEmitterLayer();
        self.view.layer.addSublayer(redpacketLayer);
            
        self.redpacketLayer = redpacketLayer;
        redpacketLayer.emitterShape = .line; // 发射源的形状 是枚举类型
        redpacketLayer.emitterMode = .surface; // 发射模式 枚举类型
        redpacketLayer.emitterSize = CGSizeMake(self.view.frame.size.width - 20, 0); //self.view.frame.size; // 发射源的size 决定了发射源的大小
        //redpacketLayer.renderMode = .additive; // 渲染模式
        redpacketLayer.emitterPosition = CGPointMake(self.view.bounds.size.width*0.5, -10); // 发射源的位置
        redpacketLayer.birthRate = 0; // 每秒产生的粒子数量的系数
        
        // 2. 配置cell
        let snowCell = CAEmitterCell();
        snowCell.contents = ImageTool.imageWithColor(.red, size: CGSizeMake(20, 30)).cgImage; // 粒子的内容 是CGImageRef类型的
        
        snowCell.birthRate = 10;  // 每秒产生的粒子数量
        snowCell.lifetime = 20;  // 粒子的生命周期
        
        snowCell.velocity = 1;  // 粒子的速度
        snowCell.yAcceleration = 200; // 粒子再y方向的加速的
//        snowCell.emissionLongitude = 0;
//        snowCell.emissionLongitude = Double.pi/2;
//        snowCell.emissionRange = Double.pi/4;
        snowCell.scale = 0.5;  // 粒子的缩放比例
        
        redpacketLayer.emitterCells = [snowCell];  // 粒子添加到CAEmitterLayer上


    }
}

