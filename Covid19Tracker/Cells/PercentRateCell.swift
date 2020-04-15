//
//  PercentRateCell.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class PercentRateCell: UICollectionViewCell {
    enum Status {
        case recovery
        case fatality
    }

    // MARK: - Static
    static let height: CGFloat = 108

    // MARK: - Views
    private let titleLabel = UILabel(text: "rate", font: Font.semiBold(size: 18), textColor: Color.black, textAlignment: .center)
    private let separatorView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2
        return v
    }()
    private let percentLabel = UILabel(text: "--%", font: Font.semiBold(size: 18), textColor: Color.black, textAlignment: .center)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        applyShadow(color: Color.black,
                    offset: CGSize(width: 3, height: 2),
                    opacity: 0.2, radius: 8,
                    shadowPath: UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath)
    }

    // MARK: - Public functions
    func setup(type: Status, percent: Double) {
        switch type {
        case .recovery:
            titleLabel.text = "Recovery"
            separatorView.backgroundColor = Color.greenDark
        case .fatality:
            titleLabel.text = "Fatality"
            separatorView.backgroundColor = Color.black
        }

        let formattedPercent = percent * 100
        percentLabel.text = "\(formattedPercent.decimalFormat ?? "--")%"
    }
}

extension PercentRateCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(percentLabel)
    }

    func setupConstraints() {
        titleLabel.anchor(top: contentView.topAnchor,
                          leading: contentView.leadingAnchor,
                          trailing: contentView.trailingAnchor,
                          insets: .init(top: 16, left: 16, bottom: 0, right: 16))

        separatorView.anchor(height: 4, width: 24)
        separatorView.anchorCenterXToSuperview()

        percentLabel.anchor(top: separatorView.bottomAnchor,
                            leading: contentView.leadingAnchor,
                            bottom: contentView.bottomAnchor,
                            trailing: contentView.trailingAnchor,
                            insets: .init(top: 16, left: 16, bottom: 16, right: 16))
    }

    func setupAdditionalConfiguration() {
        contentView.backgroundColor = Color.white

        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
}
