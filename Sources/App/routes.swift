import Vapor
import TestbenchLib

func routes(_ app: Application) throws {
    
    // setup the upload handler
    let fileUploadController = FileUploadController()
    try app.register(collection: fileUploadController)
    
    let availableTestsController = AvailableTestsController()
    try app.register(collection: availableTestsController)
}
