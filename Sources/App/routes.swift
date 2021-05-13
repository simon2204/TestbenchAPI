import Vapor
import Testbench

func routes(_ app: Application) throws {
    
    // setup the upload handler
    let fileUploadController = FileUploadController(app: app)
    try app.register(collection: fileUploadController)
    
    let availableTestsController = AvailableTestsController(app: app)
    try app.register(collection: availableTestsController)
}
