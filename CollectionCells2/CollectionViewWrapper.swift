//
//  CollectionViewWrapper.swift
//  CollectionCells2
//
//  Created by Matt Fenwick on 2/18/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import RxCocoa

private let cellReuseIdentifier = "CollectionViewWrapperCell"

class CollectionViewWrapper {
    let collectionView: UICollectionView
    private let sections: Driver<[AnimatableSectionModel<String, CellModel>]>
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, CellModel>>()
    private let disposeBag = DisposeBag()
    private let tapSubject = PublishSubject<CellModel>()
    lazy private (set) var tap: Observable<CellModel> = {
        return self.tapSubject.asObservable()
    }()

    init(collectionView: UICollectionView,
         itemsDriver: Driver<[CellModel]>) {
        self.collectionView = collectionView
        sections = itemsDriver.map { items in [AnimatableSectionModel(model: "", items: items)] }
        collectionView.register(UINib(nibName: "Cell", bundle: Bundle(for: Cell.self)),
                                forCellWithReuseIdentifier: cellReuseIdentifier)
        dataSource.configureCell = configureCell
        sections.drive(collectionView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }

    private func configureCell(dataSource: CollectionViewSectionedDataSource<AnimatableSectionModel<String, CellModel>>,
                               collectionView: UICollectionView,
                               indexPath: IndexPath,
                               item: CellModel) -> Cell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! Cell
        cell.myLabel.text = item.text
        cell.myButton.rx.tap.map { _ in
                print("cell ip it: \(cell) \(indexPath) \(item)")
                return item
            }
            .subscribe(onNext: tapSubject.onNext)
            .addDisposableTo(cell.disposeBag)
        return cell
    }
}
