//
//  TinderCard.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/2/19.
//

import SwiftUI

@available(iOS 15.0, *)
struct TinderCard: View {
    @StateObject var homeData = HomeViewModel()
    var body: some View {
        VStack {
            //user stack
            ZStack {
                if let users = homeData.displaying_users {
                    if users.isEmpty {
                        Text("暂无卡片")
                            .font(.caption)
                            .foregroundColor(.gray )
                    }
                    else {
                        ForEach(users.reversed()) { user in
                            // cards
                            StackCardView(user: user)
                                .environmentObject(homeData)
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .padding(.top,30)
            .padding()
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // button
            HStack(spacing: 20) {
                
                Button {
                    //trash
                    doSwipe()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                
                Button {
                    //like
                    doSwipe(rightSwipe: true)
                } label: {
                    Image(systemName: "heart")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.red)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }

            }
            .padding(.bottom)
            .disabled(homeData.displaying_users?.isEmpty ?? false)
            .opacity((homeData.displaying_users?.isEmpty ?? false) ? 0.6 : 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationBarItems(trailing:
            Button {
                homeData.reloadData()
            } label: {
                Image(systemName: "menucard.fill")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .overlay {
//                Text("Card View")
//                    .font(.title.bold())
//            }
//            .foregroundColor(.black)
//            .padding()
        )
        .navigationBarTitle("Card View")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func doSwipe(rightSwipe: Bool = false) {
        guard let firstCard = homeData.displaying_users?.first else {
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name("ACTIONFROMBUTTON"), object: nil, userInfo: [
            "id": firstCard.id,
            "rightSwipe": rightSwipe
        ])
    }
}


@available(iOS 15.0, *)
struct TinderCard_Previews: PreviewProvider {
    static var previews: some View {
        TinderCard()
    }
}
