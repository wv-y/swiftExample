//
//  CropImageVC.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/7/23.
//

import UIKit
import SDWebImage
import JPImageresizerView
import PhotosUI

class CropImageVC: UIViewController, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    
    let sizeButton: UIButton = UIButton(type: .system)
    let selectImgButton: UIButton = UIButton(type: .system)
    var imageresizerView: JPImageresizerView = {
        // 配置信息
        let configure = JPImageresizerConfigure.defaultConfigure(with: UIImage(named: "cropImage")!) { con in
            // _ 表示“故意忽略返回值“，swift通用做法
            _ = con.jp_viewFrame(CGRectMake(0, 100, UIScreen.main.bounds.width, 500))
        }
        // 是否可以任意比例
        configure.isArbitrarily = false
        configure.resizeWHScale = 16/9;
        let imageresizerView = JPImageresizerView(configure: configure) { isCanRecovery in
            // 重置设置按钮是否可点
            
        } imageresizerIsPrepareToScale: {isPrepareToScale in
            // 缩放设置按钮是否可点
            
        }
        return imageresizerView
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        
        sizeButton.setTitle("设置宽高", for: .normal)
        sizeButton.addTarget(self, action: #selector(sizeButtonTapped), for: .touchUpInside)
        
        view.addSubview(sizeButton)
        sizeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview().offset(-20)
        }
        
        selectImgButton.setTitle("选择图片", for: .normal)
        selectImgButton.addTarget(self, action: #selector(openPhotoLibrary), for: .touchUpInside)
        
        view.addSubview(selectImgButton)
        selectImgButton.snp.makeConstraints { make in
            make.top.equalTo(sizeButton)
            make.left.equalTo(sizeButton.snp.right).offset(20)
        }
        
        view.addSubview(imageresizerView)
        imageresizerView.snp.makeConstraints { make in
            make.top.equalTo(sizeButton.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
//    @objc func openPhotoLibrary() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.sourceType = .photoLibrary
//        self.present(imagePickerController, animated: true, completion: nil)
//    }
    
    /// iOS 14 及以上使用
    @objc func openPhotoLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1  // 限制选择一张图片
        configuration.filter = .images   // 只显示图片
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func sizeButtonTapped() {
        let alertController = UIAlertController(title: "设置宽高", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "宽度"
            textField.keyboardType = .numberPad
        }
        alertController.addTextField { textField in
            textField.placeholder = "高度"
            textField.keyboardType = .numberPad
        }
        
        let confirmAction = UIAlertAction(title: "确定", style: .default) { _ in
            guard let widthText = alertController.textFields?[0].text,
                  let heightText = alertController.textFields?[1].text,
                  let width = Int(widthText),
                  let height = Int(heightText) else {
                return
            }
            // 要先转成浮点数再计算，避免整数除法丢失小数位
            let w2h = CGFloat(width) / CGFloat(height)
            // 更新 裁剪宽高比
            self.imageresizerView.setResizeWHScale(w2h, isToBeArbitrarily: false, animated: true)
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.imageresizerView.setImage(selectedImage, animated: true)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - PHPickerViewControllerDelegate
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            
            guard let result = results.first else { return }
            
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("加载图片失败: \(error.localizedDescription)")
                            return
                        }
                        
                        if let selectedImage = image as? UIImage {
                            self?.imageresizerView.setImage(selectedImage, animated: true)
                        }
                    }
                }
            }
        }
}
