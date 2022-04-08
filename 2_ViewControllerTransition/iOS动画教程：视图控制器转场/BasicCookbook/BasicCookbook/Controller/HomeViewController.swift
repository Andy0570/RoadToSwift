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

// MARK: - UIViewController

class HomeViewController: UITableViewController {

    // 💡 驱动视图控制器转场动画的实例对象
    let transition = PopAnimator()

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        transition.dismissCompletion = { [weak self] in
//            guard let selectedIndexPath = self?.tableView.indexPathForSelectedRow,
//            let selectedCell = self?.tableView.cellForRow(at: selectedIndexPath) as? RecipeTableViewCell else {
//                return
//            }
//
//            selectedCell.shadowView.isHidden = false
//        }
//    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Recipe.all().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        cell.recipe = Recipe.all()[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: Recipe.all()[indexPath.row])
    }
}

// MARK: - Prepare for Segue

extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let detailsViewController = segue.destination as? DetailsViewController,
            let recipe = sender as? Recipe {
            detailsViewController.transitioningDelegate = self // 💡 声明自定义转场动画
            detailsViewController.recipe = recipe
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension HomeViewController: UIViewControllerTransitioningDelegate {

    // present 动画控制器
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        guard let selectedIndexPath = tableView.indexPathForSelectedRow,
              let selectedCell = tableView.cellForRow(at: selectedIndexPath) as? RecipeTableViewCell,
                let selectedCellSuperview = selectedCell.superview else {
                    return nil
                }

        transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        transition.originFrame = CGRect(
            x: transition.originFrame.origin.x + 20,
            y: transition.originFrame.origin.y + 20,
            width: transition.originFrame.width - 40,
            height: transition.originFrame.height - 40
        );

        transition.presenting = true
        //selectedCell.shadowView.isHidden = true

        return transition
    }

    // dismiss 动画控制器
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }

}
