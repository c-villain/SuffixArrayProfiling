//
//  SwiftSuffixArrayManipulator.swift
//  DataStructuresProfiling
//
//  Created by Alexander Kraev on 29.04.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import Foundation

open class SwiftSuffixArrayManipulator: SuffixArrayManipulator {
    
    var numOfThreeLettersStringsToFind: Int = 0
    
    var sufAlgoArray = [String]()
    
    func suffixArrayHasEntries() -> Bool{
        guard sufAlgoArray.count != 0 else {return false}
        return true
    }
        
    func createAlgoSuffixArray(_ countOfRequiredSeq: Int) -> TimeInterval{
        
        numOfThreeLettersStringsToFind = countOfRequiredSeq
        
        return Profiler.runClosureForTime(){
            for word in AlgoProvider().all {
                for suffix in SuffixSequence(string: word){
                    self.sufAlgoArray.append(String(suffix))
                }
            }
        }
    }
    
    func sortAlgoSuffixArray() -> TimeInterval{
        return Profiler.runClosureForTime(){
            self.sufAlgoArray.sort { $0 < $1 }
        }
    }
    
    func lookupBy10RandThreeLettersSeq() -> TimeInterval{
        var threeLettersSeqArray = [String]()
        
        for _ in 0...9 {
            threeLettersSeqArray.append(StringGenerator().generateRandomString(3))
        }
        
        return Profiler.runClosureForTime() {
            for threeLettersSeq in threeLettersSeqArray {
                self.sufAlgoArray.contains(threeLettersSeq)
            }
        }
    }
    
    func lookupForRequiredSubstrings() -> TimeInterval{
        var threeLettersSeqArray = [String]()
        
        for _ in 0...numOfThreeLettersStringsToFind {
            threeLettersSeqArray.append(StringGenerator().generateRandomString(3))
        }
        
        return Profiler.runClosureForTime() {
            for threeLettersSeq in threeLettersSeqArray {
                self.sufAlgoArray.contains(threeLettersSeq)
            }
        }
    }
}
