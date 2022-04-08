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

enum FieldsToDisplay: String, CaseIterable {
    case image = "Image"
    case model = "Model"
    case starshipClass = "Class"
    case costInCredits = "Cost in Credits"
    case cargoCapacity = "Cargo Capacity"
    case MGLT = "Speed"
    case maxAtmospheringSpeed = "Max Atmosphering Speed"
    case length = "Length"
}

class DetailViewController: UITableViewController {
    let numberOfFields = FieldsToDisplay.allCases.count
    let numberFormatter = NumberFormatter()

    lazy var imageFetcher = StarshipImageFetcher()

    var starshipImage = UIImage(named: "image_not_found.png")
    var starshipItem: Starship? {
        didSet {
            starshipImage = imageFetcher.imageForStarship(named: starshipItem!.name)
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        numberFormatter.minimumFractionDigits = 2
        numberFormatter.roundingMode = .halfDown

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 375
    }


    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfFields
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return starshipItem?.name
        } else {
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // The first item is the image, which should be treated differently
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! StarshipImageCell
            cell.starshipImageView.image = starshipImage
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FieldCell", for: indexPath)

            switch indexPath.row {
            case 1:
                cell.textLabel!.text = FieldsToDisplay.model.rawValue
                cell.detailTextLabel!.text = starshipItem?.model
            case 2:
                cell.textLabel!.text = FieldsToDisplay.starshipClass.rawValue
                cell.detailTextLabel!.text = starshipItem?.starshipClass
            case 3:
                cell.textLabel!.text = FieldsToDisplay.costInCredits.rawValue
                if let cost = starshipItem?.costInCredits,
                   let costStr = numberFormatter.string(from: NSNumber(value: cost)) {
                    cell.detailTextLabel!.text = "\(costStr)"
                } else {
                    cell.detailTextLabel!.text = "Unknown"
                }
            case 4:
                cell.textLabel!.text = FieldsToDisplay.cargoCapacity.rawValue
                if let cargoCapacity = starshipItem?.cargoCapacity,
                   let cargoCapacityStr = numberFormatter.string(from: NSNumber(value: cargoCapacity)) {
                    cell.detailTextLabel!.text = "\(cargoCapacityStr) kg"
                } else {
                    cell.detailTextLabel!.text = "Unknown"
                }
            case 5:
                cell.textLabel!.text = FieldsToDisplay.MGLT.rawValue
                if let MGLT = starshipItem?.MGLT {
                    cell.detailTextLabel!.text = "\(MGLT) megalights"
                } else {
                    cell.detailTextLabel!.text = "Unknown"
                }
            case 6:
                cell.textLabel!.text = FieldsToDisplay.maxAtmospheringSpeed.rawValue
                if let maxAtmospheringSpeed = starshipItem?.maxAtmospheringSpeed {
                    cell.detailTextLabel!.text = "\(maxAtmospheringSpeed)"
                } else {
                    cell.detailTextLabel!.text = "Not Applicable"
                }
            case 7:
                cell.textLabel!.text = FieldsToDisplay.length.rawValue
                if let length = starshipItem?.length,
                   let lengthStr = numberFormatter.string(from: NSNumber(value: length)) {
                    cell.detailTextLabel!.text = "\(lengthStr)"
                } else {
                    cell.detailTextLabel!.text = "Unknown"
                }
            default:
                print("Warning! Unexpected row number: \(indexPath.row)")
            }

            cell.textLabel?.textColor = .starwarsStarshipGrey
            cell.detailTextLabel?.textColor = .starwarsYellow

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .starwarsYellow
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .starwarsSpaceBlue
        }
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let widthOfTableView = self.tableView!.frame.width
            let widthOfImage = starshipImage!.size.width
            let scaleFactor = widthOfTableView / widthOfImage
            return starshipImage!.size.height * scaleFactor
        } else {
            return 44.0
        }
    }
}

class StarshipImageCell: UITableViewCell {
    @IBOutlet weak var starshipImageView: UIImageView!
}
