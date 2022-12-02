//
//  ContentView.swift
//  Pomodoro_me
//
//  Created by Егор Худяев on 25.11.2022.
//

import SwiftUI
import Combine
import Foundation

struct ContentView: View {
    
    @State private var workTime = 25
    @State private var chillTime = 5
    @State private var setsCount = 4
    @State private var breakTime = 30
    
    @State private var timer: Timer?
    @State private var secondsForTimer = 1500
    @State private var titleWord = "start"
    
    @State private var currentActivity = Activity.work.rawValue
    @State private var nextActivity = Activity.chill.rawValue
    @State private var currentSetsCount = 0
    
    @State private var press = false
    
    @State private var buttonMode: Mode = .start
    
    @State private var percent: Double = 0
    @State private var step: Double = 0 
    
    let screenSize = UIScreen.main.bounds
    
    enum Mode: String {
        case start, pause, resume
    }
    
    enum Activity: String {
        case work, chill, dinner
    }
    
    var body: some View {
        ZStack {
            CircleWaveView(percent: percent)
                .animation(.linear(duration: 1), value: percent)
            
            VStack {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                            .shadow(color: .black, radius: 2, x: 2, y: 2)
                        VStack {
                            Text("work time")
                                .padding(.top)
                                .minimumScaleFactor(0.6)
                            Picker("", selection: self.$workTime) {
                                ForEach(1...60, id: \.self) {
                                        Text("\($0)")
                                }
                            }
                            .minimumScaleFactor(0.5)
                            .padding([.leading, .bottom, .trailing])
                            .pickerStyle(.wheel)
                            .frame(width: screenSize.width/5, height: screenSize.height/6, alignment: .center)
                            .clipped()
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                            .shadow(color: .black, radius: 2, x: 2, y: 2)
                        VStack {
                            Text("chill time")
                                .padding(.top)
                                .minimumScaleFactor(0.6)
                            Picker("", selection: $chillTime) {
                                ForEach(1...60, id: \.self) {
                                        Text("\($0)")
                                }
                            }
                            .minimumScaleFactor(0.5)
                            .padding([.leading, .bottom, .trailing])
                            .pickerStyle(.wheel)
                            .frame(width: screenSize.width/5, height: screenSize.height/6, alignment: .center)
                            .clipped()
                        }
                        
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                            .shadow(color: .black, radius: 2, x: 2, y: 2)
                        VStack {
                            Text("sets count")
                                .padding(.top)
                                .minimumScaleFactor(0.6)
                            Picker("sets count", selection: $setsCount, content: {
                                ForEach(2...99, id: \.self) {
                                        Text("\($0)")
                                }
                            })
                            .minimumScaleFactor(0.5)
                            .padding([.leading, .bottom, .trailing])
                            .pickerStyle(.wheel)
                            .frame(width: screenSize.width/5, height: screenSize.height/6, alignment: .center)
                            .clipped()
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                            .shadow(color: .black, radius: 2, x: 2, y: 2)
                        VStack {
                            Text("break time")
                                .padding(.top)
                                .minimumScaleFactor(0.6)
                            Picker("", selection: self.$breakTime) {
                                ForEach(1...60, id: \.self) {
                                        Text("\($0)")
                                }
                            }
                            .minimumScaleFactor(0.5)
                            .padding([.leading, .bottom, .trailing])
                            .pickerStyle(.wheel)
                            .frame(width: screenSize.width/5, height: screenSize.height/6, alignment: .center)
                            .clipped()
                        }
                    }
                }
                .frame(width: screenSize.width - 30, height: screenSize.height/5)
                .padding(.top, 30.0)
                
                VStack {
                    
                    Text("now: \(currentActivity)")
                        .font(.custom("digital_dream_fat", size: 25))
                        
                    HStack {
                        Text("\(self.secondsForTimer/60)")
                            .multilineTextAlignment(.center)
                            .frame(width: screenSize.width/2 - 15, height: screenSize.height/5*2)
                            .font(Font.custom("digital_dream_fat", size: 100))
                        
                        Text("\(self.secondsForTimer % 60)")
                            .frame(width: screenSize.width/2 - 15, height: screenSize.height/5*2)
                            .font(Font.custom("digital_dream_fat", size: 100))
                    }
                
                    Text("next: \(nextActivity)")
                        .font(.custom("digital_dream_fat", size: 25))
                }
                .padding()
                    
                    Button {
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray)
                                .opacity(press ? 1 : 0)
                                .scaleEffect(press ? 1 : 0)
                                .frame(width: 60, height: 60)
                                .shadow(color: .black, radius: 2, x: 2, y: 2)
                                .animation(.spring(response: 0.5, dampingFraction: 0.4, blendDuration: 0))
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray)
                                .opacity(press ? 0 : 1)
                                .scaleEffect(press ? 0 : 1)
                                .frame(width: 60, height: 60)
                                .shadow(color: .black, radius: 2, x: 2, y: 2)
                                .animation(.spring(response: 0.5, dampingFraction: 0.4, blendDuration: 0))
                                
                            if let imageName = UIImage(named: titleWord) {
                                Image(uiImage: imageName)
                                    .scaleEffect(1.5)
                            }
                        }
                    }
                    .padding(.bottom, 30.0)
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 1.5)
                            .onChanged({ value in
                                
                            })
                            .onEnded({ _ in
                                press.toggle()
                                titleWord = Mode.start.rawValue
                                timerReset()
                            })
                    )
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded({ _ in
                                switch buttonMode {
                                case .start:
                                    titleWord = Mode.pause.rawValue
                                    timerStart()
                                case .pause:
                                    titleWord = Mode.start.rawValue
                                    timerPause()
                                case .resume:
                                    titleWord = Mode.pause.rawValue
                                    timerResume()
                                }
                            })
                    )
            }
            .padding(.vertical, 50.0)
        }
    }
    
    private func timerStart() {
        buttonMode = .pause
        secondsForTimer = workTime * 60
        
        step = (Double(screenSize.height)/Double(workTime*60))/(Double(screenSize.height)/100)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            secondsForTimer -= 1
            percent += step
            
            timerSupport()
        })
    }
    
    private func timerPause() {
        buttonMode = .resume
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            secondsForTimer -= 0
        })
    }
    
    private func timerResume() {
        self.buttonMode = .pause
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            secondsForTimer -= 1
            percent += step
            
            timerSupport()
        })
    }
    
    private func timerReset() {
        buttonMode = .start
        timer?.invalidate()
        secondsForTimer = workTime * 60
        percent = 0
        currentActivity = Activity.work.rawValue
    }
    
    private func timerSupport() {
        if secondsForTimer <= 0 {
            switch currentActivity {
            case Activity.work.rawValue:
                currentSetsCount += 1
                if currentSetsCount == setsCount {
                    currentActivity = Activity.chill.rawValue
                    nextActivity = Activity.dinner.rawValue
                    secondsForTimer = chillTime * 60
                    step = -(Double(screenSize.height)/Double(chillTime*60))/(Double(screenSize.height)/100)
                } else {
                    currentActivity = Activity.chill.rawValue
                    nextActivity = Activity.work.rawValue
                    secondsForTimer = chillTime * 60
                    step = -(Double(screenSize.height)/Double(chillTime*60))/(Double(screenSize.height)/100)
                }
            case Activity.chill.rawValue:
                if currentSetsCount == setsCount {
                    currentActivity = Activity.dinner.rawValue
                    nextActivity = Activity.work.rawValue
                    secondsForTimer = breakTime * 60
                    step = (Double(screenSize.height)/Double(breakTime*60))/(Double(screenSize.height)/100)
                    currentSetsCount = 0
                } else {
                    currentActivity = Activity.work.rawValue
                    nextActivity = Activity.chill.rawValue
                    secondsForTimer = workTime * 60
                    step = (Double(screenSize.height)/Double(workTime*60))/(Double(screenSize.height)/100)
                }
            case Activity.dinner.rawValue:
                currentActivity = Activity.work.rawValue
                nextActivity = Activity.chill.rawValue
                secondsForTimer = workTime * 60
                step = (Double(screenSize.height)/Double(workTime*60))/(Double(screenSize.height)/100)
                currentSetsCount = 0
                timer?.invalidate()
                titleWord = Mode.start.rawValue
            default:
                print("default")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIPickerView {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}


