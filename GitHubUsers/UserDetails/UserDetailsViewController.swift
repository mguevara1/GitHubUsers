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
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var viewModel: UserDetailsViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var avatarImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        viewModel.getUserDetails(username: viewModel.username)
    }
    
    private func setupUI() {
        title = viewModel.username
        addLoader()
        configureTableView()
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
                    UserDetailsItem(title: CommonStrings.UserDetails.userNameTitle, description: user.login),
                    UserDetailsItem(title: CommonStrings.UserDetails.fullNameTitle, description: user.name ?? ""),
                    UserDetailsItem(title: CommonStrings.UserDetails.followersTitle, description: String(user.followers ?? 0)),
                    UserDetailsItem(title: CommonStrings.UserDetails.followingTitle, description: String(user.following ?? 0)),
                    UserDetailsItem(title: CommonStrings.UserDetails.reposTitle, description: String(user.publicRepos ?? 0), rightArrowHidden: false)
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
        
        viewModel.$error
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let err = error {
                    self?.errorHandler(error: err)
                }
            }.store(in: &cancellables)
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
    
    private func errorHandler(error: GitHubUsersError) {
        switch error {
        case .ServerFailure(let message):
            showAlert(title: CommonStrings.errorTitle, message: message)
        case .UnhandledFailure:
            showAlert(title: CommonStrings.errorTitle, message: CommonStrings.unhandledError)
        }
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
            cell.arrowImageView.isHidden = item.rightArrowHidden
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = viewModel.selectedUser, indexPath.row == 4 {
            if let userReposVC = storyboard?.instantiateViewController(withIdentifier: "UserReposViewController") as? UserReposViewController {
                userReposVC.viewModel = UserReposViewModel(gitHubClient: viewModel.gitHubClient, reposUrl: user.reposURL)
                navigationController?.pushViewController(userReposVC, animated: true)
            } else {
                debugPrint("Error: Unable to instantiate UserReposViewController from storyboard.")
                showAlert(title: CommonStrings.errorTitle, message: CommonStrings.unhandledError)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
