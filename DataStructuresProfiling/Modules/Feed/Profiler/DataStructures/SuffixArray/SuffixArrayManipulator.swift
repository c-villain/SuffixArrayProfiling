//
//  SuffixArrayManipulator.swift
//  DataStructuresProfiling
//
//  Created by Alexander Kraev on 29.04.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import Foundation

/**
 * A protocol which will allow the easy swapping out of dictionary subtypes
 */
protocol SuffixArrayManipulator {
    func suffixArrayHasEntries() -> Bool
    func createAlgoSuffixArray(_ countOfRequiredSeq: Int) -> TimeInterval
    func sortAlgoSuffixArray() -> TimeInterval
    func lookupBy10RandThreeLettersSeq() -> TimeInterval
    func lookupForRequiredSubstrings() -> TimeInterval
}
