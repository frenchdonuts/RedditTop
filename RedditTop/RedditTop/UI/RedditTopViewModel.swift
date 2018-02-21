//
//  RedditTopViewModel.swift
//  RedditTop
//
//  Created by Alexander Kharevich on 1/29/18.
//  Copyright © 2018 Alexander Kharevich. All rights reserved.
//

import UIKit

class RedditTopViewModel: NSObject, Bondable {
    private var paginator = Paginator<Link>()
    var refreshing: Dynamic<Bool> = Dynamic(false)
    var designatedBond: Bond<Bool>?
    var onTapImageHandler: ((IndexPath, Link)->Void)?

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
            DispatchQueue.main.async {
                self?.refreshing.value = false
            }
        }

        paginator.updateRequest = {
            (after: String?, updateHandler: @escaping Paginator<Link>.completionHandler) -> Void in
            RedditListingsAPIService.getTop(before: nil, after: after, completion: { (thing, error) in
                let listing = thing?.data
                let links = listing?.children.flatMap({$0.data}) ?? []
                let cursors = Cursors(after: listing?.after, before: listing?.before)
                updateHandler(links, cursors, error)
            })
        }
    }

    @objc func refresh() {
        refreshing.value = true
        paginator.reset()
    }

    func saveState() {
        do {
            let data = try PropertyListEncoder().encode(paginator)
            let arch = NSKeyedArchiver.archivedData(withRootObject: data)
            UserDefaults.standard.set(arch, forKey: "ViewModel-paginator")
        } catch {
            print("Save Failed \(error.localizedDescription)")
        }
    }

    func restoreState() {
        guard let data = UserDefaults.standard.object(forKey: "ViewModel-paginator") as? Data else { return }
        guard let unArch = NSKeyedUnarchiver.unarchiveObject(with: data) as? Data else { return }
        do {
            let restoredPaginator = try PropertyListDecoder().decode(Paginator<Link>.self, from: unArch )
            paginator.cursors = restoredPaginator.cursors
            paginator.items = restoredPaginator.items
            refreshing.value = false
        } catch {
            print("Retrieve Failed \(error.localizedDescription)")
        }
    }
}

extension RedditTopViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paginator.moreAvailable {
            return items.count + 1
        }
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.item != items.count else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell") as! LoadingTableViewCell
            return cell
        }
        let link = paginator.items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkTableViewCell", for: indexPath) as! LinkTableViewCell
        if let url = URL(string: link.url), url.isImageUrl {
            cell.onTapImageHandler = { [weak self] in
                self?.onTapImageHandler?(indexPath, link)
            }
        }
        cell.setup(for: link)
        return cell
    }
}

extension RedditTopViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMoreIfNeeded(indexPath: indexPath)
    }
}
