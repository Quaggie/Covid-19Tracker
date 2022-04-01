//
//  SimpleCountryCasesCell.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import Kingfisher

final class SimpleCountryCasesCell: UICollectionViewCell {
    // MARK: - Static
    static let height: CGFloat = 54
    
    // MARK: - Properties
    private let imageViewSize = CGSize(width: 24, height: 24)

    // MARK: - Views
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [imageContainerView, titleLabel, UIView(), descriptionLabel])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 16
        return sv
    }()

    private let imageContainerView = UIView()
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = imageViewSize.height / 2
        iv.backgroundColor = Color.grayLight
        iv.clipsToBounds = true
        return iv
    }()
    private let numberContainerView: UIView = {
        let v = UIView(backgroundColor: Color.purpleLight)
        v.layer.cornerRadius = 4
        return v
    }()
    private let numberLabel = UILabel(text: "--º", font: Font.bold(size: 8), textColor: Color.white, textAlignment: .center)

    private let titleLabel = UILabel(text: "", font: Font.regular(size: 16), textColor: Color.black)
    private let descriptionLabel = UILabel(text: "", font: Font.regular(size: 16), textColor: Color.grayDark)

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
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { [weak self] in
                guard let self = self else { return }
                let scale: CGFloat = 0.95
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: scale, y: scale) : .identity
            })
        }
    }

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
    func setup(country: Country, index: Int) {
        if let url = URL(string: country.countryInfo.flag) {
            imageView.kf.setImage(with: url)
        }

        titleLabel.text = country.country
        descriptionLabel.text = country.cases.decimalFormat
        numberLabel.text = "\(index + 1)º"
    }
}

extension SimpleCountryCasesCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(stackView)
        imageContainerView.addSubview(imageView)
        imageContainerView.addSubview(numberContainerView)
        numberContainerView.addSubview(numberLabel)
    }

    func setupConstraints() {
        stackView.fillSuperview(insets: .init(top: 0, left: 16, bottom: 0, right: 16))
        imageContainerView.anchor(width: imageViewSize.width)

        imageView.anchorCenterXToSuperview()
        imageView.anchorCenterYToSuperview(constant: -4)
        imageView.anchor(height: imageViewSize.height, width: imageViewSize.width)

        numberContainerView.anchor(height: 12, width: 22)
        numberContainerView.anchor(top: imageView.bottomAnchor, insets: .init(top: -2, left: 0, bottom: 0, right: 0))
        numberContainerView.anchorCenterXToSuperview()

        numberLabel.anchorCenterSuperview()
    }

    func setupAdditionalConfiguration() {
        contentView.backgroundColor = Color.white

        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
}
