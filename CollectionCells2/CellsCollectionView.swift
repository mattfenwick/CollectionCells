//
//  CellsCollectionView.swift
//  CollectionCells2
//
//  Created by Matt Fenwick on 2/18/17.
//  Copyright © 2017 mf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CellsCollectionView: UICollectionView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }

    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
}
