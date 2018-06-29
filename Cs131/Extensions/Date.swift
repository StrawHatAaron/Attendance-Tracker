//
//  Date.swift
//  Cs131
//
//  Created by Aaron Miller on 6/29/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

import Foundation

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}
