//
//  CovidBarChartView.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import Charts

final class CovidBarChartView: BarChartView {

    override var isDragDecelerationEnabled: Bool {
        return false
    }

    override var legendRenderer: LegendRenderer! {
        let vph = ViewPortHandler(width: 0, height: 0)
        return LegendRenderer(viewPortHandler: vph, legend: nil)
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        let desc = Description()
        desc.enabled = false
        self.chartDescription = desc

        isUserInteractionEnabled = false

        xAxis.axisMinimum = 0
        xAxis.drawGridLinesEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.labelFont = Font.semiBold(size: 10)
        xAxis.labelTextColor = Color.grayDark
        xAxis.setLabelCount(2, force: true)

        leftAxis.axisMinimum = 0
        leftAxis.gridColor = Color.grayLight
        leftAxis.labelFont = Font.regular(size: 8)
        leftAxis.labelTextColor = Color.grayDark
        leftAxis.drawAxisLineEnabled = false
        leftAxis.setLabelCount(5, force: true)

        rightAxis.enabled = false
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
