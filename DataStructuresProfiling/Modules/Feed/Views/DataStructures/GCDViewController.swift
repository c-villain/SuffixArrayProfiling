//
//  GCDViewController.swift
//  DataStructuresProfiling
//
//  Created by Alexander Kraev on 26.05.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//
import UIKit

private enum GCDVCRow: Int {
    case array = 0,
    set,
    dictionary,
    suffixArray
}

class GCDViewController: DataStructuresViewController {
    
    //MARK: - Variables
    
    let jobShedulerService: JobSheduler = JobSheduler()
    
    private var testResult: [String : Double]?
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
        let sheduler = JobSheduler()
        
        let arrayJob = JobQueue(jobs: [{
            _ = SwiftArrayManipulator().setupWithObjectCount(size)
            }])
        sheduler.addJobQueue(queue: arrayJob, nameQueue: "Array")
        
        let setJob = JobQueue(jobs: [{
            _ = SwiftSetManipulator().setupWithObjectCount(size)
            }])
        
        sheduler.addJobQueue(queue: setJob, nameQueue: "Set")
        
        let dictionaryJob = JobQueue(jobs: [{
            _ = SwiftDictionaryManipulator().setupWithEntryCount(size)
            }])
        sheduler.addJobQueue(queue: dictionaryJob, nameQueue: "Dictionary")
        
        let sufArrayJob = JobQueue(jobs: [{
            _ = SwiftSuffixArrayManipulator().createAlgoSuffixArray(size)
            }])
        sheduler.addJobQueue(queue: sufArrayJob, nameQueue: "SuffixArray")
            
        
        sheduler.start() {
            self.testResult = sheduler.getResult()
            
            self.testTime = sheduler.timeOfWork
            
            self.arrayCreation = (self.testTime ?? 0) * (self.testResult?["Array"] ?? 0)
            self.setCreation = (self.testTime ?? 0) * (self.testResult?["Set"] ?? 0)
            self.dictionaryCreation = (self.testTime ?? 0) * (self.testResult?["Dictionary"] ?? 0)
            self.suffixArrayCreation = (self.testTime ?? 0) * (self.testResult?["SuffixArray"] ?? 0)
        
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
