//
//  NewsCell.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 27/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import Kingfisher

final class NewsCell: UICollectionViewCell {
    // MARK: - Static
    static let height: CGFloat = 245

    // MARK: - Views
    private lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = Color.grayLight
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    private let titleLabel = UILabel(text: "", font: Font.semiBold(size: 14), textColor: Color.black, numberOfLines: 2)
    private let separatorView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2
        return v
    }()
    private let sourceLabel: UILabel = {
        let lbl = UILabel(text: "", font: Font.regular(size: 11), textColor: Color.grayDark)
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    private lazy var dateImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "calendar_icon")?.withRenderingMode(.alwaysTemplate))
        iv.tintColor = Color.grayDark
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let dateLabel = UILabel(text: "", font: Font.regular(size: 11), textColor: Color.grayDark)


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
        postImageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        applyShadow(color: Color.black,
                    offset: CGSize(width: 3, height: 2),
                    opacity: 0.2, radius: 8,
                    shadowPath: UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath)
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { [weak self] in
                guard let self = self else { return }
                let scale: CGFloat = 0.95
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: scale, y: scale) : .identity
            })
        }
    }

    // MARK: - Public functions
    func setup(model: News, index: Int) {
        postImageView.kf.setImage(with: URL(string: model.urlToImage))
        titleLabel.text = model.title
        separatorView.backgroundColor = model.color(forIndex: index)
        sourceLabel.text = model.source.name
        dateLabel.text = model.publishedAt
    }
}

extension NewsCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(postImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(dateImageView)
        contentView.addSubview(dateLabel)
    }

    func setupConstraints() {
        postImageView.anchor(top: contentView.topAnchor,
                             leading: contentView.leadingAnchor,
                             trailing: contentView.trailingAnchor)
        postImageView.anchor(height: 136)

        titleLabel.anchor(top: postImageView.bottomAnchor,
                          leading: contentView.leadingAnchor,
                          trailing: contentView.trailingAnchor,
                          insets: .init(top: 16, left: 16, bottom: 0, right: 16))

        separatorView.anchor(top: titleLabel.bottomAnchor,
                             leading: contentView.leadingAnchor,
                             insets: .init(top: 4, left: 16, bottom: 0, right: 0))
        separatorView.anchor(height: 4, width: 24)

        sourceLabel.anchor(leading: contentView.leadingAnchor,
                           bottom: contentView.bottomAnchor,
                           insets: .init(top: 0, left: 16, bottom: 16, right: 0))

        dateImageView.anchor(height: 10, width: 10)
        dateImageView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true

        dateLabel.anchor(leading: dateImageView.trailingAnchor,
                         bottom: contentView.bottomAnchor,
                         trailing: contentView.trailingAnchor,
                         insets: .init(top: 0, left: 5, bottom: 16, right: 16))
    }

    func setupAdditionalConfiguration() {
        contentView.backgroundColor = Color.white

        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
}


