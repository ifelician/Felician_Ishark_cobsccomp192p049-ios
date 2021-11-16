//
//  SessionManager.swift
//  Felician_Ishark_cobsccomp192p049
//
//  Created by Felician Ishark on 2021-11-14.
//

import Foundation

class SessionManager {
    
    func getLoggedState() -> Bool {
        return UserDefaults.standard.bool(forKey: "USER_LOGGED")
    }
    
    
//    func saveUserLogin(user: User){
//        UserDefaults.standard.setValue(true, forKey: "USER_LOGGED")
//        UserDefaults.standard.setValue(user.Name, forKey: "NAME")
//        UserDefaults.standard.setValue(user.Email, forKey: "EMAIL")
//        UserDefaults.standard.setValue(user.NIC, forKey: "NIC")
//        UserDefaults.standard.setValue(user.VehicleNo, forKey: "VEHICLENO")
//        UserDefaults.standard.setValue(user.RegNo, forKey: "REGNO")
//
//    }
    
//    func getUserDetails() -> User {
//
//        let user = User(
//            Name: UserDefaults.standard.string(forKey: "NAME") ?? "",
//            Email: UserDefaults.standard.string(forKey: "EMAIL") ?? "",
//            Password: "",
//            NIC: UserDefaults.standard.string(forKey: "NIC") ?? "",
//            VehicleNo: UserDefaults.standard.string(forKey: "VEHICLENO") ?? "",
//            RegNo: UserDefaults.standard.string(forKey: "REGNO") ?? "")
//
//        return user
//    }
    
    func clearUserLoggedState() {
        
        UserDefaults.standard.setValue(false, forKey: "USER_LOGGED")
        
    }
}

