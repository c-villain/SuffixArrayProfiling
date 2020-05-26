//
//  JobSheduler.swift
//  DataStructuresProfiling
//
//  Created by Alexander Kraev on 26.05.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import Foundation

import Foundation

enum JobState{
    case wait
    case runing
    case finished
}

class JobSheduler {
    var timeOfWork: Double?
    
    init(){
        complitionHandler = { }
    }
    
    private var state: JobState = .wait
    private var complitionHandler: ()->()
    
    var jobs = [Job]()
    
    func addJobQueue(queue: JobQueue, nameQueue: String){
        self.jobs.append(Job(jobQueue: queue, nameQueue: nameQueue))
        if state == .finished {
            state = .wait
        }
    }
    
    private func setFinished(){
        var allJobsFinished = true
        for job in jobs {
            if job.state != .finished {
                allJobsFinished = false
            }
        }
       
        if allJobsFinished {
            self.state = JobState.finished
            DispatchQueue.main.async {
                self.complitionHandler()
            }
        }
    }
    
    func getResult() -> [String : Double]? {
        if state == .finished{
            let _maxTime = jobs.map({$0.getWorkTime()}).max()
            self.timeOfWork = _maxTime
            if let maxTime = _maxTime {
                guard maxTime != 0 else {return nil}
            
                var dict = [String : Double]()
                for j in jobs{
                    dict[j.nameQueue] = (j.getWorkTime() / maxTime)
                }
                return dict
            }else {
                return nil
            }
        }
        return nil
    }
    
    func start(complitionHandler: @escaping ()->()){
        self.complitionHandler = complitionHandler
        for jobQueue in jobs {
            if jobQueue.state == .wait {
                jobQueue.state = .runing
                
                jobQueue.jobQueue.run(){
                    result in
                    switch result {
                    case .success(let workTime):
                        jobQueue.state = .finished
                        jobQueue.workTime = workTime as? TimeInterval
                    case .failure(_):
                        jobQueue.state = .finished
                        jobQueue.workTime = 0
                    }
                    self.setFinished()
                }
            }
        }
    }
}
