//
//  ExampleListViewController.swift
//  swiftExample
//
//  Created by 魏凌云 on 2024/9/27.
//

import UIKit
import SnapKit

let cell_id: String = "cell_id";

enum ExampleVcName: String, CaseIterable {
    case faceID = "faceID"
    case ipAddress = "IPAddress"
    case fontList = "FontList"
    case spriteKitEx = "SpriteKitEx"
    case animation = "Animation"
    case UIKitAPIFeature = "UIKitNewFeature"
    case blueTooth = "BlueTooth"
    case DynamicDemo = "DynamicDemo"
}

class ExampleListViewController: UITableViewController {
    
    var dataSource: [ExampleVcName] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "example";
        
        //tableView.backgroundColor = UIColor(white: 1, alpha: 1)
        tableView.register(ExampleTileTableViewCell.self, forCellReuseIdentifier: cell_id)
        dataSource = ExampleVcName.allCases
        
        // 设置导航栏透明
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! ExampleTileTableViewCell
        cell.myLabel.text = dataSource[indexPath.row].rawValue;
        //cell.contentView.backgroundColor = UIColor.white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = dataSource[indexPath.row];
        var nextVC:UIViewController? = nil
        
        switch name {
        case .faceID:
            nextVC = FaceIDTestVC()
        case .ipAddress:
            nextVC = IPAddressVC()
        case .fontList:
            nextVC = FontTestVC()
        case .spriteKitEx:
            nextVC = SpriteKitExampleVC()
        case .animation:
            nextVC = AnimationTestVC()
        case .UIKitAPIFeature:
            nextVC = NewFeatureViewController()
        case .blueTooth:
            nextVC = BlueToothVC()
        case .DynamicDemo:
            nextVC = DynamicDemoViewController()
        }
        if (nextVC != nil) {
            nextVC?.navigationItem.title = name.rawValue;
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
    }
}
