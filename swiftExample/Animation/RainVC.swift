//
//  RainVC.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/5/30.
//

import UIKit

class RainVC : UIViewController {
    let rainLayer : CAEmitterLayer = CAEmitterLayer()
    let startButton : UIButton = UIButton()
    let addRainButton : UIButton = UIButton()
    let lowerButton: UIButton = UIButton()
    let buttonStackView : UIStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupEmitter()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        self.startButton.setTitle("下雨☔️", for: .normal)
        self.startButton.setTitle("停止雨🌧️", for: .selected)
        self.startButton.setTitleColor(UIColor.black, for: .normal)
        self.addRainButton.setTitle("加大", for: .normal)
        self.addRainButton.setTitleColor(.red, for: .normal)
        self.lowerButton.setTitle("减小", for: .normal)
        self.lowerButton.setTitleColor(.green, for: .normal)
        
        self.startButton.addTarget(self, action: #selector(didClickSartButton), for: .touchUpInside)
        self.addRainButton.addTarget(self, action: #selector(didClickAddRainButton), for: .touchUpInside)
        self.lowerButton.addTarget(self, action: #selector(didClickLowerButton), for: .touchUpInside)
        
        self.buttonStackView.axis = .horizontal
        self.buttonStackView.spacing = 20;
        self.buttonStackView.addArrangedSubview(startButton)
        self.buttonStackView.addArrangedSubview(addRainButton)
        self.buttonStackView.addArrangedSubview(lowerButton)
        
        self.view.addSubview(self.buttonStackView)
        
        self.buttonStackView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        };
    }
    
    @objc func didClickSartButton() {
        let selected = self.startButton.isSelected
        if (selected) {
            self.rainLayer.birthRate = 0.0;
        } else {
            self.rainLayer.birthRate = 1;
        }
        self.startButton.isSelected = !selected;
    }
    
    @objc func didClickAddRainButton() {
        if (!self.startButton.isSelected) {
            return
        }
        let rate = 1;
        let scale = 0.05;
        if (self.rainLayer.birthRate < 30) {
            self.rainLayer.birthRate = self.rainLayer.birthRate + Float(rate);
            self.rainLayer.scale = self.rainLayer.scale + Float(scale);
        }
    }
    
    @objc func didClickLowerButton() {
        if (!self.startButton.isSelected) {
            return
        }
        let rate : Float = 1.0;
        let scale = 0.05;
        if (self.rainLayer.birthRate > 1) {
            self.rainLayer.birthRate = self.rainLayer.birthRate - rate;
            self.rainLayer.scale = self.rainLayer.scale - Float(scale);
        }
    }
    
    func setupEmitter() {
        self.view.layer.addSublayer(self.rainLayer)
        rainLayer.birthRate = 0.0;
        rainLayer.emitterShape = .line
        rainLayer.emitterMode = .outline
        rainLayer.emitterSize = self.view.frame.size;
        rainLayer.emitterPosition = CGPoint(x: self.view.bounds.size.width / 2, y: -10);
        
        let cell: CAEmitterCell = CAEmitterCell();
        cell.contents = ImageTool.imageWithColor(UIColor.blue, size: CGSize(width: 10, height: 10)).cgImage
        cell.birthRate = 25;
        cell.lifetime = 20;
        cell.speed = 10;
        cell.velocity = 10;
        cell.velocityRange = 10;
        cell.yAcceleration = 500;
        cell.scale = 0.1;
        cell.scaleRange = 0;
        
        // 3.添加到图层上
        rainLayer.emitterCells = [cell];
    }
}
