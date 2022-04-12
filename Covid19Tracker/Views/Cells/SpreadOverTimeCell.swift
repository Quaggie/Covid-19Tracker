//
//  SpreadOverTimeCell.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import Charts
import CovidCharts

final class SpreadOverTimeCell: UICollectionViewCell {
    // MARK: - Static
    static let height: CGFloat = 280

    // MARK: - Views
    private let titleLabel = UILabel(text: "Spread over time", font: Font.semiBold(size: 18), textColor: Color.black)
    private let subtitleLabel = UILabel(text: "", font: Font.regular(size: 12), textColor: Color.grayDark)

    private let barChartContainerView = UIView()
    private let barChartView = CovidBarChartView()

    private let horizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        return sv
    }()

    // Confirmed
    private let confirmedBallView = BallView(color: Color.yellowLight, space: 8)
    private let confirmedTitleLabel = UILabel(text: "Confirmed", font: Font.regular(size: 12), textColor: Color.black)
    private lazy var horizontalConfirmedTitleStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [confirmedBallView, confirmedTitleLabel, UIView()])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()

    // Recovered
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

    // Fatal
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
    func setup(historicalTimelineList: [HistoricalTimelineDayInfo]) {
        if let first = historicalTimelineList.first, let last = historicalTimelineList.last {
            subtitleLabel.text = "(\(first.day) - \(last.day))"
        }

        setupBarChart(list: historicalTimelineList)
    }

    func setupBarChart(list: [HistoricalTimelineDayInfo]) {
        var confirmedEntries: [BarChartDataEntry] = []
        var recoveredEntries: [BarChartDataEntry] = []
        var fatalEntries: [BarChartDataEntry] = []

        list.enumerated().forEach { (index, info) in
            let fatalEntry = BarChartDataEntry(x: Double(index), y: Double(info.deaths))
            fatalEntries.append(fatalEntry)

            let recoveredEntry = BarChartDataEntry(x: Double(index), y: Double(info.recovered))
            recoveredEntries.append(recoveredEntry)

            let confirmedEntry = BarChartDataEntry(x: Double(index), y: Double(info.active))
            confirmedEntries.append(confirmedEntry)
        }

        let barWidth: Double = 0.18
        let groupCount: Double = 7
        let barSpace: Double = 0.02
        let groupSpace: Double = 1 - ((barWidth + barSpace) * 3)

        let confirmedSet = BarChartDataSet(entries: confirmedEntries)
        confirmedSet.setColor(Color.yellowLight)

        let recoveredSet = BarChartDataSet(entries: recoveredEntries)
        recoveredSet.label = nil
        recoveredSet.setColor(Color.greenDark)

        let fatalSet = BarChartDataSet(entries: fatalEntries)
        fatalSet.label = nil
        fatalSet.setColor(Color.black)

        let datasets: [BarChartDataSet] = [fatalSet, recoveredSet, confirmedSet]

        let data = BarChartData(dataSets: datasets)
        data.setValueTextColor(.clear)
        data.barWidth = barWidth
        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        barChartView.data = data

        barChartView.xAxis.axisMaximum = data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * groupCount

        final class ShortenedFormatter: IAxisValueFormatter {
            func stringForValue(_ value: Double, axis: AxisBase?) -> String {
                return value <= 0 ? "" : value.shortened
            }
        }
        barChartView.leftAxis.valueFormatter = ShortenedFormatter()

        final class DateValueFomatter: IAxisValueFormatter {
            func stringForValue(_ value: Double, axis: AxisBase?) -> String {
                let now = Date()
                let calendar = Calendar.current
                let brDateformatter = DateFormatter()
                brDateformatter.dateFormat = "dd/MM"

                let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
                let aWeekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
                return value <= 0 ? brDateformatter.string(from: aWeekAgo) : brDateformatter.string(from: yesterday)
            }
        }
        barChartView.xAxis.valueFormatter = DateValueFomatter()
        barChartView.setExtraOffsets(left: 16, top: 24, right: 46, bottom: 0)
    }
}

extension SpreadOverTimeCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        contentView.addSubview(barChartContainerView)
        barChartContainerView.addSubview(barChartView)

        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(horizontalConfirmedTitleStackView)
        horizontalStackView.addArrangedSubview(horizontalRecoveredTitleStackView)
        horizontalStackView.addArrangedSubview(horizontalFatalTitleStackView)
    }

    func setupConstraints() {
        titleLabel.anchor(top: contentView.topAnchor,
                          leading: contentView.leadingAnchor,
                          insets: .init(top: 16, left: 16, bottom: 0, right: 0))
        subtitleLabel.anchor(top: titleLabel.topAnchor,
                             leading: titleLabel.trailingAnchor,
                             bottom: titleLabel.bottomAnchor,
                             insets: .init(top: 0, left: 4, bottom: 0, right: 0))

        barChartContainerView.anchor(top: subtitleLabel.bottomAnchor,
                                     leading: contentView.leadingAnchor,
                                     trailing: contentView.trailingAnchor)
        barChartView.fillSuperview()

        horizontalStackView.anchor(top: barChartContainerView.bottomAnchor,
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

