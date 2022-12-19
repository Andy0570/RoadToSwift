import UIKit

protocol PetDetailViewControllerDelegate: AnyObject {
    func petDetailViewController(_ petDetailViewController: PetDetailViewController, didAdoptPet pet: Pet)
}

class PetDetailViewController: UIViewController {
    // MARK: - Properties
    var pet: Pet
    var isAdopted = false
    weak var delegate: PetDetailViewControllerDelegate?

    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var adoptButton: UIButton!

    // MARK: - Life Cycle
    init?(coder: NSCoder, pet: Pet) {
        self.pet = pet
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        adoptButton.setTitle("Adopt", for: .normal)
        adoptButton.isHidden = isAdopted
        imageView.image = UIImage(named: pet.imageName)
        name.text = isAdopted ? "Your pet: \(pet.name)" : pet.name
        age.text = "\(pet.age) years old"
    }
}

// MARK: - IBActions
extension PetDetailViewController {
    @IBAction func didTapAdoptButton(_ sender: UIButton) {
        delegate?.petDetailViewController(self, didAdoptPet: pet)
        navigationController?.popViewController(animated: true)
    }
}
