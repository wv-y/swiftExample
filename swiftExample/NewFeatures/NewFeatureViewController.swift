//
//  NewFeatureViewController.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/6/18.
//

import UIKit

class NewFeatureViewController : UIViewController {
    
    lazy var stackView : UIStackView = {
        let tempStack = UIStackView(frame: UIScreen.main.bounds)
        tempStack.axis = .vertical
        tempStack.spacing = 10;
        
        view.addSubview(tempStack)
        tempStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        let pencilKitButton = UIButton(type: .system)
        pencilKitButton.setTitle("pencilKit", for: .normal)
        pencilKitButton.addTarget(self, action: #selector(openPencilTestVC), for: .touchUpInside)
        
        let textViewFormatButton = UIButton(type: .system)
        textViewFormatButton.setTitle("textViewFormat", for: .normal)
        textViewFormatButton.addTarget(self, action: #selector(openTextViewFormatVC), for: .touchUpInside)

        tempStack.addArrangedSubview(pencilKitButton)
        tempStack.addArrangedSubview(textViewFormatButton)
        
        return tempStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(self.stackView)
    }
    
    @objc func openPencilTestVC() {
        let vc = PencilKitTestVC();
        self.navigationController?.present(vc, animated: true)
    }
    
    @objc func openTextViewFormatVC() {
        let vc = TextViewFormattingVC();
        self.navigationController?.present(vc, animated: true)
    }
}
