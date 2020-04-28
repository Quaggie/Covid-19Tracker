//
//  SearchCell.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 13/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class SearchCell: UITableViewCell {
    // MARK: - Views
    private let label = UILabel(text: "", font: Font.regular(size: 14), textColor: Color.black, textAlignment: .left, numberOfLines: 1)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentView.backgroundColor = highlighted ? Color.grayLight : Color.white
    }

    func setup(string: String) {
        label.text = string
    }
}

// MARK: - CodeView
extension SearchCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(label)
    }

    func setupConstraints() {
        label.fillSuperview(insets: .init(top: 16, left: 16, bottom: 16, right: 16))
    }

    func setupAdditionalConfiguration() {
        contentView.backgroundColor = Color.white
    }
}
