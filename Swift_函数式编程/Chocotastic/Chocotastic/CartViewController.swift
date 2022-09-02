/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class CartViewController: UIViewController {
    @IBOutlet private var checkoutButton: UIButton!
    @IBOutlet private var totalItemsLabel: UILabel!
    @IBOutlet private var totalCostLabel: UILabel!
}

//MARK: - View lifecycle
extension CartViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart"
        configureFromCart()
    }
}

//MARK: - IBActions
extension CartViewController {
    @IBAction func reset() {
        ShoppingCart.sharedCart.chocolates.accept([])
        let _ = navigationController?.popViewController(animated: true)
    }
}

//MARK: - Configuration methods
private extension CartViewController {
    func configureFromCart() {
        guard checkoutButton != nil else {
            //UI has not been instantiated yet. Bail!
            return
        }

        let cart = ShoppingCart.sharedCart
        totalItemsLabel.text = cart.itemCountString

        let cost = cart.totalCost
        totalCostLabel.text = CurrencyFormatter.dollarsFormatter.string(from: cost)

        //Disable checkout if there's nothing to check out with
        checkoutButton.isEnabled = (cost > 0)
    }
}
