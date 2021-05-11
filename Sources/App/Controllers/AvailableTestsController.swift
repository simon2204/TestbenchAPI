//
//  AvailableTestsController.swift
//  
//
//  Created by Simon Schöpke on 26.04.21.
//

import Vapor
import Testbench

struct AvailableTestsController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let availableTestsRoute = routes.grouped("api", "available_tests")
        availableTestsRoute.get(use: getAllAvailableTestNames)
    }
    
    func getAllAvailableTestNames(_ req: Request) throws -> EventLoopFuture<[Assignment]> {
        let promise = req.eventLoop.makePromise(of: [Assignment].self)
        
        DispatchQueue.global(qos: .background).async {
            let testbench = Testbench(config: FileUploadController.config)
            do {
                let assignments = try testbench.availableAssignments()
                promise.succeed(assignments)
            } catch {
                promise.fail(error)
            }
        }
        
        return promise.futureResult
    }
}

extension Assignment: Content {}
