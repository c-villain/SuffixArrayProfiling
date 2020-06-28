//
//  TaskQueue.swift
//  DataStructuresProfiling
//
//  Created by Alexander Kraev on 23.06.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import Foundation

final class TaskSheduler{
    private(set) var queue: DispatchQueue
    
    typealias Action = () -> ()
    private(set) var tasks: [Task] = [Task]()
    
    typealias Complition = () -> ()
    private var complitionHandler: Complition
    
    private(set) var semaphore: DispatchSemaphore
    private var state: TaskState
    
    init(nameQueue: String = "", qos: DispatchQoS = .default, numberOfExecutedTasks: Int = 1){
        if (nameQueue.isEmpty){
            //Global concurrent queue
            self.queue = DispatchQueue.global(qos: qos.qosClass)
        }
        else{
            //Private concurrent queue
            self.queue = DispatchQueue(label: nameQueue, qos: qos, attributes: .concurrent)
        }
        
        self.semaphore = DispatchSemaphore(value: numberOfExecutedTasks)
        self.state = .wait
        complitionHandler = { }
    }
    
    func getResult() -> [String : Double]? {
        if state == .finished{
            var dict = [String : Double]()
            for t in tasks{
                dict[t.taskName] = t.getWorkTime()
            }
            return dict
        }else {
            return nil
        }
    }
    
    private func setFinished(){
        var allTasksFinished = true
        for t in tasks {
            if t.taskState != .finished {
                allTasksFinished = false
            }
        }
       
        if allTasksFinished {
            self.state = TaskState.finished
            DispatchQueue.main.async {
                self.complitionHandler()
            }
        }
    }
    
    func addAction(task: Task){
        self.tasks.append(task)
    }
    
    func start(complitionHandler: @escaping Complition){
        guard self.tasks.count > 0 else {return}
        self.complitionHandler = complitionHandler
        for task in self.tasks{
            self.queue.async {
                task.run(){
                    self.setFinished()
                }
                self.semaphore.signal()
            }
            self.semaphore.wait()
        }
    }
}
