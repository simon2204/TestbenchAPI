//
//  FileUploadController.swift
//  
//
//  Created by Simon Schöpke on 28.04.21.
//

import Vapor
import Testbench

struct FileUploadController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let availableTestsRoute = routes.grouped("api", "upload")
        availableTestsRoute.post(use: uploadHandler)
    }
    
    func uploadHandler(_ request: Request) throws -> EventLoopFuture<TestResult> {
        let unitTestData = try request.content.decode(UnitTestData.self)
        let future = writeFilesToSubmissionDirectory(files: unitTestData.files, request: request)
        return future.flatMap {
            performTests(assignmentName: unitTestData.testName, request)
        }
    }
    
    func writeFilesToSubmissionDirectory(files: [File], request: Request) -> EventLoopFuture<Void> {
        let future = files.map { file -> EventLoopFuture<Void> in
            let path = request.application.directory.publicDirectory + file.filename
            return request.fileio.writeFile(file.data, at: path)
        }
        
        return future.flatten(on: request.eventLoop)
    }
    
    func performTests(assignmentName: String, _ request: Request) -> EventLoopFuture<TestResult> {
        return request.application.threadPool.runIfActive(eventLoop: request.eventLoop) {
            let testResult = Testbench.performTestsForSubmission(at: "/Users/Simon/Desktop/TestbenchDirectories/submission", forAssignmentWithName: assignmentName)
            
            print(testResult!)
            
            return testResult!
        }
    }
}

extension TestResult: Content {}
