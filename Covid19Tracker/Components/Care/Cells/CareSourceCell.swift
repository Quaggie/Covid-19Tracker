//
//  CareSourceCell.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 14/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class CareSourceCell: UICollectionViewCell {
    // MARK: - Static
    static let height: CGFloat = 14

    // MARK: - Views

    private let button: UIButton = {
        let btn = UIButton(type: .system)

        let sourceAttributes: [NSAttributedString.Key : Any] = [
            .font: Font.regular(size: 10),
            .foregroundColor: Color.white
        ]
        let attributedString = NSMutableAttributedString(string: "Source: ", attributes: sourceAttributes)

        let linkAttributes: [NSAttributedString.Key : Any] = [
            .font: Font.regular(size: 10),
            .foregroundColor: Color.white,
            .underlineColor: Color.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        let linkAttributedString = NSAttributedString(string: "World Health Organization", attributes: linkAttributes)
        attributedString.append(linkAttributedString)

        btn.contentHorizontalAlignment = .leading
        btn.setAttributedTitle(attributedString, for: .normal)
        return btn
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CareSourceCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(button)
    }

    func setupConstraints() {
        button.fillSuperview()
    }

    func setupAdditionalConfiguration() {

    }
}
