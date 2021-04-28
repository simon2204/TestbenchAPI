//
//  FileUploadController.swift
//  
//
//  Created by Simon Schöpke on 28.04.21.
//

import Vapor

struct FileUploadController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let availableTestsRoute = routes.grouped("api", "upload")
        availableTestsRoute.post(use: uploadHandler)
    }
    
    func uploadHandler(_ req: Request) throws -> EventLoopFuture<String> {
        let unitTestData = try req.content.decode(UnitTestData.self)
        
        let future = unitTestData.files.map { file -> EventLoopFuture<Void> in
            let path = req.application.directory.publicDirectory + file.filename
            return req.fileio.writeFile(file.data, at: path)
        }
        
        return future.flatten(on: req.eventLoop).map {
            return "Hallo"
        }
    }
}
