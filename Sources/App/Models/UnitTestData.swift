//
//  UnitTestData.swift
//  
//
//  Created by Simon Schöpke on 28.04.21.
//

import Vapor

struct UnitTestData: Content {
    let assignmentId: String
    let files: [File]
}

extension File {
    func writeFileToDirectory(_ directory: URL, request: Request) -> EventLoopFuture<Void> {
        let path = directory
            .appendingPathComponent(self.filename)
            .path
        
        return request.fileio.writeFile(self.data, at: path)
    }
}
