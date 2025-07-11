//
//  PencilKitTest.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/6/20.
//

import PencilKit
import UIKit

class PencilKitTestVC : UIViewController {
    lazy var canvasView: PKCanvasView = {
        let canvasView = PKCanvasView()
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        return canvasView
    }()
    // 调色板
    lazy var toolPicker: PKToolPicker = {
        //  iOS18新增，自定义调色板工具选项
        var toolPicker : PKToolPicker;
        if #available(iOS 18.0, *) {
            var config = PKToolPickerCustomItem.Configuration(identifier: "customTool", name: "pencil.and.scribble")
            config.imageProvider = { toolItem in
                guard let toolImage = UIImage(systemName: config.name) else {
                    return UIImage()
                }
                return toolImage
            }
            config.allowsColorSelection = true
            config.defaultColor = .red
            config.defaultWidth = 10.0
            let customItem = PKToolPickerCustomItem(configuration: config)
            // iOS18新增，自定义中间区域的调色板工具
            toolPicker = PKToolPicker(toolItems: [PKToolPickerInkingItem(type: .pen), PKToolPickerLassoItem(), PKToolPickerRulerItem(),
                                                  PKToolPickerEraserItem(type: .bitmap), PKToolPickerScribbleItem(), customItem])
            return toolPicker
        }
        return PKToolPicker()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        view.addSubview(canvasView)
        if #available(iOS 18.0, *) {
            setToolPicker()
        } else {
            // Fallback on earlier versions
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: 为PKCanvasView设置PKToolPicker
    @available(iOS 18.0, *)
    func setToolPicker() {
        toolPicker.addObserver(canvasView)
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        // iOS18新增，自定义右侧附加选项
        toolPicker.accessoryItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down.fill"), primaryAction: UIAction(handler: { [self] _ in
            self.saveDrawing()
        }))
        canvasView.becomeFirstResponder()
    }

    // MARK: 保存绘画内容到相册
    func saveDrawing() {
        AuthorityTool.requestPhotoAuthority { status in
            if (status == .limited || status == .authorized) {
                let drawing = self.canvasView.drawing
                let image = drawing.image(from: self.canvasView.frame, scale: UIScreen.main.scale)
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.view.makeToast("保存成功")
            } else {
                self.view.makeToast("获取授权失败，请前往设置打开权限")
            }
        }
        
    }
}

