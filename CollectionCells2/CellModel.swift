//
//  CellModel.swift
//  CollectionCells2
//
//  Created by Matt Fenwick on 2/18/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import RxDataSources

struct CellModel: IdentifiableType, Hashable, Equatable {
    let text: String

    public var hashValue: Int {
        return self.text.hashValue
    }

    typealias Identity = String
    var identity: String {
        return self.text
    }
}

func ==(left: CellModel, right: CellModel) -> Bool {
    return left.text == right.text
}
