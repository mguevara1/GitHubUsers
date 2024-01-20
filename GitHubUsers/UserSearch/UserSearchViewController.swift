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
    
    public var cancellable: Set<AnyCancellable> = []
    var viewModel: UserSearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let config = ConfigurationManager.loadConfig() {
            let gitHubClient = GitHubClient(accessToken: config.githubToken)
            viewModel = UserSearchViewModel(gitHubClient: gitHubClient)
            bindViewModel()
        } else {
            print("Failed to load configuration.")
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
                
                tableView.reloadData()
            }
            .store(in: &cancellable)
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
                print("Error: Unable to instantiate UserDetailsViewController from storyboard.")
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
