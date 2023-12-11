//
//  ContentView.swift
//  Clock
//
//  Created by 亚飞 on 2021/1/20.
//

import SwiftUI

@available(iOS 15.0, *)
struct ClockView: View {
    @State var isDark = false
    var body: some View {
        ClockHomeView(isDark: $isDark)
            .navigationBarHidden(true)
            .preferredColorScheme(isDark ? .dark : .light)
        
    }
}

@available(iOS 15.0, *)
struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView()
    }
}

@available(iOS 15.0, *)
private struct ClockHomeView : View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isDark: Bool
    var width  = UIScreen.main.bounds.width
    @State var current_time = Time(sec: 0, min: 0, hour: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    
    var body : some View {
        
        VStack {
            
            HStack {
                
                Text("Analog Clock")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Spacer(minLength: 0)
                
                Button(action: {
                    isDark.toggle()
                }) {
                    Image(systemName: isDark ? "sun.min.fill" : "moon.fill")
                        .font(.system(size: 22))
                        .foregroundColor(isDark ? .black : .white)
                        .padding()
                        .background(Color.primary)
                        .clipShape(Circle())
                }
                
            }
            .padding()
            
            Spacer(minLength: 0)
            
            ZStack {
                Circle()
                    .fill(Color("Color").opacity(0.1))
                
                ForEach(0..<60, id:\.self) { i in
                    
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2, height: i % 5 == 0 ? 15 : 5)
                        .offset(y:(width - 120) / 2)
                        .rotationEffect(.init(degrees: Double(i * 6)))
                    
                }
                
                // sec
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: 2, height: (width - 180) / 2)
                    .cornerRadius(1)
                    .offset(y : -(width - 180) / 4)
                    .rotationEffect(.init(degrees: Double(current_time.sec * 6)))
                
                // min
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4, height: (width - 200) / 2)
                    .cornerRadius(2)
                    .offset(y : -(width - 200) / 4)
                    .rotationEffect(.init(degrees: Double(current_time.min) * 6.0 + Double(current_time.sec) / 10.0))
                
                // hour
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 6, height: (width - 240) / 2)
                    .cornerRadius(3)
                    .offset(y : -(width - 240) / 4)
                    .rotationEffect(.init(degrees: Double(current_time.hour) * 30 + Double( current_time.min) * 5 / 10))
                
                Circle()
                    .fill(Color.primary)
                    .frame(width: 15, height: 15)
                
                
            }
            .frame(width: width - 80, height: width - 80)
            
            Spacer(minLength: 0)
            
            Text(getDateString())
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 35)
            
            Text(getTime())
                .font(.system(size: 45))
                .fontWeight(.heavy)
                .padding(.top, 10)
            
            Spacer(minLength: 0)
            
        }
        .onAppear(perform: {
            let calender = Calendar.current
            let min = calender.component(.minute, from: Date())
            let sec = calender.component(.second, from: Date())
            let hour = calender.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.1)) {
                self.current_time = Time(sec: sec, min: min, hour: hour)
            }
        })
        .onReceive(receiver){ _ in
            
            let calender = Calendar.current
            let min = calender.component(.minute, from: Date())
            let sec = calender.component(.second, from: Date())
            let hour = calender.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0)) {
                self.current_time = Time(sec: sec, min: min, hour: hour)
            }
            
        }
        
    }
    
    func getTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "h:mm a"
        return format.string(from: Date())
    }
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}


// Calculating time ....
struct Time {
    var sec: Int
    var min: Int
    var hour: Int
}
