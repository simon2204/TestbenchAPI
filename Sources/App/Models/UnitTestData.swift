//
//  UnitTestData.swift
//  
//
//  Created by Simon Schöpke on 28.04.21.
//

import Vapor

struct UnitTestData: Content {
    let testName: String
    let files: [File]
}
