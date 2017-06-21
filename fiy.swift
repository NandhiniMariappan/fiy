//
//  fiy.swift
//  fiy
//
//  Created by Deepak on 02/06/2016 A.
//  Copyright © 2017 Adyog. All rights reserved.
//

import Foundation


public class fiy{
    
    private var isDebug: Bool!
    public let currentLocale = Locale.current
    public var ipAddress:String!
    
     //2.
    
    public init(){
        print("Class has been initialised")
        NSSetUncaughtExceptionHandler { exception in
            print("exception",exception)
            print("exception exception",exception.callStackSymbols)
        }
    }
    public func doSomething(){
        print("Yeah, it works")
    }
    public func appCurrentVersion() -> String{
        let infoDictionary:[String:Any] = Bundle.main.infoDictionary!
        let appCurrentVersion = infoDictionary["CFBundleShortVersionString"] as! String
        return appCurrentVersion
    }
    public func systemOS(){
        print(UIDevice.current.systemVersion)
    }
    public func deviceModel(){
        print(UIDevice.current.model)
    }
    public func deviceName(){
        print(UIDevice.current.name)
    }
    public func deviceType() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let str = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        let deviceModel = str
        return deviceModel
    }
    public func deviceUUID() -> String{
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        return uuid!
    }
    public func deviceBatteryPercentage() -> String{
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batterylabel = ((UIDevice.current.batteryLevel)*100)
        let batteryPerCentage = String(Int(batterylabel)) + "%"
     return batteryPerCentage
    }
    public func deviceBatteryState() -> String{
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batterstate:String!
        switch UIDevice.current.batteryState {
        case .unknown:
            batterstate = "unknown"
            break
        case .unplugged:
            batterstate = "unplugged"
            break
        case .charging:
            batterstate = "charging"
            break
        case .full:
            batterstate = "full"
            break
        }
        return batterstate
    }
    public func deviceCountry() -> String{
        let countryCode = currentLocale.regionCode
        let countryName = currentLocale.localizedString(forRegionCode: countryCode!)!
        return countryName
    }
    public func deviceLanguage() -> String{
        let languagecode = currentLocale.languageCode
        let language = currentLocale.localizedString(forLanguageCode: languagecode!)
        return language!
    }
    public func getipAddress() -> String{
        
        return getIPAddress()
    }
    public func report_memory() -> Double{
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            print("Memory used in bytes: \(taskInfo.resident_size)")
            return Double(taskInfo.resident_size)
        }
        else {
            print("Error with task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
            return 0.0
        }
        
    }

    public func getIPAddress() -> String{
        
             
        guard let ipServiceURL = NSURL(string: "http://www.dyndns.org/cgi-bin/check_ip.cgi") else {
            return ""
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: ipServiceURL as URL, completionHandler: {(data, response, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            let ipHTML = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
            
            self.ipAddress = self.scanForIPAddress(ipHTML: ipHTML)
            
        })
        
        task.resume()
        return ipAddress
    }
    
    public func scanForIPAddress( ipHTML:String?) -> String? {
        
        var ipHTML = ipHTML
        if ipHTML == nil {
            return nil
        }
        
        var externalIPAddress:String?
        var index:Int?
        var ipItems:[String]?
        var text:NSString?
        
        let scanner = Scanner(string: ipHTML!)
        
        while scanner.isAtEnd == false {
            scanner.scanUpTo("<", into: nil)
            
            scanner.scanUpTo(">", into: &text)
            
            ipHTML = ipHTML!.replacingOccurrences(of: String(text!) + ">", with:  " ")
            ipItems = ipHTML!.components(separatedBy: " ")
            
            index = ipItems!.index(of: "Address:")
            
            index = index! + 1
            externalIPAddress = ipItems![index!]
            
        }
        
//        if let ip = externalIPAddress {
//            print("External IP Address: \(ip)")
//            //externalIp = ip
//        }
        
        return externalIPAddress
        
    }

    }
