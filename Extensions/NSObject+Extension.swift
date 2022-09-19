//
//  NSObject+Extension.swift
//  RepoGitSearch
//
//  Created by WildBoar on 13.09.2022.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: Self.self)
    }
}
