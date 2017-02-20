//
//  RootViewController.swift
//  CollectionCells2
//
//  Created by Matt Fenwick on 2/18/17.
//  Copyright © 2017 mf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let cvReuseIdentifier = "CollectionViewCell"
private let addedReuseIdentifier = "AddTableViewCell"
private let removedReuseIdentifier = "RemoveTableViewCell"

class RootViewController: UIViewController {

    // MARK: boilerplate

    private let didTapItemSubject = PublishSubject<(CellAction, CellModel)>()

    // MARK: output

    lazy private (set) var didTapItem: Observable<(CellAction, CellModel)> = {
        return self.didTapItemSubject.asObservable()
    }()

    // MARK: ui elements

    @IBOutlet private weak var collectionView: CellsCollectionView!
    @IBOutlet private weak var addTableView: UITableView!
    @IBOutlet private weak var removeTableView: UITableView!

    // MARK: private

    private let disposeBag = DisposeBag()
    private let addedModels: Driver<[CellModel]>
    private let removedModels: Driver<[CellModel]>

    private let sections: Driver<[AnimatableSectionModel<String, CellModel>]>
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, CellModel>>()

    private let addSections: Driver<[AnimatableSectionModel<String, CellModel>]>
    private let addDataSource = RxTableViewSectionedReloadDataSource<AnimatableSectionModel<String, CellModel>>()

    private let removeSections: Driver<[AnimatableSectionModel<String, CellModel>]>
    private let removeDataSource = RxTableViewSectionedReloadDataSource<AnimatableSectionModel<String, CellModel>>()

    // MARK: init

    init(addedModels: Driver<[CellModel]>, removedModels: Driver<[CellModel]>) {
        self.addedModels = addedModels
        self.removedModels = removedModels

        sections = addedModels.map { items in [AnimatableSectionModel(model: "", items: items)] }

        addSections = addedModels.map { models in [AnimatableSectionModel(model: "", items: models)] }
        addDataSource.configureCell = RootViewController.configureAddCell

        removeSections = removedModels.map { models in [AnimatableSectionModel(model: "", items: models)] }
        removeDataSource.configureCell = RootViewController.configureRemoveCell

        super.init(nibName: "RootViewController", bundle: Bundle(for: RootViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "Cell", bundle: Bundle(for: Cell.self)),
                                forCellWithReuseIdentifier: cvReuseIdentifier)
        dataSource.configureCell = self.configureCollectionViewCell
        sections
            .drive(collectionView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)

        addTableView.register(UITableViewCell.self, forCellReuseIdentifier: addedReuseIdentifier)
        addSections
            .drive(addTableView.rx.items(dataSource: addDataSource))
            .addDisposableTo(disposeBag)

        removeTableView.register(UITableViewCell.self, forCellReuseIdentifier: removedReuseIdentifier)
        removeSections
            .drive(removeTableView.rx.items(dataSource: removeDataSource))
            .addDisposableTo(disposeBag)

        // boilerplate
        addTableView.rx.modelSelected(CellModel.self)
            .map { model in (CellAction.remove, model) }
            .subscribe(didTapItemSubject)
            .addDisposableTo(disposeBag)

        removeTableView.rx.modelSelected(CellModel.self)
            .map { model in (CellAction.add, model) }
            .subscribe(didTapItemSubject)
            .addDisposableTo(disposeBag)
    }

    private static func configureAddCell(dataSource: TableViewSectionedDataSource<AnimatableSectionModel<String, CellModel>>,
                                         tableView: UITableView,
                                         indexPath: IndexPath,
                                         item: CellModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: addedReuseIdentifier, for: indexPath)
        cell.textLabel?.text = item.text
        return cell
    }
    
    private static func configureRemoveCell(dataSource: TableViewSectionedDataSource<AnimatableSectionModel<String, CellModel>>,
                                            tableView: UITableView,
                                            indexPath: IndexPath,
                                            item: CellModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: removedReuseIdentifier, for: indexPath)
        cell.textLabel?.text = item.text
        return cell
    }

    private func configureCollectionViewCell(dataSource: CollectionViewSectionedDataSource<AnimatableSectionModel<String, CellModel>>,
                                             collectionView: UICollectionView,
                                             indexPath: IndexPath,
                                             item: CellModel) -> Cell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cvReuseIdentifier, for: indexPath) as! Cell
        cell.myLabel.text = item.text
        cell.myButton.rx.tap
            .map { _ in (CellAction.remove, item) }
            .subscribe(onNext: didTapItemSubject.onNext)
            .addDisposableTo(cell.disposeBag)
        return cell
    }

}
