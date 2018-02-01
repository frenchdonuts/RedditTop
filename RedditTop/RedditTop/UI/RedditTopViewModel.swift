//
//  RedditTopViewModel.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/29/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

class RedditTopViewModel: NSObject, Bondable {
    private let paginator = Paginator<Link>()
    var refreshing: Dynamic<Bool> = Dynamic(false)
    var designatedBond: Bond<Bool>?
    var onTapImageHandler: ((URL)->Void)?

    var items: [Link] {
        return paginator.items
    }
    
    deinit {
        designatedBond?.unbindAll()
    }

    override init() {
        super.init()
        setupPaginator()
        designatedBond = Bond<Bool>() { [weak self] v in
            DispatchQueue.main.async {
                if v {
                    self?.refresh()
                }
            }
        }
        refresh()
    }

    func loadMoreIfNeeded(indexPath: IndexPath) {
        guard indexPath.item == items.count,
            paginator.moreAvailable else {
                return
        }
        paginator.fetchItems()
    }

    private func setupPaginator() {
        paginator.onUpdatedHandler = { [weak self]
            (numberOfNewItems) -> Void in
            guard numberOfNewItems > 0 else { return }
            DispatchQueue.main.async {
                self?.refreshing.value = false
            }
        }

        paginator.updateRequest = {
            (after: String?, updateHandler: @escaping Paginator<Link>.completionHandler) -> Void in
            RedditListingsAPIService.getTop(before: nil, after: after, completion: { (thing, error) in
                let listing = thing?.data as? Listing
                let links = listing?.children.flatMap({$0.data as? Link}) ?? []
                let cursors = Cursors(after: listing?.after, before: listing?.before)
                updateHandler(links, cursors, error)
            })
        }
    }

    @objc func refresh() {
        refreshing.value = true
        paginator.reset()
    }
}


extension RedditTopViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.item != items.count else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell") as! LoadingTableViewCell
            return cell
        }
        let link = paginator.items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkTableViewCell", for: indexPath) as! LinkTableViewCell
        cell.onTapImageHandler = { [weak self] in
            guard let url = URL(string: link.url) else { return }
            guard url.isLinkToImage else { return }
            self?.onTapImageHandler?(url)
        }
        cell.setup(for: link)
        return cell
    }
}
