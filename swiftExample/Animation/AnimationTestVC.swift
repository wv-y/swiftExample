//
//  AnimationTestVC.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/5/22.
//

import UIKit
import JGProgressHUD
import Toast

class AnimationTestVC: UIViewController {
    let stackView : UIStackView = UIStackView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondarySystemBackground;
        
        stackView.axis = .vertical
        stackView.alignment = .center
        
        self.view.addSubview(self.stackView);
        
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top);
            make.left.right.equalTo(self.view);
            //make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        self.addButtonsToStackView();
    }
    
    func addButtonsToStackView() {
        stackView.spacing = 20;
        
        let CAEmitterButton = UIButton();
        CAEmitterButton.setTitle("红包雨", for: .normal);
        CAEmitterButton.setTitleColor(.blue, for:.normal);
        CAEmitterButton.addTarget(self, action: #selector(CAEmitterButtonTapped), for: .touchUpInside);
        stackView.addArrangedSubview(CAEmitterButton);
        
        let rainButton = UIButton();
        rainButton.setTitle("rain", for: .normal)
        rainButton.setTitleColor(.blue, for: .normal)
        rainButton.addTarget(self, action: #selector(RainButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(rainButton)
    }
    
    @objc func CAEmitterButtonTapped() {
        let vc = RedpacketRainVC()
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true)
    }
 
    @objc func RainButtonTapped() {
        let vc = RainVC()
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true)
    }
}
