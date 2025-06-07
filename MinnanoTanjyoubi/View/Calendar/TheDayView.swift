//
//  TheDayView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SwiftUI

struct TheDayView: View {
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    public let theDay: SCDate

    @State private var isShowDetailView: Bool = false

    var body: some View {
        VStack {
            if theDay.day == -1 {
                Color.gray
                    .opacity(0.2)
            } else {
                VStack(spacing: 0) {
                    Text("\(theDay.day)")
                        .frame(width: 25, height: 25)
                        .background(theDay.isToday ? Color.black : Color.clear)
                        .font(.system(size: DeviceSizeUtility.isSESize ? 14 : 18))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .foregroundStyle(theDay.isToday ? Color.white : theDay.dayColor())
                        .padding(.top, 3)

                    Spacer()

                    if theDay.count != 0 {
                        ZStack {
                            Text("\(theDay.count)")
                                .font(.system(size: DeviceSizeUtility.isSESize ? 14 : 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    } else {
                        Color.white
                            .frame(height: DeviceSizeUtility.isSESize ? 35 : 40)
                    }
                }.simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            isShowDetailView = true
                        }
                )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: DeviceSizeUtility.isSESize ? 68 : 80)
        .overlay {
            Rectangle()
                .stroke(.gray, lineWidth: 0.5)
        }.navigationDestination(isPresented: $isShowDetailView) {
            Text("")
        }
    }
}

#Preview {
    TheDayView(theDay: SCDate.demo)
}
