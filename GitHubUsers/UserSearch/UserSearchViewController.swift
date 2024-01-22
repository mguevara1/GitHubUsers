//
//  ViewController.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 17/01/24.
//

import UIKit
import Combine

class UserSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "UserSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "UserSearchTableViewCell")
            tableView.separatorStyle = .none
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let emptyStateView: EmptyStateView = {
            let view = EmptyStateView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    public var cancellable: Set<AnyCancellable> = []
    var viewModel: UserSearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLoader()
        addEmptyStateView()
        
        if let config = ConfigurationManager.loadConfig() {
            let gitHubClient = GitHubClient(accessToken: config.githubToken)
            viewModel = UserSearchViewModel(gitHubClient: gitHubClient)
            bindViewModel()
        } else {
            showAlert(title: CommonStrings.errorTitle, message: CommonStrings.configurationError)
        }
        
        searchBar.becomeFirstResponder()
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { searchText in
                viewModel.searchUsers(query: searchText)
            }
            .store(in: &cancellable)
        
        viewModel.$users
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                guard let self = self else { return }
                guard let users = users else { return }
                tableView.reloadData()
                showEmptyState(users.isEmpty)
            }
            .store(in: &cancellable)
        
        viewModel.$isLoading
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? showLoading() : stopLoading()
            }
            .store(in: &cancellable)
        
        viewModel.$error
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let err = error {
                    self?.errorHandler(error: err)
                }
            }.store(in: &cancellable)
    }
    
    private func addLoader() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    private func showLoading() {
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    private func addEmptyStateView() {
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
        
    private func showEmptyState(_ show: Bool) {
        emptyStateView.isHidden = !show
        tableView.isHidden = show
    }
    
    private func errorHandler(error: GitHubUsersError) {
        switch error {
        case .ServerFailure(let message):
            showAlert(title: CommonStrings.errorTitle, message: message)
        case .UnhandledFailure:
            showAlert(title: CommonStrings.errorTitle, message: CommonStrings.unhandledError)
        }
    }
}

extension UserSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let user = viewModel.users?[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchTableViewCell", for: indexPath) as! UserSearchTableViewCell
            cell.usernameLabel?.text = user.login
            cell.avatarImageView.downloadImage(from: user.avatarURL)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = viewModel.users?[indexPath.row] {
            if let userDetailsVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailsViewController") as? UserDetailsViewController {
                userDetailsVC.viewModel = UserDetailsViewModel(gitHubClient: viewModel.gitHubClient, username: user.login, avatarUrl: user.avatarURL)
                navigationController?.pushViewController(userDetailsVC, animated: true)
            } else {
                debugPrint("Error: Unable to instantiate UserDetailsViewController from storyboard.")
                showAlert(title: CommonStrings.errorTitle, message: CommonStrings.unhandledError)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

extension UserSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
}
