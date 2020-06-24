//
//  Task.swift
//  DataStructuresProfiling
//
//  Created by Alexander Kraev on 23.06.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import Foundation

enum TaskState{
    case wait
    case running
    case finished
}

class Task{
    
    private(set) var taskName: String
    private(set) var taskQueue: TaskSheduler
    var taskState: TaskState
    var workTime: TimeInterval?
    typealias Action = () -> ()
    private(set) var task: Action
    
    typealias TaskComplition = () -> ()
    
    init(taskName: String, taskQueue: TaskSheduler, state: TaskState = .wait, task: @escaping Action) {
        self.taskName = taskName
        self.taskQueue = taskQueue
        self.taskState = state
        self.task = task
    }
    
    open func getWorkTime()-> Double{
        var result = 0.0
        if self.workTime != nil{
            result = Double(self.workTime!)
        }
        return result
    }
    
    func run(taskComlitionHandler: @escaping TaskComplition){
        taskQueue.queue.async { [weak self] in
            
            guard let self = self else { return }
            
            self.taskState = .running
        
            let startDate = Date()
            self.task()
            let endDate = Date()
            self.workTime = endDate.timeIntervalSince(startDate)
            self.taskState = .finished
            taskComlitionHandler()
            
            self.taskQueue.semaphore.signal()
        }
        taskQueue.semaphore.wait()
    }
}
