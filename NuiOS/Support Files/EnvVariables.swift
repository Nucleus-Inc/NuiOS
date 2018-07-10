//EnvVariables.swift

import Foundation

struct EnvVariables{

    #if DEBUG
    //Your variables on DEBUG mode
    static let serverAddress = "http://dev.com"
    #else
    //Your variables on RELEASE mode
    static let serverAddress = "http://production.com"
    #endif

}
