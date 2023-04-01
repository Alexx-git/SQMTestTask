//
//  QuoteTableViewCell.swift
//  Technical-test
//
//  Created by Alexx on 30.03.2023.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "QuoteTableViewCell"
    
    typealias OnFavoritesClick = (Int) -> Void
    
    private var onFavoritesClick: OnFavoritesClick?
    
    private var itemId: Int?
    
    private let nameLabel = UILabel()
    private let lastLabel = UILabel()
    private let currencyLabel = UILabel()
    private let readableLastChangePercentLabel = UILabel()
    private let favoriteButton = UIButton()
    
    lazy var amountContainerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [lastLabel, currencyLabel])
        lastLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.spacing = 8.0
        return stackView
    }()
    
    lazy var infoContainerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, amountContainerView])
        stackView.axis = .vertical
        return stackView
    }()

    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoContainerView, readableLastChangePercentLabel, favoriteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 8.0, left: 20.0, bottom: 8.0, right: 8.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 16.0
        infoContainerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        readableLastChangePercentLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        readableLastChangePercentLabel.font = .systemFont(ofSize: 24.0)
        favoriteButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        favoriteButton.setImage(UIImage(named: "no-favorite"), for: .normal)
        favoriteButton.setImage(UIImage(named: "favorite"), for: .selected)
        favoriteButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        favoriteButton.addTarget(self, action: #selector(didPressFavoriteButton), for: .touchUpInside)
        return stackView
    }()
    
    private var favorite: Bool = false {
        didSet {
            favoriteButton.isSelected = favorite
        }
    }
    
    private func setupSubviews() {
        contentView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init?(coder: NSCoder) is not used for QuoteTableViewCell")
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    func setupValues(
        itemId: Int,
        name: String?,
        last: String?,
        curency: String?,
        lastPercent: String?,
        variationColor: UIColor?,
        isFavorite: Bool,
        onFavoritesClick: OnFavoritesClick?
    ) {
        self.itemId = itemId
        nameLabel.text = name
        lastLabel.text = last
        currencyLabel.text = curency
        readableLastChangePercentLabel.text = lastPercent
        readableLastChangePercentLabel.textColor = variationColor
        favorite = isFavorite
        self.onFavoritesClick = onFavoritesClick
    }
    
    @objc func didPressFavoriteButton(_ sender:UIButton!) {
        if let itemId {
            sender.isSelected = !sender.isSelected
            onFavoritesClick?(itemId)
        }
    }
}
