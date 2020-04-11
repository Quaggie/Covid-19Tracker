//
//  CovidPieChartView.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit
import Charts

final class CovidPieChartView: PieChartView {
    override var isDrawEntryLabelsEnabled: Bool {
        return false
    }

    override var isRotationEnabled: Bool {
        return false
    }

    override var isDrawMarkersEnabled: Bool {
        return false
    }

    override var isDrawCenterTextEnabled: Bool {
        return false
    }

    override var isHighLightPerTapEnabled: Bool {
        return false
    }

    override var isUsePercentValuesEnabled: Bool {
        return false
    }

    override var isDragDecelerationEnabled: Bool {
        return false
    }

    override var legendRenderer: LegendRenderer! {
        let vph = ViewPortHandler(width: 0, height: 0)
        return LegendRenderer(viewPortHandler: vph, legend: nil)
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.holeRadiusPercent = 0.80

        self.transparentCircleColor = Color.white
        self.transparentCircleRadiusPercent = 0.83

        let desc = Description()
        desc.enabled = false
        self.chartDescription = desc

        self.drawEntryLabelsEnabled = false
        setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)

        highlightValues(nil)
        isUserInteractionEnabled = false
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
