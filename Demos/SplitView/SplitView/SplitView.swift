
//
//  SplitView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/30.
//

import SwiftUI


struct SplitView: View {
    
    @State var bill: CGFloat = 750
    
    @State var payers = [
        
        Payer(image: "album1", name: "山治", bgColor: Color("albumColor1")),
        Payer(image: "album2", name: "艾斯", bgColor: Color("albumColor2")),
        Payer(image: "album3", name: "鹰眼", bgColor: Color("albumColor3"))
    ]
    
    @State var pay = false

    var body: some View {
        
        ZStack(alignment:.top) {
            
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack {
                    
                   Spacer(minLength: 80)
                    
                    VStack(spacing: 15, content: {
                        
                        Button(action: {}, label: {
                            
                            Text("Recipt")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color("bg"))
                                .cornerRadius(12)
                        })
                        
                        Line()
                            .stroke(Color.black, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .miter, dash: [10]))
                            .frame(height: 1)
                            .padding(.horizontal)
                        
                        HStack {
                            
                            VStack(alignment: .leading, spacing: 8, content: {
                                
                                Text("Title")
                                    .font(.caption)
                                
                                Text("Team Dinner")
                                    .font(.title2)
                                    .fontWeight(.heavy)
                            })
                            .foregroundColor(Color("bg"))
                            .frame(maxWidth: .infinity)
                            
                            VStack(alignment: .leading, spacing: 8, content: {
                                
                                Text("Total Bill")
                                    .font(.caption)
                                
                                Text(String(format: "$%.2lf", bill))
                                    .font(.title2)
                                    .fontWeight(.heavy)
                            })
                            .foregroundColor(Color("bg"))
                            .frame(maxWidth: .infinity)
                        }
                        
                        VStack {
                            HStack( spacing: -20, content: {
                                
                                ForEach(payers) { payer in
                                    
                                    Image(payer.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 45, height: 45)
                                        .clipShape(Circle())
                                        .padding(8)
                                        .background(payer.bgColor)
                                        .clipShape(Circle())
                                }
                            })
                            
                            Text("Spiliting with")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("bg"))
                        .cornerRadius(25)
                        
                    })
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("card").clipShape(BillShape()).cornerRadius(25))
                    .padding(.horizontal)
                    
                    ForEach(payers.indices, id: \.self) { index in
                        
                        PriceView(payer: $payers[index], totalAmount: bill)
                    }
                    
                    Spacer(minLength: 25)
                    
                    HStack {
                        
                        HStack(spacing: 0) {
                            
                            ForEach(1...6, id: \.self) { index  in
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20, weight: .heavy))
                                    .foregroundColor(Color.white.opacity(Double(index) * 0.06))
                            }
                        }
                        .padding(.leading, 45)
                        
                        Spacer()
                        
                        Button(action: {pay.toggle()}, label: {
                            Text("Confirm Split")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color("bg"))
                                .clipShape(Capsule())
                        })
                    }
                    .padding()
                    .background(Color.black.opacity(0.25))
                    .clipShape(Capsule())
                    .padding()
                }
            })
//            .offset(y: 80)
            
            HStack {
                
                Button(action: {pay.toggle()}, label: {
                    
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(Color("card"))
                        .padding()
                        .background(Color.black.opacity(0.25))
                        .cornerRadius(15)
                })
                
                Spacer()
            }
            .padding()
        }
        .background(Color("PurpleBG").ignoresSafeArea(.all, edges: .all))
        // Alert View
        .alert(isPresented: $pay, content: {
            Alert(title: Text("Alert"), message: Text("Confirm To Spilit Pay"), primaryButton: .default(Text("Pay"), action: {
                
            }), secondaryButton: .destructive(Text("Cancel")))
        })
        
    }
}


struct PriceView: View {
    
    @Binding var payer: Payer
    
    var  totalAmount: CGFloat
    var body: some View {
        
        VStack(spacing: 15, content: {
            
            HStack {
                
                Image(payer.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                    .padding(8)
                    .background(payer.bgColor)
                    .clipShape(Circle())
                
                Text(payer.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(getPrice())
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            }
            
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center), content: {
                
                Capsule()
                    .fill(Color.black.opacity(0.25))
                    .frame(height: 30)
                
                Capsule()
                    .fill(payer.bgColor)
                    .frame(width:payer.offset + 20, height: 30)
                
                HStack( spacing: (UIScreen.main.bounds.width - 90) / 12, content: {
                    
                    ForEach(1..<12, id: \.self) { index in
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: index % 4 == 0 ? 7 : 4, height: index % 4 == 0 ? 7 : 4)
                    }
                })
                .padding(.leading)
                
                Circle()
                    .fill(Color("card"))
                    .frame(width: 35, height: 35)
                    .background(Circle().stroke(Color.white, lineWidth: 5))
                    .offset(x: payer.offset)
                    .gesture(DragGesture().onChanged({ (value) in
                        
                        // padding Hor = 30 Circle rad = 20
                        if value.location.x >= 20 && value.location.x <= UIScreen.main.bounds.width - 50 {
                            payer.offset = value.location.x - 20
                        }
                    }))
            })
        })
        .padding()
    }
    
    func getPrice() -> String {
        
        let percent = payer.offset / (UIScreen.main.bounds.width - 70)
        
        let amount = percent * (totalAmount / 3)
        return String(format: "$%.2lf", amount)
    }
}

struct Line: Shape {
    
    func path(in rect: CGRect) -> Path {
         
        return Path { path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}


struct BillShape: Shape {
    
    func path(in rect: CGRect) -> Path {
            
        return Path { path in

            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            
            path.move(to: CGPoint(x: 0, y: 75))
            path.addArc(center: CGPoint(x: 0, y: 75), radius: 20, startAngle: .init(degrees: -90), endAngle: .init(degrees: 90), clockwise: false)
            
            path.move(to: CGPoint(x: rect.width, y: 75))
            path.addArc(center: CGPoint(x: rect.width, y: 75), radius: 20, startAngle: .init(degrees: 90), endAngle: .init(degrees: -90), clockwise: false)
        }
    }
}

struct Payer : Identifiable {
    
    var id = UUID().uuidString
    var image: String
    var name: String
    var bgColor: Color
    var offset: CGFloat = 0
}



struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView()
    }
}
