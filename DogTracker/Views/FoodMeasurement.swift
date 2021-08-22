//
//  FoodMeasurement.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/22/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation


class FoodMeasurement: Codable {
    
    var amount: Int
    var measurement: MeasurmentType
    
    init(amount: Int, measurement: MeasurmentType) {
        self.amount = amount
        self.measurement = measurement
    }
    
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case measurement = "measurement"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decode(Int.self, forKey: .amount)
        measurement = try container.decode(MeasurmentType.self, forKey: .measurement)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(measurement, forKey: .measurement)
    }
    
    
}

extension FoodMeasurement: Equatable {
    static func == (lhs: FoodMeasurement, rhs: FoodMeasurement) -> Bool {
        lhs.amount == rhs.amount &&
            lhs.measurement == rhs.measurement
    }
}
