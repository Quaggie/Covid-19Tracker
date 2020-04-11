//
//  TotalCasesCell.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 10/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import Charts

final class TotalCasesCell: UICollectionViewCell {
    // MARK: - Static
    static let height: CGFloat = 319

    // MARK: - Properties
    private let circleViewHeight: CGFloat = 264

    // MARK: - Views
    private let circleView = UIView()
    private let pieChartView = CovidPieChartView()

    private lazy var verticalTotalCasesStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [totalCasesTitleLabel, totalCasesTitleValue])
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .fillProportionally
        sv.spacing = 8
        return sv
    }()
    private let totalCasesTitleLabel = UILabel(text: "total cases", font: Font.light(size: 14), textColor: Color.black)
    private let totalCasesTitleValue = UILabel(text: "", font: Font.bold(size: 26), textColor: Color.black)

    private let horizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        return sv
    }()

    // Active
    private lazy var verticalActiveStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [horizontalActiveTitleStackView, horizontalActiveValueStackView])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    private let activeBallView = BallView(color: Color.yellowLight, space: 8)
    private let activeTitleLabel = UILabel(text: "Active", font: Font.regular(size: 12), textColor: Color.black)
    private lazy var horizontalActiveTitleStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [activeBallView, activeTitleLabel, UIView()])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    private let activeTitleValueLabel = UILabel(text: "", font: Font.bold(size: 12), textColor: Color.black)
    private lazy var horizontalActiveValueStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [SpaceView(space: 8), activeTitleValueLabel, UIView()])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()

    // Recovered
    private lazy var verticalRecoveredStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [horizontalRecoveredTitleStackView, horizontalRecoveredValueStackView])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    private let recoveredBallView = BallView(color: Color.greenDark, space: 8)
    private let recoveredTitleLabel = UILabel(text: "Recovered", font: Font.regular(size: 12), textColor: Color.black)
    private lazy var horizontalRecoveredTitleStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [recoveredBallView, recoveredTitleLabel, UIView()])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    private let recoveredTitleValueLabel = UILabel(text: "", font: Font.bold(size: 12), textColor: Color.black)
    private lazy var horizontalRecoveredValueStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [SpaceView(space: 8), recoveredTitleValueLabel, UIView()])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()

    // Fatal
    private lazy var verticalFatalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [horizontalFatalTitleStackView, horizontalFatalValueStackView])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    private let fatalBallView = BallView(color: Color.black, space: 8)
    private let fatalTitleLabel = UILabel(text: "Fatal", font: Font.regular(size: 12), textColor: Color.black)
    private lazy var horizontalFatalTitleStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [fatalBallView, fatalTitleLabel, UIView()])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    private let fatalTitleValueLabel = UILabel(text: "", font: Font.bold(size: 12), textColor: Color.black)
    private lazy var horizontalFatalValueStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [SpaceView(space: 8), fatalTitleValueLabel, UIView()])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 8
        return sv
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
    override func layoutSubviews() {
        super.layoutSubviews()

        applyShadow(color: Color.black,
                    offset: CGSize(width: 3, height: 2),
                    opacity: 0.2, radius: 8,
                    shadowPath: UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath)
    }

    // MARK: - Public functions
    func setup(timeline: Timeline) {
        setupPieChart(timeline: timeline)
        totalCasesTitleValue.text = timeline.cases.decimalFormat

        activeTitleValueLabel.text = timeline.active.decimalFormat
        recoveredTitleValueLabel.text = timeline.recovered.decimalFormat
        fatalTitleValueLabel.text = timeline.deaths.decimalFormat
    }

    private func setupPieChart(timeline: Timeline) {
        var entries: [PieChartDataEntry] = []

        let entry1 = PieChartDataEntry(value: Double(timeline.active))
        entries.append(entry1)

        let entry2 = PieChartDataEntry(value: Double(timeline.recovered))
        entries.append(entry2)

        let entry3 = PieChartDataEntry(value: Double(timeline.deaths))
        entries.append(entry3)

        let set = PieChartDataSet(entries: entries)
        set.highlightEnabled = false
        set.drawValuesEnabled = false
        set.label = nil
        set.entryLabelColor = .clear
        set.setColors(Color.yellowLight, Color.greenDark, Color.black)

        let data = PieChartData(dataSet: set)
        pieChartView.data = data
    }
}

extension TotalCasesCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(circleView)
        circleView.addSubview(pieChartView)
        circleView.addSubview(verticalTotalCasesStackView)

        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(verticalActiveStackView)
        horizontalStackView.addArrangedSubview(verticalRecoveredStackView)
        horizontalStackView.addArrangedSubview(verticalFatalStackView)
    }

    func setupConstraints() {
        circleView.anchor(top: contentView.topAnchor,
                          leading: contentView.leadingAnchor,
                          trailing: contentView.trailingAnchor)
        circleView.anchor(height: circleViewHeight)

        pieChartView.anchorCenterXToSuperview()
        pieChartView.anchorCenterYToSuperview(constant: 8)
        pieChartView.anchor(height: circleViewHeight, width: circleViewHeight)

        verticalTotalCasesStackView.anchor(leading: circleView.leadingAnchor,
                                           trailing: circleView.trailingAnchor) // 68
        verticalTotalCasesStackView.anchorCenterYToSuperview()

        horizontalStackView.anchor(top: circleView.bottomAnchor,
                                   leading: contentView.leadingAnchor,
                                   bottom: contentView.bottomAnchor,
                                   trailing: contentView.trailingAnchor,
                                   insets: .init(top: 0, left: 24, bottom: 27, right: 24))
    }

    func setupAdditionalConfiguration() {
        contentView.backgroundColor = Color.white

        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
}
