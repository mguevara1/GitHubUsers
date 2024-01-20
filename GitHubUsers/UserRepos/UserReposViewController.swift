//
//  UserReposViewController.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 20/01/24.
//

import UIKit
import Combine
import WebKit

class UserReposViewController: UIViewController {
    
    var viewModel: UserReposViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "UserReposTableViewCell", bundle: nil), forCellReuseIdentifier: "UserReposTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Repositories"
        bindViewModel()
        viewModel.getUserRepos(url: viewModel.reposUrl)
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$repositories
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repos in
                guard let self = self else { return }
                guard let repos = repos else { return }
                print(repos)
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func showWebView(url: URL) {
        let webViewController = UIViewController()
        let webView = WKWebView(frame: webViewController.view.bounds)
        webView.load(URLRequest(url: url))
        webViewController.view.addSubview(webView)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

extension UserReposViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReposTableViewCell", for: indexPath) as! UserReposTableViewCell
        cell.nameLabel.text = viewModel.repositories?[indexPath.row].name
        cell.languageLabel.text = "Language: \(viewModel.repositories?[indexPath.row].language ?? "N/A")"
        cell.starsLabel.text = "Stars: \(viewModel.repositories?[indexPath.row].stargazersCount ?? 0)"
        cell.descriptionLabel.text = "Description: \(viewModel.repositories?[indexPath.row].description ?? "N/A")"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let htmlURL = viewModel.repositories?[indexPath.row].htmlURL else { return }
        showWebView(url: htmlURL)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
}
