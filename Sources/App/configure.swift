import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // set public directory to a custom one
    app.directory.publicDirectory = "/Users/Simon/Desktop/TestbenchDirectories/submission/"
    
    // enable file middleware
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // set max body size
    app.routes.defaultMaxBodySize = "10mb"

    // allows Ajax requests to access resources
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST],
        allowedHeaders: [.accept, .contentType, .origin, .xRequestedWith]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    
    let error = ErrorMiddleware.default(environment: app.environment)
    
    // clear any existing middleware
    app.middleware = .init()
    
    app.middleware.use(cors)
    app.middleware.use(error)
    
    // register routes
    try routes(app)
}
