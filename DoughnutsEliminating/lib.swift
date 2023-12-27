//
//  lib.swift
//  DoughnutsEliminating
//
//  Created by frozenfung on 2023/12/27.
//

import Foundation

func getStringValueFromPlist(forKey key: String) -> String {
    guard let fileURL = Bundle.main.url(forResource: "Keys.plist", withExtension: nil) else {
        fatalError("Can't find Keys.plist")
    }

    let contents = NSDictionary(contentsOf: fileURL) as? [String: String] ?? [:]

    return contents[key] ?? ""
}
