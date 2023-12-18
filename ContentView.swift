//
//  ContentView.swift
//  EzMeds
//
//  Created by Ryan Kiswii on 12/15/23.
//
import SwiftUI
import UserNotifications

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isBreakTime = false
    @State private var breakCountdown = 0 // Countdown in seconds
    let breakLengthInMinutes = 10 // Default break length
    let breakFrequencyInMinutes = 60 // Default break frequency
    @State private var isPaused = false
    
    var body: some View {
        ZStack {
            // Radial gradient from the circle edge to the background
            
            VStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(RadialGradient (
                            gradient: Gradient(colors: [Color.red.opacity(0.9), Color.clear]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 300
                        ))
                        .frame(width: 300, height: 300)
                      
                    
                    Text(timeString(from: breakCountdown))
                        .foregroundColor(.black)
                        .font(.title)
                    
                    VStack {
                        Spacer()
                        Image("meditation")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .aspectRatio(contentMode: .fit)
                            .padding(.top, 100)
                    }
                }
                .padding()
                
                Spacer()
                
                // Pause button at the bottom
                if isBreakTime{
                    if isPaused{
                        Button(action: {
                            resumeTimer()
                        }) {
                            Text("Resume")
                                .frame(width: 50, height: 50)
                                .foregroundColor(.black)
                        }
                        .padding(.bottom, 10)
                    } else{
                        Button(action: {
                        pauseTimer()
                    }) {
                        Text("Pause")
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 10)
                }
            }
                
                // Buttons
                HStack {
                    if isBreakTime {
                        Button(action: {
                            resetTimer()
                        }) {
                            Text("Reset Timer")
                                .padding()
                                .foregroundColor(Color.orange)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        Button(action: {
                            endBreak()
                            resetTimer()
                        }) {
                            Text("End Break")
                                .padding()
                                .foregroundColor(.red)
                                .cornerRadius(10)
                            
                                .padding()
                        }
                    } else {
                        Button(action: {
                            startBreak()
                            resumeTimer()
                        }) {
                            Text("Start Break")
                                .padding()
                                .foregroundColor(.green)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
            .padding()
        }
        //Setting the background based on system appearance
        .background(colorScheme == .dark ? Color.black : Color.white)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if isBreakTime && breakCountdown > 0 && !isPaused {
                breakCountdown -= 1
            }
        }
    }
    
    func startBreak() {
        isBreakTime = true
        breakCountdown = breakLengthInMinutes * 60
        scheduleBreakNotification()
    }
    
        func resumeTimer(){
            isPaused = false
        }
    
    func pauseTimer() {
        isPaused = true
        // Add logic to pause the timer
    }
    
    func resetTimer() {
        isBreakTime = false
        breakCountdown = 0 // Reset timer value
    }
    
    func endBreak() {
        isBreakTime = false
        // Add logic to dismiss break UI, stop countdown, reset values
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func scheduleBreakNotification() {
        let content = UNMutableNotificationContent()
        content.title = "It's break time!"
        content.body = "Take a break now."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(breakFrequencyInMinutes * 60), repeats: true)
        let request = UNNotificationRequest(identifier: "breakNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

