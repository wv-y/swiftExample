//
//  SpriteKitExample.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/5/21.
//

import UIKit

class SpriteKitExampleVC : UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground;
        self.createRainEffect();
    }
    
    func createRainEffect() {
        let emitterLayer = CAEmitterLayer()
        
        // 配置发射器位置和形状
        emitterLayer.emitterPosition = CGPoint(x: 100, y: 50)
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSize(width: 10, height: 10)
        
        // 创建雨滴粒子
        let rainCell = CAEmitterCell()
        rainCell.contents = UIImage(named: "rainDrop")?.cgImage
        rainCell.scale = 0.15
        rainCell.scaleRange = 0.1
        rainCell.lifetime = 8.0
        rainCell.birthRate = 50
        rainCell.velocity = 600
        rainCell.velocityRange = 20
        rainCell.yAcceleration = 300
        rainCell.emissionLongitude = .pi
        rainCell.emissionRange = .pi / 8
        rainCell.color = UIColor.red.cgColor;// UIColor(white: 1, alpha: 0.3).cgColor
        
        emitterLayer.emitterCells = [rainCell]
        view.layer.addSublayer(emitterLayer)
    }

}
