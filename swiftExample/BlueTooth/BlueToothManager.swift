//
//  BlueToothManager.swift
//  swiftExample
//
//  Created by 魏凌云 on 2025/7/4.
//

import Foundation
import CoreBluetooth
import JGProgressHUD
import ProgressHUD

protocol BlueToothCentralManagerDelegate : AnyObject {
    // 返回查询到的设备名
    func didDiscover(name: String, message: BlueToothDeviceMessage)
    // 返回设备电量
    func didUpdateBatteryLevel(level: Int)
}

class BlueToothDeviceMessage: NSObject {
    let peripheral : CBPeripheral;
    let advertisementData: [String : Any]
    
    init(peripheral: CBPeripheral, advertisementData: [String : Any]) {
        self.peripheral = peripheral
        self.advertisementData = advertisementData
    }
}

class BlueToothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    // 电池服务UUID (标准的电池服务UUID)
    private let batteryServiceUUID = CBUUID(string: "180F")
    // 电池电量特征UUID (标准的电池电量特征UUID)
    private let batteryLevelCharacteristicUUID = CBUUID(string: "2A19")
    
    // 当前设备电量
    private var batteryLevel: Int = -1
    
    static let shared = BlueToothManager()
    
    weak var delegate : BlueToothCentralManagerDelegate?;
    
    var blueToothState : CBManagerState = .unknown;
    
    var centralManager : CBCentralManager?;
    /// 连接的蓝牙外设
    var peripheral : CBPeripheral?;
    
    private override init() {
        super.init()
        let options :[String : Any] = [
            // 表示初始化时如果没打开蓝牙则自动Alert
            CBCentralManagerOptionShowPowerAlertKey : true,
            // 对应唯一标识的字符串，蓝牙进程被杀掉恢复连接时使用
            // 使用恢复功能需要在info.plist声明UIBackgroundModes
            //CBCentralManagerOptionRestoreIdentifierKey : "com.wly.my_blue_id"
        ]
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
    }
    
    // MARK: CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            break;
        case .resetting:
            break;
        case .unsupported:
            break;
        case .unauthorized:
            break;
        case .poweredOff:
            ProgressHUD.banner("tip", "need open blue tooth.", delay: 2.0)
            break;
            
        case .poweredOn:
            self.scanBlueToothDevices()
            break;
            
        @unknown default:
            break;
        }
    }
    
    // 扫描时调用，需要将已发现的设备信息保留下来
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (peripheral.name != nil) {
            NSLog("peripheral: %@ , advertisementData: %@, rssi: %@", peripheral, advertisementData, RSSI)
            //peripheral.identifier;
            if (self.delegate != nil) {
                let msg = BlueToothDeviceMessage(peripheral: peripheral, advertisementData: advertisementData)
                self.delegate?.didDiscover(name: peripheral.name!, message: msg)
            }
//            let msg = BlueToothDeviceMessage(peripheral: peripheral, advertisementData: advertisementData);
        }
    }
    
    /// 连接成功
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if (self.peripheral != nil) {
            ProgressHUD.banner(String(format: "已经连接了 %@", self.peripheral?.name ?? ""), "", delay: 3.0)
            return;
        }
        self.peripheral = peripheral;
        peripheral.delegate = self;
        ProgressHUD.banner(String(format: "连接成功 %@", peripheral.name ?? ""), "", delay: 3.0)
        // 查找所有服务
        peripheral.discoverServices(nil)
        NSLog("didConnect peripheral: %@", peripheral)
    }
    
    /// 连接失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        NSLog("didFailToConnect")
        ProgressHUD.banner(String(format: "连接失败 %@", peripheral.name ?? ""), "", delay: 3.0)
    }
    
    /// 断开链接
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        NSLog("didDisconnectPeripheral")
        self.peripheral = nil;
        self.batteryLevel = -1; // 重置电量
        ProgressHUD.banner(String(format: "断开连接 %@",  peripheral.name ?? " "), "")
    }
    
    /// 断开链接，返回了时间戳、是否在重连后断开
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, timestamp: CFAbsoluteTime, isReconnecting: Bool, error: (any Error)?) {
//        NSLog("didDisconnectPeripheral timestamp")
//        ProgressHUD.banner(String(format: "断开连接 %@", peripheral.name ?? ""), "", delay: 3.0)
//        self.peripheral = nil;
//        self.batteryLevel = -1; // 重置电量
//    }
    
    // 蓝牙在后台被杀掉时，重连之后会首先调用此方法，可以获取蓝牙恢复时的各种状态
//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//
//    }
    
    //MARK: CBPeripheralDelegate
    
    //发现服务的回调
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        if error == nil, let services = peripheral.services, services.count > 0 {
            ProgressHUD.banner("发现了服务", "", delay: 2.0)
            for service in services {
                NSLog("发现服务: %@", service)
                
                // 检查是否是电池服务
                if service.uuid == batteryServiceUUID {
                    NSLog("发现电池服务")
                    // 发现电池服务的特征
                    peripheral.discoverCharacteristics([batteryLevelCharacteristicUUID], for: service)
                } else {
                    // 发现其他服务的特征
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        } else {
            ProgressHUD.banner(String(format: "发现服务异常：%@", error?.localizedDescription ?? ""), "", delay: 2.0)
        }
    }
    
    //发现特征的回调
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        if error == nil, let characteristics = service.characteristics, characteristics.count > 0 {
            for characteristic in characteristics {
                NSLog("发现特征: %@", characteristic)
                
                // 检查是否是电池电量特征
                if characteristic.uuid == batteryLevelCharacteristicUUID {
                    NSLog("发现电池电量特征")
                    // 读取电池电量
                    peripheral.readValue(for: characteristic)
                    
                    // 订阅电池电量变化通知（如果特征支持通知）
                    if characteristic.properties.contains(.notify) {
                        peripheral.setNotifyValue(true, for: characteristic)
                    }
                }
            }
        } else {
            NSLog("发现特征异常: %@", error?.localizedDescription ?? "")
        }
    }
    
    //读数据的回调
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        if error == nil {
            // 检查是否是电池电量特征
            if characteristic.uuid == batteryLevelCharacteristicUUID, let data = characteristic.value {
                // 解析电池电量数据（通常是一个字节，表示0-100的百分比）
                if data.count > 0 {
                    let batteryLevel = Int(data[0])
                    self.batteryLevel = batteryLevel
                    NSLog("电池电量: %d%%", batteryLevel)
                    
                    // 通知代理电量更新
                    self.delegate?.didUpdateBatteryLevel(level: batteryLevel)
                    
                    // 显示电量信息
                    ProgressHUD.banner(String(format: "设备电量: %d%%", batteryLevel), "", delay: 2.0)
                }
            }
        } else {
            NSLog("读取特征值异常: %@", error?.localizedDescription ?? "")
        }
    }
    
    //是否写入成功的回调
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        
    }

    
    
    // MARK: public methods
    /// 扫描蓝牙设备
    func scanBlueToothDevices() {
        let dict :[String: Any] = [
            // 不重复扫描已发现设备
            CBCentralManagerScanOptionAllowDuplicatesKey : false,
            // 蓝牙不打开时打开提示框
            CBCentralManagerOptionShowPowerAlertKey : true
        ];
        self.centralManager?.scanForPeripherals(withServices: nil, options: dict)
    }
    
    /// 链接到指定的蓝牙外设
    func connectBlueToothDevice(_ msg : BlueToothDeviceMessage) {
        // 如果已经连接了设备，先断开连接
//        self.centralManager?.cancelPeripheralConnection(existingPeripheral)
//        // 等待断开连接的回调完成后再连接新设备
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.centralManager?.connect(msg.peripheral)
//        }
        if self.peripheral != nil {
            let name = self.peripheral?.name ?? "";
            ProgressHUD.banner("已经链接了"+name, nil);
            return
        }
        self.centralManager?.connect(msg.peripheral)
    }
    
    /// 获取当前连接设备的电量
    func getBatteryLevel() -> Int {
        return self.batteryLevel
    }
    
    /// 主动读取电池电量
    func readBatteryLevel() {
        guard let peripheral = self.peripheral else {
            NSLog("没有连接的设备")
            return
        }
        
        // 如果已经发现了服务，尝试找到电池服务
        if let services = peripheral.services {
            for service in services {
                if service.uuid == batteryServiceUUID, let characteristics = service.characteristics {
                    for characteristic in characteristics {
                        if characteristic.uuid == batteryLevelCharacteristicUUID {
                            peripheral.readValue(for: characteristic)
                            return
                        }
                    }
                }
            }
        }
        
        // 如果没有找到电池服务，重新发现服务
        peripheral.discoverServices([batteryServiceUUID])
    }
}
