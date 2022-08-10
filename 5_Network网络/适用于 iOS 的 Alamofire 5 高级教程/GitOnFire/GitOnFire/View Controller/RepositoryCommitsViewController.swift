import UIKit

class RepositoryCommitsViewController: UITableViewController {
    var commits: [Commit] = []
    var selectedRepository: Repository?
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        fetchCommitsForRepository()
    }
    
    func fetchCommitsForRepository() {
        loadingIndicator.startAnimating()
        guard let repository = selectedRepository else {
            return
        }
        GitAPIManager.shared.fetchCommits(for: repository.fullName) { [self] commits in
            self.commits = commits
            loadingIndicator.stopAnimating()
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension RepositoryCommitsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommitCell", for: indexPath)
        let commit = commits[indexPath.row]
        cell.textLabel?.text = commit.authorName
        cell.detailTextLabel?.text = commit.message
        return cell
    }
}
