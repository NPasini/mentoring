//
//  AppState.swift
//  mentoring
//
//  Created by Nicolò Pasini on 08/03/22.
//

import Foundation

enum AppState {
    /// The app as just been launched
    case launched
    /// The app has been resumed from the background
    case active
    /// The app has been moved to background
    case inactive
}
