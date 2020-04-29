//
//  SuffixSequence.swift
//  DataStructuresProfiling
//
//  Created by Alexander Kraev on 29.04.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import Foundation

struct SuffixSequence: Sequence {
    
    let string: String
    
    func makeIterator() -> SuffixIterator{
        return SuffixIterator(string: string)
    }
}
