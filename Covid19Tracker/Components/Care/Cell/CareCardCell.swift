//
//  CareCardCell.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 14/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class CareCardCell: UICollectionViewCell {
    // MARK: - Static
    static let height: CGFloat = 148

    // MARK: - Properties
    private let imageViewSize = CGSize(width: 116, height: 102)

    // MARK: - Views
    private let titleLabel = UILabel(text: "", font: Font.semiBold(size: 16), textColor: Color.black)
    private let separatorView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2
        return v
    }()
    private let descriptionLabel: UILabel = {
        let lbl = UILabel(text: "", font: Font.regular(size: 12), textColor: Color.grayDark, numberOfLines: 0)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
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

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        applyShadow(color: Color.black,
                    offset: CGSize(width: 3, height: 2),
                    opacity: 0.2, radius: 8,
                    shadowPath: UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath)
    }

    // MARK: - Public functions
    func setup(model: CareModel) {
        titleLabel.text = model.title
        separatorView.backgroundColor = model.color
        descriptionLabel.text = model.description
        imageView.image = model.image
    }
}

extension CareCardCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(imageView)
    }

    func setupConstraints() {
        titleLabel.anchor(top: contentView.topAnchor,
                          leading: contentView.leadingAnchor,
                          trailing: imageView.leadingAnchor,
                          insets: .init(top: 16, left: 16, bottom: 0, right: 8))

        separatorView.anchor(top: titleLabel.bottomAnchor,
                             leading: contentView.leadingAnchor,
                             insets: .init(top: 4, left: 16, bottom: 0, right: 0))
        separatorView.anchor(height: 4, width: 24)

        descriptionLabel.anchor(top: separatorView.bottomAnchor,
                                leading: contentView.leadingAnchor,
                                trailing: imageView.leadingAnchor,
                                insets: .init(top: 15, left: 16, bottom: 0, right: 8))
        descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16).isActive = true

        imageView.anchor(bottom: contentView.bottomAnchor,
                         trailing: contentView.trailingAnchor,
                         insets: .init(top: 0, left: 0, bottom: 0, right: 8))
        imageView.anchor(height: imageViewSize.height, width: imageViewSize.width)
    }

    func setupAdditionalConfiguration() {
        contentView.backgroundColor = Color.white

        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
}
