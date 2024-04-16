//
//  AddNewHabit.swift
//  HabitTracker0511
//
//  Created by Lurich on 2022/5/11.
//

import SwiftUI

@available(iOS 15.0, *)
struct AddNewHabit: View {
    @EnvironmentObject var habitModel: HabitViewModel
    
    @Environment(\.self) var env
    var body: some View {
        NavigationView {
            VStack(spacing: 15){
                TextField("Title", text: $habitModel.title)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color("Dark").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                
                //habit color picker
                HStack(spacing: 0) {
                    ForEach(1...7, id: \.self) { index in
                        let color = "Card-\(index)"
                        Circle()
                            .fill(Color(color))
                            .frame(width: 30, height: 30)
                            .overlay {
                                if color == habitModel.habitColor {
                                    Image(systemName: "checkmark")
                                        .font(.caption.bold())
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    habitModel.habitColor = color
                                }
                            }
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical)
                
                Divider()
                
                //frequency selection
                VStack(alignment: .leading, spacing: 6) {
                    Text("Frequency")
                        .font(.callout.bold())
                    let weekDays = Calendar.current.weekdaySymbols
                    HStack( spacing: 10) {
                        ForEach(weekDays, id: \.self) { day in
                            let index = habitModel.weekDays.firstIndex { value in
                                return value == day
                            } ?? -1
                            Text(day.prefix(3))
                                .fontWeight(.semibold)
                                .frame(maxWidth:.infinity)
                                .padding(.vertical, 12)
                                .background{
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(index != -1 ? Color(habitModel.habitColor) : Color("Dark").opacity(0.4))
                                }
                                .onTapGesture {
                                    withAnimation {
                                        if index != -1 {
                                            habitModel.weekDays.remove(at: index)
                                        } else {
                                            habitModel.weekDays.append(day)
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.top, 15)
                }
                
                Divider()
                    .padding(.vertical, 10)
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Remainder")
                            .fontWeight(.semibold)
                        Text("Just notification")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth:.infinity, alignment: .leading)
                    
                    Toggle(isOn: $habitModel.isReaminderOn) {
                        
                    }.labelsHidden()
                }
                .opacity(habitModel.notificationAccess ? 1 : 0)
                
                HStack(spacing: 12) {
                    Label {
                        Text(habitModel.remiainderDate.formatted(date:. omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color("Dark").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .onTapGesture {
                        withAnimation {
                            habitModel.showTimePicker.toggle()
                        }
                    }
                    
                    TextField("Reaminder Title", text: $habitModel.remainderText)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color("Dark").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                }
                .frame(height: habitModel.isReaminderOn ? nil : 0)
                .opacity(habitModel.isReaminderOn ? 1 : 0)
                .opacity(habitModel.notificationAccess ? 1 : 0)
            }
            .animation(.easeInOut, value: habitModel.isReaminderOn)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(habitModel.editHabit != nil ? "Edit Habit" : "Add Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        env.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .tint(.white)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if habitModel.deleteHabit(context: env.managedObjectContext) {
                            env.dismiss()
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                    .opacity(habitModel.editHabit == nil ? 0 : 1)
                }
                
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        Task {
                            if await habitModel.addHabit(context: env.managedObjectContext) {
                                env.dismiss()
                            }
                        }
                    }
                    .tint(.white)
                    .disabled(!habitModel.doneStatus())
                    .opacity(habitModel.doneStatus() ? 1 : 0.6)
                }
            }
        }
        .background(Color.black)
        .overlay {
            if habitModel.showTimePicker {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                habitModel.showTimePicker.toggle()
                            }
                        }
                    
                    DatePicker.init("", selection: $habitModel.remiainderDate, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Dark"))
                        }
                        .padding()
                }
            }
        }
    }
}

@available(iOS 15.0, *)
struct AddNewHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddNewHabit()
            .environmentObject(HabitViewModel())
            .preferredColorScheme(.dark)
    }
}
