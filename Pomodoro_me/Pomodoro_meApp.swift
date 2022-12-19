//
//  Pomodoro_meApp.swift
//  Pomodoro_me
//
//  Created by Егор Худяев on 25.11.2022.
//

import SwiftUI

@main
struct Pomodoro_meApp: App {
    var body: some Scene {
        WindowGroup {
            PomodoroView(viewModel: PomodoroViewModel())
        }
    }
}
