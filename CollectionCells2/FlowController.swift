//
//  FlowController.swift
//  CollectionCells2
//
//  Created by Matt Fenwick on 2/18/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class FlowController {
    let viewController: RootViewController
    private let presenter: RootPresenter
    private let disposeBag = DisposeBag()

    private let didTapItemSubject = PublishSubject<(CellAction, CellModel)>()
    private lazy var didTapItem: Observable<(CellAction, CellModel)> = {
        return self.didTapItemSubject.asObservable()
    }()

    init() {
        let items = [
            CellModel(text: "abc"),
            CellModel(text: "def"),
            CellModel(text: "ghi"),
            CellModel(text: "jkl"),
            CellModel(text: "mno"),
            CellModel(text: "pqr"),
        ]

        presenter = RootPresenter(items: items, actions: didTapItemSubject.asObservable())
        viewController = RootViewController(addedModels: presenter.added, removedModels: presenter.removed)

        viewController.didTapItem
            .subscribe(didTapItemSubject)
            .addDisposableTo(disposeBag)
    }
}
