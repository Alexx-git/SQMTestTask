//
//  QuotesListViewController.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit

class QuotesListViewController: UIViewController {
    
    let tableView = UITableView()
    
    private let dataManager: DataManager = DataManager()
    
    var onFavoritesClick: QuoteTableViewCell.OnFavoritesClick?
    
    var quotes: [Quote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Quotes"
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(QuoteTableViewCell.self, forCellReuseIdentifier: QuoteTableViewCell.reuseIdentifier)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        onFavoritesClick = { [weak self] itemIndex in
            self?.toggleFavorite(at: itemIndex)
        }

        let activityViewController = ActivityViewController.showOnViewController(self)
        dataManager.fetchQuotes { [weak self] quotes, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.quotes = quotes
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                activityViewController.dismiss()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension QuotesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuoteTableViewCell.reuseIdentifier) as? QuoteTableViewCell else {
            assertionFailure("QuoteTableViewCell must be registered in table view")
            return UITableViewCell()
        }
        let quote = quotes[indexPath.row]
        cell.setupValues(
            // as Quote has no unique identifier, we use index in array to identify quote
            itemId: indexPath.row,
            name: quote.name,
            last: quote.last,
            curency: quote.currency,
            lastPercent: quote.readableLastChangePercent,
            variationColor: quote.variationColor?.color,
            isFavorite: dataManager.isFavorite(quote: quote),
            onFavoritesClick: onFavoritesClick
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nc = self.navigationController
        let detailsVC = QuoteDetailsViewController(dataManager: dataManager, quote: quotes[indexPath.row])
        nc?.pushViewController(detailsVC, animated: false)
    }
    
    func toggleFavorite(at index: Int) {
        dataManager.toggleFavorites(quote: quotes[index])
    }
}
