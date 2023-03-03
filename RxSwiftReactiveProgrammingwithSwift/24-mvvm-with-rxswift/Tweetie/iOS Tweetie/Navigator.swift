import Foundation
import UIKit

import RxCocoa

class Navigator {
    lazy private var defaultStoryboard = UIStoryboard(name: "Main", bundle: nil)

    // MARK: - segues list
    enum Segue {
        case listTimeline(Driver<TwitterAccount.AccountStatus>, ListIdentifier)
        case listPeople(Driver<TwitterAccount.AccountStatus>, ListIdentifier)
        case personTimeline(Driver<TwitterAccount.AccountStatus>, username: String)
    }

    // MARK: - invoke a single segue
    func show(segue: Segue, sender: UIViewController) {
        switch segue {
        case .listTimeline(let account, let list):
            //show the combined timeline for the list
            let vm = ListTimelineViewModel(account: account, list: list)
            show(target: ListTimelineViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: vm), sender: sender)

        case .listPeople(let account, let list):
            //show the list of user accounts in the list
            let vm = ListPeopleViewModel(account: account, list: list)
            show(target: ListPeopleViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: vm), sender: sender)

        case .personTimeline(let account, username: let username):
            //show a given user timeline
            let vm = PersonTimelineViewModel(account: account, username: username)
            show(target: PersonTimelineViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: vm), sender: sender)

        }
    }

    private func show(target: UIViewController, sender: UIViewController) {
        if let nav = sender as? UINavigationController {
            //push root controller on navigation stack
            nav.pushViewController(target, animated: false)
            return
        }

        if let nav = sender.navigationController {
            //add controller to navigation stack
            nav.pushViewController(target, animated: true)
        } else {
            //present modally
            sender.present(target, animated: true, completion: nil)
        }
    }
}
