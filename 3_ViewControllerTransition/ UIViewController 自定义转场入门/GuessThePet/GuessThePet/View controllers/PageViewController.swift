/// Copyright (c) 2017 Razeware LLC
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

class PageViewController: UIPageViewController {
  
  private let petCards = PetCardStore.defaultPets
  
  override func viewDidLoad() {
    super.viewDidLoad()

    dataSource = self
    setViewControllers([viewControllerForPage(at: 0)], direction: .forward, animated: false, completion: nil)
  }
}

// MARK: Page view controller data source

extension PageViewController: UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewController = viewController as? CardViewController,
      let pageIndex = viewController.pageIndex,
      pageIndex > 0  else {
        return nil
    }
    return viewControllerForPage(at: pageIndex - 1)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewController = viewController as? CardViewController,
      let pageIndex = viewController.pageIndex,
      pageIndex + 1 < petCards.count else {
        return nil
    }
    return viewControllerForPage(at: pageIndex + 1)
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return petCards.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    guard let viewControllers = pageViewController.viewControllers,
      let currentVC = viewControllers.first as? CardViewController,
      let currentPageIndex = currentVC.pageIndex else {
        return 0
    }
    return currentPageIndex
  }
  
  private func viewControllerForPage(at index: Int) -> UIViewController {
    let cardViewController: CardViewController = UIStoryboard(storyboard: .main).instantiateViewController()
    cardViewController.pageIndex = index
    cardViewController.petCard = petCards[index]
    return cardViewController
  }
}
