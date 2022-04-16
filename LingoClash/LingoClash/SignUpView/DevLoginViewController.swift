//
//  DevLoginViewController.swift
//  LingoClash
//
//  Created by Sherwin Poh on 13/4/22.
//

import Foundation
import UIKit
import Combine
class DevLoginViewController: UIViewController {
    private let viewModel = DevLoginViewModel()
    private var cancellables: Set<AnyCancellable> = []

    @IBOutlet private var devLoginTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinders()
        devLoginTableView.dataSource = self
        devLoginTableView.delegate = self
    }

    func setUpBinders() {
        viewModel.$error.sink {[weak self] error in
            if let error = error {
                Logger.error("Fail to bypass login. Error: \(error)")
            } else {
                self?.transitionToHome()
            }
        }.store(in: &cancellables)
    }

    func transitionToHome() {
        let mainViewController = HomeNavigationViewController.instantiateFromAppStoryboard(AppStoryboard.Home)

        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }
}

extension DevLoginViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.testAccounts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: DevLoginTableCell.reuseIdentifier) as? DevLoginTableCell else {
            fatalError("Failure obtaining reusable dev login table view cell")
        }
        let account = viewModel.testAccounts[indexPath.row]

        cell.email.text = account.email
        return cell
    }
}

extension DevLoginViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.directLogin(row: indexPath.row)
    }
}
