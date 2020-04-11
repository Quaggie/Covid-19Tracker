//
//  BallView.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 10/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class BallView: SpaceView {
    init(color: UIColor, space: CGFloat) {
        super.init(space: space)
        self.backgroundColor = color
        self.layer.cornerRadius = space / 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
