//
//  FontTestVC.swift
//  swiftExample
//
//  Created by wanwuMac on 2024/10/17.
//

import UIKit

class FontTestVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellID = "ID";
    var tableView:UITableView?
    let fontNames:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        self.view.addSubview(self.tableView ?? UIView())
        // 获取所有字体名称
        let fontFamilies = UIFont.familyNames
//        NSMutableArray *fontNameArray = [[NSMutableArray alloc] init];
        let name:NSMutableString=""
        // 遍历每个字体系列
        for family in fontFamilies {
            for fontName in UIFont.fontNames(forFamilyName: family) {
                self.fontNames.add(fontName);
                name.append(",\""+fontName+"\"")
            }
        };
        print(name)
        self.fontNames.insert("systemFont.SFUI-Bold", at: 0)
        self.fontNames.insert("systemFont.SFUI-Heavy", at: 1)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fontNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let name:String = fontNames[indexPath.row] as! String
        cell.textLabel?.text = name+"定制化 123"
        cell.textLabel?.font =  self.getFont(row: indexPath.row, fontName: name);
        NSLog("%@", String(format: "%@", cell.textLabel?.font ?? ""))
        cell.contentView.backgroundColor = UIColor.white
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msg = String(format: "%@", self.getFont(row: indexPath.row, fontName: fontNames[indexPath.row] as! String))
        let alertCon = UIAlertController(title: "FontMessage", message: msg, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        alertCon.addAction(cancelAction)
        self.present(alertCon, animated: true)
    }
    
    func getFont(row:NSInteger, fontName:String) -> UIFont {
        if (row == 0) {
            return UIFont.systemFont(ofSize: 14, weight: .bold)
        } else if row == 1 {
            return UIFont.systemFont(ofSize: 14, weight: .heavy)
        }else {
            return UIFont.init(name: fontName, size: 14)!
        }
    }
}
