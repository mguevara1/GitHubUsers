//
//  UserDetailsViewController.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 19/01/24.
//

import UIKit
import Combine

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "UserDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "UserDetailsTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var viewModel: UserDetailsViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var avatarImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bindViewModel()
        viewModel.getUserDetails(username: viewModel.username)
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$selectedUser
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self = self else { return }
                guard let user = user else { return }
                viewModel.detailItems = [
                        UserDetailsItem(title: "Username", description: user.login),
                        UserDetailsItem(title: "Full name", description: user.name ?? ""),
                        UserDetailsItem(title: "Number of followers", description: String(user.followers ?? 0)),
                        UserDetailsItem(title: "Following", description: String(user.following ?? 0))
                    ]
                tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$avatarUrl
            .sink { [weak self] url in
                guard let self = self else { return }
                avatarImageView.downloadImage(from: url)
            }
            .store(in: &cancellables)
    }
    
    private func configureTableView() {
        avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.backgroundColor = .gray

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        avatarImageView.center = headerView.center
        headerView.addSubview(avatarImageView)
        tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
    }
}


extension UserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.detailItems?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsTableViewCell", for: indexPath) as! UserDetailsTableViewCell
        if let item = viewModel.detailItems?[indexPath.row] {
            cell.titleLabel.text = "\(item.title): \(item.description)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
