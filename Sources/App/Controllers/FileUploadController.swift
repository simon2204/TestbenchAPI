//
//  FileUploadController.swift
//  
//
//  Created by Simon Schöpke on 28.04.21.
//

import Vapor
import Testbench

struct FileUploadController: RouteCollection {
    
    let app: Application
    
    var testbenchDirectory: URL {
        URL(fileURLWithPath: app.directory.resourcesDirectory)
    }
    
    var config: URL {
        testbenchDirectory.appendingPathComponent("config.json")
    }
    
    var submission: URL {
        testbenchDirectory.appendingPathComponent("submission")
    }
    
    func boot(routes: RoutesBuilder) throws {
        let availableTestsRoute = routes.grouped("api", "upload")
        availableTestsRoute.post(use: uploadHandler)
    }
    
    
    func uploadHandler(_ request: Request) throws -> EventLoopFuture<TestResult> {
        let unitTestData = try request.content.decode(UnitTestData.self)
        let directory = submission.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: false)
        
        let future = writeFilesToSubmissionDirectory(
            files: unitTestData.files,
            directory: directory,
            request: request)
        
        return future.flatMap {
            let id = Int(unitTestData.assignmentId) ?? 0
            return performTests(assignmentId: id, submission: directory, request)
        }
    }
    
    
    func writeFilesToSubmissionDirectory(
        files: [File],
        directory: URL,
        request: Request)
    -> EventLoopFuture<Void> {

        let future = files.map { file -> EventLoopFuture<Void> in
            file.writeFileToDirectory(directory, request: request)
        }
        
        return future.flatten(on: request.eventLoop)
    }
    
    
    func performTests(assignmentId: Int, submission: URL, _ request: Request) -> EventLoopFuture<TestResult> {
        let promise = request.eventLoop.makePromise(of: TestResult.self)
     
        DispatchQueue.global(qos: .background).async {
            let testbench = Testbench(config: config)
            
            do {
                let testResult = try testbench.performTests(
                    submission: submission,
                    assignment: assignmentId)
                promise.succeed(testResult)
            } catch {
                promise.fail(error)
            }
        }
        
        return promise.futureResult
    }
}

extension TestResult: Content {}
