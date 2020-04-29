//
//  SuffixIterator.swift
//  DataStructuresProfiling
//
//  Created by Alexander Kraev on 29.04.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//

import Foundation

struct SuffixIterator : IteratorProtocol{
    
    //state:
    let string: String
    var last : String.Index
    var offset: String.Index
    
    init(string: String) {
        self.string = string
        self.last = string.endIndex
        self.offset = string.startIndex
    }
    
    mutating func next() -> Substring?{
        guard offset < last else { return nil }
        let sub: Substring = string[offset..<last]
        string.formIndex(after: &offset)
        return sub
    }
}
