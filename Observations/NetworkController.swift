//
//  NetworkController.swift
//  Observations
//
//  Created by George McDonnell on 03/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class NetworkController: NSObject {
    
    static let sharedInstance = NetworkController()
    let baseURL = "http://sots.brookes.ac.uk/~p0073862/services/obs/"
    
    var success: (() -> Void)?
    var failure: (() -> Void)?
    
    var operationQueue: NSOperationQueue?
    var observationOperations: [MakeObservationOperation]?
    var operationsSuccessful: Int = 0
    var operationsCompleted: Int = 0 {
        didSet {
            if (operationsCompleted == observationOperations?.count) {
                if (operationsSuccessful == operationsCompleted) {
                    success!()
                    operationsCompleted = 0
                } else {
                    failure!()
                    operationsCompleted = 0
                }
            }
        }
    }
    
    func registerWithUsername(username: String, name: String, success: () -> Void, failure: () -> Void) {
        let registerURL = NSURL(string: baseURL + "register")!
        let registerRequest = NSMutableURLRequest(URL: registerURL)
        let body = "username=" + username + "&name=" + name
        registerRequest.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        registerRequest.HTTPMethod = "POST"
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue:NSOperationQueue.mainQueue())
        
        let task = session.dataTaskWithRequest(registerRequest) { (data, response, error) -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            if (httpResponse.statusCode == 200) {
                success()
            } else {
                failure()
            }
        }
        
        task.resume()
    }
    
    func makeObservations(observations: [Observation], success: () -> Void, failure: () -> Void) {
        self.success = success
        self.failure = failure
        
        operationQueue = NSOperationQueue()
        operationQueue!.maxConcurrentOperationCount = 1
        observationOperations = [MakeObservationOperation]()
        for observation in observations {
            let op = MakeObservationOperation(observation: observation)
            op.successBlock = {
                self.operationsSuccessful += 1
                self.operationsCompleted += 1
            }
            
            op.failureBlock = {
                self.operationsCompleted += 1
            }
            observationOperations!.append(op)
        }
        
        operationQueue?.addOperations(observationOperations!, waitUntilFinished: true)
    }
    
    func makeObservation(observation: Observation, success: () -> Void, failure: () -> Void) {
        makeObservationWithUsername(observation.username!, title: observation.title!, category: observation.category!, latitude: observation.latitude!, longitude: observation.longitude!, date: observation.date!, description: observation.oDescription!, success: { () -> Void in
                success()
            }) { () -> Void in
                failure()
        }
    }
    
    func makeObservationWithUsername(username: String, title: String, category: String, latitude: String, longitude: String, date: String, description: String, success: () -> Void, failure: () -> Void) {
        let observationURL = NSURL(string: baseURL + "observations")!
        let observationRequest = NSMutableURLRequest(URL: observationURL)
        let body = NSString(format: "username=%@&name=%@&description=%@&date=%@&latitude=%@&longitude=%@&category=%@", username, title, description, date, latitude, longitude, category)
        observationRequest.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        observationRequest.HTTPMethod = "POST"
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue:NSOperationQueue.mainQueue())
        
        let task = session.dataTaskWithRequest(observationRequest) { (data, response, error) -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            if (httpResponse.statusCode == 200) {
                success()
            } else {
                failure()
            }
        }
        
        task.resume()
    }
    
    func fetchAllObservations(completionHandler: ([UObservation]) -> (Void)) {
        let fetchURL = NSURL(string: baseURL + "observations")
        observationRequestWithURL(fetchURL!) { (observations) -> (Void) in
            completionHandler(observations)
        }
    }
    
    func fetchObservationsWithUsername(username: String, completionHandler: ([UObservation]) -> (Void)) {
        let fetchURL = NSURL(string: baseURL + "observations" + "/user/" + username)
        observationRequestWithURL(fetchURL!) { (observations) -> (Void) in
            completionHandler(observations)
        }
    }
    
    func fetchObservationsWithDate(date: String, completionHandler: ([UObservation]) -> (Void)) {
        let fetchURL = NSURL(string: baseURL + "observations" + "/since/" + date)
        observationRequestWithURL(fetchURL!) { (observations) -> (Void) in
            completionHandler(observations)
        }
    }
    
    func fetchObservationsWithCategory(category: String, completionHandler: ([UObservation]) -> (Void)) {
        let fetchURL = NSURL(string: baseURL + "observations" + "/category/" + category)
        observationRequestWithURL(fetchURL!) { (observations) -> (Void) in
            completionHandler(observations)
        }
    }
    
    func observationRequestWithURL(url: NSURL, completionHandler: ([UObservation]) -> (Void)) {
        let request = NSMutableURLRequest(URL: url)
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue:NSOperationQueue.mainQueue())
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            completionHandler(self.parseObservations(data!))
        }
        
        task.resume()
    }
    
    func parseObservations(data: NSData) -> [UObservation] {
        var observations = [UObservation]()
        let parser = XMLParser.init(data: data)
        parser.parse()
        let rootElement = parser.rootElement!
        for element in rootElement.subElements {
            let username = element.subElements[0].text
            let title = element.subElements[1].text
            let description = element.subElements[2].text
            let date = element.subElements[3].text
            let latitude = element.subElements[4].text
            let longitude = element.subElements[5].text
            let category = element.subElements[6].text
            
            let ob = UObservation(username: username, title: title, category: category, date: date, latitude: latitude, longitude: longitude, oDescription: description)
            observations.append(ob)
        }
        return observations
    }
}
