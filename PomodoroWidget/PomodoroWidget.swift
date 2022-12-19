import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        
        let time = UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.object(forKey: "Pomodoro_time") as? Date ?? Date()
        let activity = UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.string(forKey: "Pomodoro_activity") ?? ""
        let mode = UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.string(forKey: "Pomodoro_mode") ?? ""
        
        return SimpleEntry(date: Date(), time: time, mode: mode, activity: activity, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        let time = UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.object(forKey: "Pomodoro_time") as? Date ?? Date()
        let activity = UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.string(forKey: "Pomodoro_activity") ?? ""
        let mode = UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.string(forKey: "Pomodoro_mode") ?? ""
        
        let entry = SimpleEntry(date: Date(), time: time, mode: mode, activity: activity, configuration: ConfigurationIntent())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let time = UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.object(forKey: "Pomodoro_time") as? Date ?? Date()
        let activity = UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.string(forKey: "Pomodoro_activity") ?? ""
        let mode = UserDefaults(suiteName: "group.hoodyHoop.pomodoro")?.string(forKey: "Pomodoro_mode") ?? ""
        
        entries.append(SimpleEntry(date: Date(), time: time, mode: mode, activity: activity, configuration: ConfigurationIntent()))

        let refresh = Calendar.current.date(byAdding: .minute , value: 1, to: Date())!
        print("refreshed")
        
        let timeline = Timeline(entries: entries, policy: .after(refresh))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    
    let time: Date
    var endTime: Date?
    let mode: String
    let activity: String
    
    let configuration: ConfigurationIntent
}

struct PomodoroWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment (\.widgetFamily) var widgetFamily

    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5))
            VStack {
                HStack {
                    Image(uiImage: UIImage(named: "pomodoro") ?? UIImage())
                        .resizable()
                        .scaledToFit()

                    Text("Pomodoro me")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                }
                .padding(.top, 15.0)
                
                Text(entry.mode == "pause" ? "||" : "\(entry.time - Date().timeIntervalSinceNow, style: .timer)")
                    .font(.system(size: 40, weight: .ultraLight, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("now: \(entry.activity)")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .padding(.bottom, 15.0)
                    
            }
        }
    }
}

@main
struct WidgetsBundle: WidgetBundle {
    var body: some Widget {
        PomodoroSmallWidget()
    }
}

struct PomodoroSmallWidget: Widget {
    let kind: String = "PomodoroSmallWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PomodoroWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Pomodoro widget")
        .description("Widget with pomodoro timer")
        .supportedFamilies([.systemSmall])
    }
}

struct PomodoroWidget_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroWidgetEntryView(entry: SimpleEntry(date: Date(), time: Date(), mode: "", activity: "", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
