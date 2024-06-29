//
//  TimePicker.swift
//  CustomTimePicker
//
//  Created by Lurich on 2024/6/29.
//

import SwiftUI

struct TimePicker: View {
    var style: AnyShapeStyle = .init(.bar)
    @Binding var hour: Int
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    var body: some View {
        HStack(spacing: 0) {
            CustomView("时", 0..<24, $hour)
            CustomView("分", 0..<60, $minutes)
            CustomView("秒", 0..<60, $seconds)
        }
        .offset(x: -25)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(style)
                .frame(height: 35)
        }
    }
    @ViewBuilder
    private func CustomView(_ title: String, _ range: Range<Int>, _ selection: Binding<Int>) -> some View {
        PickerViewWithoutIndicator(selection: selection) {
            ForEach(range, id: \.self) { value in
                Text("\(value)")
                    .font(.headline)
                    .frame(width: 35, alignment: .trailing)
                    .tag(value)
            }
        }
        .overlay {
            Text(title)
                .font(.callout)
                .fontWeight(.bold)
                .frame(width: 50, alignment: .leading)
                .lineLimit(1)
                .offset(x: 50)
        }
    }
}

#Preview {
    ContentView()
}

fileprivate
struct PickerViewWithoutIndicator<Content: View, Selection: Hashable>: View {
    @Binding var selection: Selection
    @ViewBuilder var content: Content
    @State private var isHidden: Bool = false
    
    var body: some View {
        Picker("", selection: $selection) {
            if (!isHidden) {
                RemovePickerIndicator {
                    isHidden = true
                }
            } else {
                content
            }
        }
        .pickerStyle(.wheel)
    }
}
fileprivate
struct RemovePickerIndicator: UIViewRepresentable {
    var result: () -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let pickerView = view.pickerView, pickerView.subviews.count > 1 {
                pickerView.subviews[1].backgroundColor = .clear
                result()
            }
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
fileprivate
extension UIView {
    var pickerView: UIPickerView? {
        if let view = superview as? UIPickerView {
            return view
        }
        return superview?.pickerView
    }
}
