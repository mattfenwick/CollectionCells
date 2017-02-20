//
//  Cell.swift
//  CollectionCells2
//
//  Created by Matt Fenwick on 2/18/17.
//  Copyright © 2017 mf. All rights reserved.
//

import UIKit
import RxSwift

class Cell: UICollectionViewCell {

    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myLabel: UILabel!

    private (set) var disposeBag: DisposeBag = DisposeBag()

    override func prepareForReuse() {
        print("prepare for reuse -- \(self)")
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}
