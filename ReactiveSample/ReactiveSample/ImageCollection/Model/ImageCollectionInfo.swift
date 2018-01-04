//
//  ImageCollectionInfo.swift
//  ReactiveSample
//
//  Created by Angel Jesse Morales Karam Kairuz on 04/01/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import Foundation
import RxDataSources

struct ImageCollectionInfo {
    var name : String
    var imageName : String
}

struct SectionOfImageCollectionInfo {
    var header: String
    var items: [Item]
}

extension SectionOfImageCollectionInfo: SectionModelType {
    typealias Item = ImageCollectionInfo
    
    init(original: SectionOfImageCollectionInfo, items: [Item]) {
        self = original
        self.items = items
    }
}
