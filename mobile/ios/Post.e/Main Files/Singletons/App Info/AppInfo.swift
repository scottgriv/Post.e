//
//  AppInfo.swift
//  Post.e
//
//  Created by Scott Grivner on 8/14/22.
//

import Foundation

struct AppInfo {

var appName : String {
    return readFromInfoPlist(withKey: "CFBundleName") ?? "(unknown app name)"
}

var version : String {
    return readFromInfoPlist(withKey: "CFBundleShortVersionString") ?? "(unknown app version)"
}

var build : String {
    return readFromInfoPlist(withKey: "CFBundleVersion") ?? "(unknown build number)"
}

var minimumOSVersion : String {
    return readFromInfoPlist(withKey: "MinimumOSVersion") ?? "(unknown minimum OSVersion)"
}

var copyrightNotice : String {
    return readFromInfoPlist(withKey: "NSHumanReadableCopyright") ?? "(unknown copyright notice)"
}

var bundleIdentifier : String {
    return readFromInfoPlist(withKey: "CFBundleIdentifier") ?? "(unknown bundle identifier)"
}

var aboutDeveloper : String { return "Scott Grivner" }

var aboutContactEmail : String { return "scott.grivner@gmail.com" }
    
var aboutContactWebsite : String { return "scottgrivner.dev" }

var currentYear : String {
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    let year = dateFormatter.string(from: now)
    
    return year
}
    
// lets hold a reference to the Info.plist of the app as Dictionary
private let infoPlistDictionary = Bundle.main.infoDictionary

/// Retrieves and returns associated values (of Type String) from info.Plist of the app.
private func readFromInfoPlist(withKey key: String) -> String? {
    return infoPlistDictionary?[key] as? String
     }
}
