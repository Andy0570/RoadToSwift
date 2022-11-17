import UIKit

class ChocolateIsComingViewController: UIViewController {
  @IBOutlet var orderLabel: UILabel!
  @IBOutlet var costLabel: UILabel!
  @IBOutlet var creditCardIcon: UIImageView!
  
  var cardType: CardType = .unknown {
    didSet {
      configureIconForCardType()
    }
  }
}

//MARK: - View lifecycle
extension ChocolateIsComingViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureIconForCardType()
    configureLabelsFromCart()
  }
}

//MARK: - Configuration methods
private extension ChocolateIsComingViewController {
  func configureIconForCardType() {
    guard let imageView = creditCardIcon else {
      //View hasn't loaded yet, come back later.
      return
    }
    
    imageView.image = cardType.image
  }
  
  func configureLabelsFromCart() {
    guard let costLabel = costLabel else {
      //View hasn't loaded yet, come back later.
      return
    }
    
    let cart = ShoppingCart.sharedCart
    
    costLabel.text = CurrencyFormatter.dollarsFormatter.string(from: cart.totalCost)
    
    orderLabel.text = cart.itemCountString
  }
}
