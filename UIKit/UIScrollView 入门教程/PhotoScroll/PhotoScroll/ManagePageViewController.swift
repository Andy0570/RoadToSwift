/// Copyright (c) 2022 Razeware LLC
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

class ManagePageViewController: UIPageViewController {
    var photos = ["photo1", "photo2", "photo3", "photo4", "photo5"]
    var currentIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let viewController = viewPhotoCommentController(currentIndex ?? 0) {
            let viewControllers = [viewController]

            setViewControllers(viewControllers, direction: .forward, animated: false)
        }

        dataSource = self
    }

    // 通过 storyboard 创建 PhotoCommentViewController 的实例
    func viewPhotoCommentController(_ index: Int) -> PhotoCommentViewController? {
        guard let storyboard = storyboard,
                let page = storyboard.instantiateViewController(withIdentifier: "PhotoCommentViewController") as? PhotoCommentViewController else {
            return nil
        }

        page.photoName = photos[index]
        page.photoIndex = index
        return page
    }
}

extension ManagePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? PhotoCommentViewController,
           let index = viewController.photoIndex,
           index > 0 {
            return viewPhotoCommentController(index - 1)
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? PhotoCommentViewController,
           let index = viewController.photoIndex,
           (index + 1) < photos.count {
            return viewPhotoCommentController(index + 1)
        }

        return nil
    }

    // 指定要在页面视图控制器中显示的页面数
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
      return photos.count
    }

    // 告诉页面视图控制器它最初应该选择哪个页面
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
      return currentIndex ?? 0
    }

}

