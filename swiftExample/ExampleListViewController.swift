//
//  ExampleListViewController.swift
//  swiftExample
//
//  Created by 魏凌云 on 2024/9/27.
//

import UIKit
import SnapKit

let cell_id: String = "cell_id";

class ExampleListViewController: UITableViewController {
    
    var dataSource: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "example";
        
        //tableView.backgroundColor = UIColor(white: 1, alpha: 1)
        tableView.register(ExampleTileTableViewCell.self, forCellReuseIdentifier: cell_id)
        
        dataSource.append("faceID")
        dataSource.append("IPAddress")
        dataSource.append("FontList")
        
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
        cell.myLabel.text = dataSource[indexPath.row];
        //cell.contentView.backgroundColor = UIColor.white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = dataSource[indexPath.row];
        var nextVC:UIViewController? = nil
        if (indexPath.row == 0) {
            nextVC = FaceIDTestVC()
        } else if (indexPath.row == 1) {
            nextVC = IPAddressVC();
        } else if (indexPath.row == 2) {
            nextVC = FontTestVC()
        }
        if (nextVC != nil) {
            nextVC?.navigationItem.title = name;
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
    }
}
