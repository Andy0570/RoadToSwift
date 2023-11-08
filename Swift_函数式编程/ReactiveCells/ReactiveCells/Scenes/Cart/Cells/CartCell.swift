//
//  CartCell.swift
//  ReactiveCells
//
//  Created by Greg Price on 15/03/2021.
//

import UIKit
import RxSwift
import RxCocoa

final class CartCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

extension CartCell {
    func bind(viewModel: CartCellViewModel, incrementObserver: AnyObserver<CartProduct>, decrementObserver: AnyObserver<CartProduct>) {
        thumbImageView.image = viewModel.image
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        countLabel.text = viewModel.count
            
        rx.incrementTap
            .map { viewModel.product }
            .bind(to: incrementObserver)
            .disposed(by: disposeBag)
        
        rx.decrementTap
            .map { viewModel.product }
            .bind(to: decrementObserver)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: CartCell {
    var incrementTap: ControlEvent<Void> { base.plusButton.rx.tap }
    var decrementTap: ControlEvent<Void> { base.minusButton.rx.tap }
}

struct CartCellViewModel {
    let row: CartRow
    var product: CartProduct! { row.products.first }
    var image: UIImage? { product?.productImage }
    var name: String? { product?.title }
    var price: String? { row.rowTotal.decimalCurrencyString }
    var count: String { "\(row.products.count)" }
}
