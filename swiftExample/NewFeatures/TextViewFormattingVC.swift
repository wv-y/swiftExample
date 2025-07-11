//
//  TextViewFormattingVC.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/6/20.
//

import UIKit

class TextViewFormattingVC : UIViewController {
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
        textView.center = self.view.center
        textView.text = "昔人已乘黄鹤去，此地空余黄鹤楼。黄鹤一去不复返，白云千载空悠悠。晴川历历汉阳树，芳草萋萋鹦鹉洲。日暮乡关何处是？烟波江上使人愁。"
        textView.font = .systemFont(ofSize: 18)
        if #available(iOS 17.0, *) {
            textView.borderStyle = .none
        } else {
            // Fallback on earlier versions
        }
        // 开启富文本编辑
        textView.allowsEditingTextAttributes = true
        // iOS18新增，自定义Format选项
        if #available(iOS 18.0, *) {
            textView.textFormattingConfiguration = .init(groups: [
                // 第1组
                .group([
                    .component(.formattingStyles, .automatic),
                    .component(.fontAttributes, .small),
                    .component(.fontPicker, .regular),
                    .component(.fontSize, .small),
                    .component(.fontPointSize, .mini)
                ]),
                // 第2组
                .group([
                    .component(.textAlignment, .mini),
                    .component(.textAlignmentAndJustification, .mini),
                    .component(.textIndentation, .mini),
                    .component(.lineHeight, .mini),
                    .component(.listStyles, .regular)
                ]),
                // 第3组
                .group([
                    .component(.textColor, .extraLarge),
                    .component(.highlight, .mini),
                    UITextFormattingViewController.Component(componentKey: .highlightPicker, preferredSize: .large),
                ])
            ])
        } else {
            // Fallback on earlier versions
        }
        // 设置输入附件视图
        textView.inputAccessoryView = self.textViewAccessoryView();
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        textView.backgroundColor = .lightGray
        self.view.addSubview(self.textView)
    }
    
    func textViewAccessoryView() -> UIToolbar {
        let button = UIBarButtonItem()
        button.title = "关闭键盘"
        button.target = self
        button.action = #selector(dismissKeyboard)
        button.style = .plain

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([space, button], animated: true)
        return toolbar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
