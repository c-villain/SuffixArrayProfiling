//
//  ConcurrentTaskViewController.swift
//  DataStructuresProfiling
//
//  Created by Alexander Kraev on 24.06.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//
import UIKit

private enum GCDVCRow: Int {
    case array = 0,
    set,
    dictionary,
    suffixArray
}

class ConcurrentTaskViewController: DataStructuresViewController {
    
    //MARK: - Variables
    
    let taskShedulerService: TaskSheduler = TaskSheduler()
    
    private var testResults: [String : Double]?
    private var testTime: Double?
    
    var arrayCreation: TimeInterval = 0
    var setCreation: TimeInterval = 0
    var dictionaryCreation: TimeInterval = 0
    var suffixArrayCreation: TimeInterval = 0
    
    //MARK: - Methods
    //MARK: View lifecycle
    override func viewDidLoad() {
        numberOfItems = 10_000 //default
        createAndTestButton.setTitle("Test", for: UIControl.State())
        testOnlyButton.isHidden = true
        super.viewDidLoad()
    }
    
    //MARK: Superclass creation/testing overrides
    
    override func create(_ size: Int) {
        let sheduler = TaskSheduler(numberOfExecutedTasks: 2)
        
        let arrayTask = Task(taskName: "Array", taskQueue: sheduler, task: {_ = SwiftArrayManipulator().setupWithObjectCount(size)})
        sheduler.addAction(task: arrayTask)
        
        let setTask = Task(taskName: "Set", taskQueue: sheduler, task: {_ = SwiftSetManipulator().setupWithObjectCount(size)})
        sheduler.addAction(task: setTask)

        let dictTask = Task(taskName: "Dictionary", taskQueue: sheduler, task: {_ = SwiftDictionaryManipulator().setupWithEntryCount(size)})
        sheduler.addAction(task: dictTask)

        let suffixArrayTask = Task(taskName: "SuffixArray", taskQueue: sheduler, task: {_ = SwiftSuffixArrayManipulator().createAlgoSuffixArray(size)})
        sheduler.addAction(task: suffixArrayTask)

        sheduler.start() {
            self.testResults = sheduler.getResult()
    
            self.arrayCreation = (self.testResults?["Array"] ?? 0)
            self.setCreation = (self.testResults?["Set"] ?? 0)
            self.dictionaryCreation = (self.testResults?["Dictionary"] ?? 0)
            self.suffixArrayCreation = (self.testResults?["SuffixArray"] ?? 0)
        
            DispatchQueue.main.async {
              //Update the UI on the main thread
              self.resultsTableView.reloadData()
            }
        }
    }
    
    //MARK: Table View Override
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //There are always 4 items
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        switch (indexPath as NSIndexPath).row {
        case GCDVCRow.array.rawValue:
            cell.textLabel!.text = "Array creation:"
            cell.detailTextLabel!.text = formattedTime(arrayCreation)
        case GCDVCRow.set.rawValue:
            cell.textLabel!.text = "Set creation :"
            cell.detailTextLabel!.text = formattedTime(setCreation)
        case GCDVCRow.dictionary.rawValue:
            cell.textLabel!.text = "Dictionary creation :"
            cell.detailTextLabel!.text = formattedTime(dictionaryCreation)
        case GCDVCRow.suffixArray.rawValue:
            cell.textLabel!.text = "Suffix array creation :"
            cell.detailTextLabel!.text = formattedTime(suffixArrayCreation)
        default:
            print("Unhandled row! \((indexPath as NSIndexPath).row)")
        }
        
        return cell
    }
    
}
