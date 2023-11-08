# Reactive Cells

An example of binding events from custom controls inside of table view cells, to the business logic of a view model. This demo illustrates the technique using a checkout UI where multiple products of the same type can be added or removed using a stepper style component inside of each cell.

Checkout the full article on [tapdev][1]

[1]: https://tapdev.co/2021/03/15/how-to-bind-button-taps-in-custom-cells-to-your-view-model/

![Reactive Cells Screenshot](https://user-images.githubusercontent.com/10616345/111194385-0eddf700-85b3-11eb-954b-279a375ba36e.png)

The view model has 2 private subjects, one for incrementing a product and another for decrementing a product. These are safely exposed to the outside world as observers.

```swift
private let incrementProductSubject = PublishSubject<CartProduct>()
private let decrementProductSubject = PublishSubject<CartProduct>()

var incrementProduct: AnyObserver<CartProduct> { incrementProductSubject.asObserver() }
var decrementProduct: AnyObserver<CartProduct> { decrementProductSubject.asObserver() }

    func bind(_ input: CartInput) -> CartOutput {

        let cart = Observable
            .merge(
                incrementProductSubject.map { CartAction.increment($0) },
                decrementProductSubject.map { CartAction.decrement($0) }
            )
            ...

        return CartOutput(...)
    }
```

The cell is then passed a reference to these subject backed observers, and can then bind the tap events from the custom controls to the observers.

```swift
final class CartCell: UITableViewCell {
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!

    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

extension Reactive where Base: CartCell {
    var incrementTap: ControlEvent { base.plusButton.rx.tap }
    var decrementTap: ControlEvent { base.minusButton.rx.tap }
}

extension CartCell {
    func bind(viewModel: CartCellViewModel, incrementObserver: AnyObserver<CartProduct>, decrementObserver: AnyObserver<CartProduct>) {

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
```
