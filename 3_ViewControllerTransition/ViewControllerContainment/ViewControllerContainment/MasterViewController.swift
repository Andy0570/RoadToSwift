//
//  MasterViewController.swift
//  ViewControllerContainment
//
//  Created by Qilin Hu on 2022/8/20.
//

/**
 参考：[用容器视图控制器管理视图控制器](https://cocoacasts.com/managing-view-controllers-with-container-view-controllers/)
 */
import UIKit

class MasterViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!

    // 使用 lazy loading 技术初始化子视图控制器
    private lazy var summaryViewController: SummaryViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()

    private lazy var sessionsViewController: SessionsViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "SessionsViewController") as! SessionsViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        setupSegmentedControl()
        updateView()
    }

    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentControl.removeAllSegments()
        segmentControl.insertSegment(withTitle: "Summary", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "Sessions", at: 1, animated: false)
        segmentControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)

        // Select First Segment
        segmentControl.selectedSegmentIndex = 0
    }

    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }

    private func updateView() {
        if segmentControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: sessionsViewController)
            add(asChildViewController: summaryViewController)
        } else {
            remove(asChildViewController: summaryViewController)
            add(asChildViewController: sessionsViewController)
        }
    }

    /**
     💡 为容器视图控制器添加一个子视图控制器所需的步骤：

     首先，我们通过调用容器视图控制器上的 addChild(_:) 方法，将子视图控制器作为一个参数传入，将子视图控制器添加到容器视图控制器。通过调用这个方法，子视图控制器会自动接收一个 willMove(toParentViewController:) 的消息，容器视图控制器是唯一的参数。

     其次，我们将子视图控制器的视图添加到容器视图控制器的视图中。记住，容器视图控制器对子视图控制器的视图的大小和位置负责。不过，子视图控制器的视图层次仍然是由子视图控制器负责的。

     最后但同样重要的是，当子视图控制器被添加到容器视图控制器中，并且子视图控制器的视图准备好被显示时，容器视图控制器通过向子视图控制器发送 didMove(toParentViewController:) 的消息来通知它，并将自己作为唯一参数。
     */
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }

    /**
     💡 从容器视图控制器中移除一个子视图控制器
     */
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }
}

