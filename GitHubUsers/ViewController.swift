//
//  ViewController.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 17/01/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "UserSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "UserSearchTableViewCell")
            tableView.separatorStyle = .none
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private var cancellable: Set<AnyCancellable> = []
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let config = ConfigurationManager.loadConfig() {
            let gitHubClient = GitHubClient(accessToken: config.githubToken)
            viewModel = ViewModel(gitHubClient: gitHubClient)
            bindViewModel()
            viewModel.searchUsers(query: "octocat")
        } else {
            print("Failed to load configuration.")
        }
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let user = viewModel.users?[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchTableViewCell", for: indexPath) as! UserSearchTableViewCell
            cell.usernameLabel?.text = user.login
            cell.setImage(from: user.avatarURL)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did select: \(viewModel.users?[indexPath.row].login ?? "")")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
