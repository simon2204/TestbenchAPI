//
//  FileUploadController.swift
//  
//
//  Created by Simon Schöpke on 28.04.21.
//

import Vapor
import TestbenchLib

struct FileUploadController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let availableTestsRoute = routes.grouped("api", "upload")
        availableTestsRoute.post(use: uploadHandler)
    }
    
    func uploadHandler(_ req: Request) throws -> EventLoopFuture<TestResult> {
        let unitTestData = try req.content.decode(UnitTestData.self)
        
        let future = unitTestData.files.map { file -> EventLoopFuture<Void> in
            let path = req.application.directory.publicDirectory + file.filename
            return req.fileio.writeFile(file.data, at: path)
        }
        
        return future.flatten(on: req.eventLoop).flatMap {
            return performTests(assignmentName: unitTestData.testName, req)
        }
    }
    
    func performTests(assignmentName: String, _ req: Request) -> EventLoopFuture<TestResult> {
        return req.application.threadPool.runIfActive(eventLoop: req.eventLoop) {
            let testResult = Testbench.performTestsForSubmission(at: "/Users/Simon/Desktop/TestbenchDirectories/submission", forAssignmentWithName: assignmentName)
            
            print(testResult!)
            
            return testResult!
        }
    }
}

extension TestResult: Content {}
