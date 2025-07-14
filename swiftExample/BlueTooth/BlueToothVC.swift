//
//  BlueToothVC.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/7/4.
//

import UIKit

class BlueToothVC: UIViewController, BlueToothCentralManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let batteryLevelLabel : UILabel = UILabel()
    let centerButton : UIButton = UIButton(type: .system);
    /// 用于去重判断
    var deviceUDIDSet : Set = Set<UUID>();
    var deviceDict : [UUID : BlueToothDeviceMessage] = [:]
    let deviceNameListView : UITableView = UITableView(frame: CGRectZero, style: .grouped)
    /// 用于显示
    var displayDeviceList = Array<BlueToothDeviceMessage>();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BlueToothManager.shared.delegate = self
        
        self.view.backgroundColor = UIColor.white
        self.batteryLevelLabel.textColor = .black
        self.centerButton.setTitle("重新扫描蓝牙", for: .normal)
        self.centerButton.addTarget(self, action: #selector(clickCenterButton), for: .touchUpInside)
        
        deviceNameListView.delegate = self;
        deviceNameListView.dataSource = self;
        deviceNameListView.sectionHeaderHeight = 0;
        deviceNameListView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        
        view.addSubview(self.centerButton)
        view.addSubview(self.deviceNameListView)
        view.addSubview(self.batteryLevelLabel)
        
        self.batteryLevelLabel.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).offset(-20)
            make.top.equalTo(view.snp.top).offset(150)
            make.centerX.equalTo(view.snp.centerX)
        }
        self.centerButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(100)
            make.centerX.equalTo(view.snp.centerX)
        };
        self.deviceNameListView.snp.makeConstraints { make in
            make.top.equalTo(batteryLevelLabel.snp.bottom).offset(20);
            make.left.right.bottom.equalTo(view);
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        BlueToothManager.shared.stopScanBlueTooth()
    }
    
    @objc func clickCenterButton() {
        BlueToothManager.shared.scanBlueToothDevices()
    }
    
    // MARK: BlueToothCentralManagerDelegate
    func didDiscover(name: String, message: BlueToothDeviceMessage) {
        let oldSet = self.deviceUDIDSet
        deviceUDIDSet.insert(message.peripheral.identifier);
        var needRefresh = false;
        if (deviceUDIDSet.count != self.displayDeviceList.count) {
            needRefresh = true;
        } else {
            if (oldSet != deviceUDIDSet) {
                // 元素不完全相同
                needRefresh = true;
            }
        }
        if (needRefresh) {
            self.deviceDict[message.peripheral.identifier] = message
            self.displayDeviceList = Array(deviceDict.values)
            self.deviceNameListView.reloadData()
        }
    }
    
    func didUpdateBatteryLevel(level: Int) {
        let name = BlueToothManager.shared.peripheral?.name ?? "";
        self.batteryLevelLabel.text = name + "电量: " + String(format: "%d%", level)
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayDeviceList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        var config = cell.defaultContentConfiguration();
        config.text = self.displayDeviceList[indexPath.row].peripheral.name;
        cell.contentConfiguration = config;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BlueToothManager.shared.connectBlueToothDevice(self.displayDeviceList[indexPath.row])
    }
}
