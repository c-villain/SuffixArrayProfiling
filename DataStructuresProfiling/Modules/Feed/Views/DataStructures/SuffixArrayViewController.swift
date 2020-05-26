//
//  SuffixArrayViewController.swift
//  DataStructuresProfiling
//
//  Created by Alexander Kraev on 29.04.2020.
//  Copyright © 2020 Kraev Alexander. All rights reserved.
//


import UIKit

private enum SuffixArrayVCRow: Int {
    case creation = 0,
    sortArray,
    lookupBy10RandThreeLetters,
    lookupForRequiredSubstrings
}

class SuffixArrayViewController: DataStructuresViewController {

    //MARK: - Variables

    let suffixArrayManipulator: SuffixArrayManipulator = SwiftSuffixArrayManipulator()

    var creationTime: TimeInterval = 0
    var sortArrayTime: TimeInterval = 0
    var lookupBy10RandThreeLettersTime: TimeInterval = 0
    var lookupForRequiredSubstringsTime: TimeInterval = 0

    //MARK: - Methods
    //MARK: View lifecycle
    override func viewDidLoad() {
      super.viewDidLoad()
      createAndTestButton.setTitle("Create Suffix Array and Test", for: UIControl.State())
    }

    //MARK: Superclass creation/testing overrides

    override func create(_ size: Int) {
        creationTime = suffixArrayManipulator.createAlgoSuffixArray(size)
    }
    
    override func test() {
        if suffixArrayManipulator.suffixArrayHasEntries() {
            sortArrayTime = suffixArrayManipulator.sortAlgoSuffixArray()
            lookupBy10RandThreeLettersTime = suffixArrayManipulator.lookupBy10RandThreeLettersSeq()
            lookupForRequiredSubstringsTime = suffixArrayManipulator.lookupForRequiredSubstrings()
        } else {
            print("Suffix Array not yet set up!")
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
        case SuffixArrayVCRow.creation.rawValue:
            cell.textLabel!.text = "Creation:"
            cell.detailTextLabel!.text = formattedTime(creationTime)
        case SuffixArrayVCRow.sortArray.rawValue:
            cell.textLabel!.text = "Sorting:"
            cell.detailTextLabel!.text = formattedTime(sortArrayTime)
        case SuffixArrayVCRow.lookupBy10RandThreeLetters.rawValue:
            cell.textLabel!.text = "Finding by 10 rand 3-letter seq:"
            cell.detailTextLabel!.text = formattedTime(lookupBy10RandThreeLettersTime)
        case SuffixArrayVCRow.lookupForRequiredSubstrings.rawValue:
            cell.textLabel!.text = "Finding required count of seq:"
            cell.detailTextLabel!.text = formattedTime(lookupForRequiredSubstringsTime)
        default:
            print("Unhandled row! \((indexPath as NSIndexPath).row)")
        }

        return cell
    }

}
