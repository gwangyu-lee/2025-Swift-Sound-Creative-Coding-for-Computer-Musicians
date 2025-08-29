//
//  OSCManager.swift
//  07
//
//  Created by Gwangyu Lee on 8/21/25.
//


import Foundation

var client = OSCClient(address: "localhost", port: 9900)

func setOSCClientIP(ip: String = UserDefaults.standard.string(forKey: "ipAddress") ?? "127.0.0.1", port: Int = Int(UserDefaults.standard.string(forKey: "port") ?? "8800") ?? 8800) {
    client = OSCClient(address: ip, port: port)
    print("osc client ip changed to \(ip):\(port)")
}

func sendOSCMessage(address: String, value: Any, ip: String = UserDefaults.standard.string(forKey: "ipAddress") ?? "127.0.0.1", port: Int = Int(UserDefaults.standard.string(forKey: "port") ?? "8800") ?? 8800) {
    
    let oscAddress = OSCAddressPattern(address)
    
    let oscValue: OSCType
    switch value {
    case let v as Float:
        oscValue = Float32(v)
    case let v as Float32:
        oscValue = v
    case let v as Double:
        oscValue = Float32(v) // Float32로 다운캐스팅
    case let v as String:
        oscValue = v
    case let v as Bool:
        oscValue = v
    default:
        print("❌ Unsupported OSC value type: \(type(of: value))")
        return
    }
    
    let message = OSCMessage(oscAddress, [oscValue])
    client.send(message)
}
