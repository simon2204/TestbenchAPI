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
    
    func getAllAvailableTestNames(_ req: Request) throws -> EventLoopFuture<[String]> {
        return req.application.threadPool.runIfActive(eventLoop: req.eventLoop) {
            let testConfigurations = Testbench.findAllTestConfigurations()
            return testConfigurations.map(\.name)
        }
    }
}
