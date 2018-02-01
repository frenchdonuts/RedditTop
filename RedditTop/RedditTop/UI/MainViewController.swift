//
//  MainViewController.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/28/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var viewModel = RedditTopViewModel()
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 148
        tableView.register(UINib(nibName:"LinkTableViewCell", bundle: nil), forCellReuseIdentifier: "LinkTableViewCell")
        tableView.register(UINib(nibName:"LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView(frame: .zero)
    }

    private func setupViewModel() {
        let bond = Bond<Bool>() { [weak self] v in
            DispatchQueue.main.async {
                if !v {
                    self?.tableView.reloadData()
                }
            }
        }
        viewModel.onTapImageHandler = { [weak self] url in
            self?.performSegue(withIdentifier: "showImageSegue", sender: url)
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

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        viewModel.saveState()
        let contentOffset = tableView.contentOffset
        coder.encode(contentOffset, forKey: "contentOffset")
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        viewModel.restoreState()
        let contentOffset = coder.decodeCGPoint(forKey: "contentOffset")
        tableView.setContentOffset(contentOffset, animated: false)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadMoreIfNeeded(indexPath: indexPath)
    }
}

