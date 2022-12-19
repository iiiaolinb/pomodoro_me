import SwiftUI
import WidgetKit

enum Mode: String {
    case start, pause, resume
}

enum Activity: String {
    case work, chill, dinner
}

struct UserChoise {
    var pickTime = Date()
    var mode = Mode.start.rawValue
    var activity = Activity.work.rawValue
}

class PomodoroViewModel: ObservableObject {
    let title: String = "Pomodoro timer"

    func startTimer(_ userChoise: UserChoise) {
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.pickTime, forKey: "Pomodoro_time")
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.mode, forKey: "Pomodoro_mode")
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.activity, forKey: "Pomodoro_activity")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func pauseTimer() {
        let userChoise = UserChoise(pickTime: Date(), mode: Mode.pause.rawValue, activity: Mode.pause.rawValue)
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.pickTime, forKey: "Pomodoro_time")
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.mode, forKey: "Pomodoro_mode")
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.activity, forKey: "Pomodoro_activity")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func resumeTimer(_ userChoise: UserChoise) {
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.pickTime, forKey: "Pomodoro_time")
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.mode, forKey: "Pomodoro_mode")
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.activity, forKey: "Pomodoro_activity")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func resetTimer(_ userChoise: UserChoise) {
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.pickTime, forKey: "Pomodoro_time")
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.mode, forKey: "Pomodoro_mode")
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.activity, forKey: "Pomodoro_activity")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func updateActivity(_ userChoise: UserChoise) {
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.pickTime, forKey: "Pomodoro_time")
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.mode, forKey: "Pomodoro_mode")
        UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.set(userChoise.activity, forKey: "Pomodoro_activity")
        WidgetCenter.shared.reloadAllTimelines()
    }
}

