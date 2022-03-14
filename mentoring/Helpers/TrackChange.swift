//
//  TrackChange.swift
//  mentoring
//
//  Created by Nicolò Pasini on 08/03/22.
//

import Foundation

@propertyWrapper
struct TrackChange<Value> {

    var wrappedValue: Value {
        get {
            currentValue
        }
        set {
            previousValue = currentValue
            currentValue = newValue
        }
    }

    private(set) var currentValue: Value
    private(set) var previousValue: Value?

    init(value: Value) {
        previousValue = nil
        currentValue = value
    }
}
