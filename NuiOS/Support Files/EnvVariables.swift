//EnvVariables.swift

import Foundation

struct EnvVariables{
    
    #if DEBUG
    //Your variables on DEBUG mode
    static let serverAddress = "http://192.168.0.5:5000"
    #else
    //Your variables on RELEASE mode
    static let serverAddress = "http://production.com"
    #endif

    static let keychainServ = "com.eti.nucleus.NuiOS"
}
