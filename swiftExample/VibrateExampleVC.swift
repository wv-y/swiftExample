//
//  VibrateExample.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/12/29.
//


import UIKit
import AudioToolbox


class FeedbackButton: UIButton {
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFeedback()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFeedback()
    }
    
    private func setupFeedback() {
        if #available(iOS 10.0, *) {
            feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        }
        
        addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonTouchDown() {
        if #available(iOS 10.0, *) {
            feedbackGenerator?.prepare()
        }
    }
    
    @objc private func buttonTouchUp() {
        if #available(iOS 10.0, *) {
            feedbackGenerator?.impactOccurred()
        }
    }
}



class VibrateExampleVC : UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground;
        
        let simpleButton = UIButton(type: .system);
        simpleButton.setTitle("simpleVibration", for: .normal)
        simpleButton.addTarget(self, action: #selector(buttonSimpleVibration), for: .touchUpInside)
        self.view.addSubview(simpleButton)
        simpleButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalTo(self.view.snp.centerX);
        }
        
        
        let feedbackButton = FeedbackButton(type: .system)
        view.addSubview(feedbackButton)
        feedbackButton.setTitle("触感反馈", for: .normal)
        feedbackButton.snp.makeConstraints { make in
            make.top.equalTo(simpleButton.snp_bottomMargin).offset(20)
            make.centerX.equalTo(self.view.snp.centerX)
        }
    }
    
    @objc func buttonSimpleVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }

}

