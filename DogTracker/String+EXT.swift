//
//  String+EXT.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/13/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

extension String {
    
    func checkForContents(of contents: String) -> Bool {
        let charset = CharacterSet(charactersIn: contents)
        if self.rangeOfCharacter(from: charset) != nil {
            return true
        }
        return false
    }
    
}
