//
//  RootPresenter.swift
//  CollectionCells2
//
//  Created by Matt Fenwick on 2/20/17.
//  Copyright © 2017 mf. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

private extension Dictionary {
    init(elements: [(Key, Value)]) {
        self.init()
        for (key, value) in elements {
            updateValue(value, forKey: key)
        }
    }
}

class RootPresenter {

    let added: Driver<[CellModel]>
    let removed: Driver<[CellModel]>

    private let disposeBag = DisposeBag()

    init(items: [CellModel], actions: Observable<(CellAction, CellModel)>) {
        let initialModels: [CellModel : Bool] = Dictionary(elements: items.map { item in (item, false) })
        let selectedModels = actions.scan(initialModels,
            accumulator: { (models, tuple) in
                let added: Bool
                switch tuple.0 {
                case .add:
                    added = true
                case .remove:
                    added = false
                }
                var modelsCopy = models
                modelsCopy[tuple.1] = added
                return modelsCopy
            })
            .startWith(initialModels)
            .asDriver(onErrorRecover: { error in fatalError("something unexpected happened: \(error)") })
        
        // TODO should sort
        added = selectedModels.map { models in
            return models
                .filter { (tuple) -> Bool in tuple.value }
                .map { (tuple) in tuple.key }
                .sorted(by: { (a, b) in a.text < b.text })
        }
        removed = selectedModels.map { models in
            return models
                .filter { (tuple) -> Bool in !tuple.value }
                .map { (tuple) in tuple.key }
                .sorted(by: { (a, b) in a.text < b.text })
        }
    }
}
