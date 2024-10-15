//
//  IPAddressVC.swift
//  swiftExample
//
//  Created by 魏凌云 on 2024/10/12.
//

import UIKit

class IPAddressVC: UIViewController {

    let button = UIButton(type: .system);
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews();
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.secondarySystemBackground
        
        button.setTitle("IPAddress", for: .normal)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }

    @objc func buttonClicked() {
        let ipAddress:String = NetIPAddress.getLocalIPAddress(true)
        let alertC = UIAlertController(title: ipAddress, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        alertC.addAction(cancelAction)
        self.navigationController?.present(alertC, animated: true)
    }

}
