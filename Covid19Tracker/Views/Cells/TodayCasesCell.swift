//
//  TodayCasesCell.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class TodayCasesCell: UICollectionViewCell {
    // MARK: - Static
    static let height: CGFloat = 148

    // MARK: - Views
    private let titleLabel = UILabel(text: "Today", font: Font.semiBold(size: 18), textColor: Color.black)
    private let subtitleLabel = UILabel(text: "", font: Font.regular(size: 12), textColor: Color.grayDark)

    private lazy var newCasesStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [newCasesTitleLabel, UIView(), newCasesValueLabel])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()
    private let newCasesTitleLabel = UILabel(text: "New cases", font: Font.semiBold(size: 18), textColor: Color.black)
    private let newCasesValueLabel = UILabel(text: "", font: Font.regular(size: 16), textColor: Color.black)

    private let separatorView = UIView(backgroundColor: Color.grayLight)

    private lazy var deathsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [deathsTitleLabel, UIView(), deathsValueLabel])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()
    private let deathsTitleLabel = UILabel(text: "Deaths", font: Font.semiBold(size: 18), textColor: Color.black)
    private let deathsValueLabel = UILabel(text: "", font: Font.regular(size: 16), textColor: Color.black)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()

        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let formattedDate = formatter.string(from: now)
        subtitleLabel.text = "(\(formattedDate))"
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
    func setup(timeline: Timeline) {
        newCasesValueLabel.text = timeline.todayCases.decimalFormat
        deathsValueLabel.text = timeline.todayDeaths.decimalFormat
    }
}

extension TodayCasesCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        contentView.addSubview(newCasesStackView)
        contentView.addSubview(separatorView)
        contentView.addSubview(deathsStackView)
    }

    func setupConstraints() {
        titleLabel.anchor(top: contentView.topAnchor,
                          leading: contentView.leadingAnchor,
                          insets: .init(top: 16, left: 16, bottom: 0, right: 0))
        subtitleLabel.anchor(leading: titleLabel.trailingAnchor,
                             bottom: titleLabel.bottomAnchor,
                             insets: .init(top: 0, left: 4, bottom: 0, right: 0))

        newCasesStackView.anchor(top: titleLabel.bottomAnchor,
                                 leading: contentView.leadingAnchor,
                                 trailing: contentView.trailingAnchor,
                                 insets: .init(top: 24, left: 16, bottom: 0, right: 16))

        separatorView.anchor(top: newCasesStackView.bottomAnchor,
                             leading: contentView.leadingAnchor,
                             trailing: contentView.trailingAnchor,
                             insets: .init(top: 10, left: 16, bottom: 0, right: 16))
        separatorView.anchor(height: 1)

        deathsStackView.anchor(top: separatorView.bottomAnchor,
                               leading: contentView.leadingAnchor,
                               bottom: contentView.bottomAnchor,
                               trailing: contentView.trailingAnchor,
                               insets: .init(top: 20, left: 16, bottom: 16, right: 16))
    }

    func setupAdditionalConfiguration() {
        contentView.backgroundColor = Color.white

        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
}
