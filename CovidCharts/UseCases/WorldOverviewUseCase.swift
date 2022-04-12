//
//  WorldOverviewUseCase.swift
//  Domain
//
//  Created by Jonathan Bijos on 09/04/22.
//  Copyright © 2022 DevsCarioca. All rights reserved.
//

public protocol WorldOverviewUseCase {
    func fetch(completion: @escaping (Result<WorldOverview, ConnectionError>) -> Void)
}
