//
//  MainViewController.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/28/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let viewModel = RedditTopViewModel()
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    var updatedBond:Bond<Bool>?

    deinit {
        updatedBond?.unbindAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        UIImageView.cache.flush()
    }

    private func setupTableView() {
        tableView.dataSource = viewModel
        tableView.register(UINib(nibName:"LinkTableViewCell", bundle: nil), forCellReuseIdentifier: "LinkTableViewCell")
        tableView.register(UINib(nibName:"LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView(frame: .zero)
    }

    private func setupViewModel() {
        let bond = Bond<Bool>() { [unowned self] v in
            DispatchQueue.main.async {
                if !v {
                    self.tableView.reloadData()
                }
            }
        }
        viewModel.onTapImageHandler = { [unowned self] url in
            self.performSegue(withIdentifier: "showImageSegue", sender: url)
        }
        viewModel.refreshing >>> refreshControl
        viewModel.refreshing >>> bond
        refreshControl >>> viewModel
        self.updatedBond = bond
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let url = sender as? URL else { return }
        if segue.identifier == "showImageSegue" {
            let vc = segue.destination as! ImageViewController
            vc.imageUrl = url
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadMoreIfNeeded(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }
}

