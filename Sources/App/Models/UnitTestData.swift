//
//  UnitTestData.swift
//  
//
//  Created by Simon Schöpke on 28.04.21.
//

import Vapor

struct UnitTestData: Content {
    let testType: String
    let files: [File]
}
