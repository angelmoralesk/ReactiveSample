//
//  ImageCollectionViewController.swift
//  ReactiveSample
//
//  Created by Angel Jesse Morales Karam Kairuz on 04/01/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ImageCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfImageCollectionInfo>(configureCell: { _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
            cell.item = item
            return cell
        })
   
    let sections = [
        SectionOfImageCollectionInfo(header: "Encabezado", items: [ImageCollectionInfo(name: "RxSwift", imageName: "Rx_Logo_M")])

        
        ]
    Observable.just(sections)
        .bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }


}
