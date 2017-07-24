//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Andrei Sadovnicov on 17/10/15.
//  Copyright © 2015 SEFdevelopment. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    // MARK: - PROPERTIES
    var filePathUrl: URL!
    var title: String!
    
    
    // MARK: - INITIALIZERS
    init(filePathUrl: URL!, title: String!) {
        
        self.filePathUrl = filePathUrl
        self.title = title
        
    }
    
}
