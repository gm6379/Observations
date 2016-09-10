//
//  MakeObservationOperation.swift
//  Observations
//
//  Created by George McDonnell on 04/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class MakeObservationOperation: NSOperation {
    
    let observation: Observation
    
    var successBlock: (() -> Void)?
    var failureBlock: (() -> Void)?
    
    init(observation: Observation) {
        self.observation = observation
    }
    
    override func main() {
        NetworkController.sharedInstance.makeObservation(observation, success: { () -> Void in
            self.successBlock!()
            }) { () -> Void in
                self.failureBlock!()
        }
    }

}
