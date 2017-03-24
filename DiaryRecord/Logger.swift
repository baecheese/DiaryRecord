//
//  Logger.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 6..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import Foundation

public class Logger : NSObject {
    
    private let _logPlace:String
    
    public init(logPlace:AnyClass) {
        _logPlace = "\(logPlace)"
    }
    
    public func debug(message:Any...) {
        // 조건부 컴파일 블록
        #if DEBUG
            let log = format(logLevel:LogLevel.DEBUG, message: message)
            print(log)
        #elseif RELEASE
            //TODO log server에 전송
        #endif
    }
    
    public func info(message:Any...) {
        let log = format(logLevel:LogLevel.INFO, message: message)
        print(log)
    }
    
    public func warn(message:Any...) {
        let log = format(logLevel:LogLevel.WARN, message: message)
        print(log)
    }
    
    public func error(message:Any...) {
        let log = format(logLevel:LogLevel.ERROR, message: message)
        print(log)
    }
    
    private func format(logLevel:LogLevel, message:Any) -> String {
        return "\(NSDate.init()) [\(logLevel)] \(_logPlace) - \(message)"
    }
    
    enum LogLevel {
        case DEBUG;
        case INFO;
        case WARN;
        case ERROR;
    }
}
