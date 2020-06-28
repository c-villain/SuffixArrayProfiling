//
//  Job.swift
//  DataStructuresProfiling
//
//  Created by Alexander Kraev on 26.05.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import Foundation

class Job {
    
    var nameQueue: String
    var jobQueue: JobQueue
    var state: JobState
    var workTime: TimeInterval?
    
    init(jobQueue: JobQueue, nameQueue: String){
        self.jobQueue = jobQueue
        self.nameQueue = nameQueue
        self.state = .wait
    }

    open func getWorkTime()-> Double{
        var result = 0.0
        if self.workTime != nil{
            result = Double(self.workTime!)
        }
        return result
    }
}
