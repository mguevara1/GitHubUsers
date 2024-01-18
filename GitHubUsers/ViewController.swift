//
//  ViewController.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 17/01/24.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = ViewModel(gitHubClient: GitHubClient(accessToken: "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"))

        super.init(coder: coder)
    }


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) has not been implemented. Use init(viewModel) instead.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.searchUsers(query: "octocat")
    }
    
    
    func bindViewModel() {
        viewModel.$users
            .sink { [weak self] users in

                print(users)
            }
            .store(in: &cancellables)
    }

}
