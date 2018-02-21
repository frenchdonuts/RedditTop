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

    fileprivate var selectedLink: Link?
    fileprivate var selectedIndex: IndexPath?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
    }

    private func setupTableView() {
        tableView.dataSource = viewModel
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(UINib(nibName:"LinkTableViewCell", bundle: nil), forCellReuseIdentifier: "LinkTableViewCell")
        tableView.register(UINib(nibName:"LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView(frame: .zero)
    }

    private func setupViewModel() {
        viewModel.onTapImageHandler = { [weak self] index, link in
            self?.selectedIndex = index
            self?.selectedLink = link
            self?.performSegue(withIdentifier: "showImageSegue", sender: link)
        }
        viewModel.refreshing >>> refreshControl
        viewModel.refreshing >>> tableView
        refreshControl >>> viewModel
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let link = sender as? Link, let imageUrl = URL(string: link.url) else { return }
        if segue.identifier == "showImageSegue" {
            let vc = segue.destination as! ImageViewController
            vc.imageUrl = imageUrl
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
