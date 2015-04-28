//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Surajit A Bose on 12/8/14.
//  Copyright (c) 2014 Surajit A Bose. All rights reserved.
//

import Foundation

// RecordedAudio class to store the recorded file
// Does not need to inherit from NSObject
class RecordedAudio {
    
    var filePathUrl: NSURL!
    var title: String!

    //Constructor
    init (path: NSURL, title: String) {
        self.filePathUrl = path
        self.title = title
    }
    
}
