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
                AppColorScheme.getFoundationPrimary(rootEnvironment.scheme)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(theDay.day)")
                        .frame(width: 18, height: 18)
                        .background(theDay.isToday ? Color.black : Color.clear)
                        .fontSS(bold: true)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .foregroundStyle(theDay.isToday ? Color.white : theDay.dayColor(defaultColor: AppColorScheme.getText(rootEnvironment.scheme)))

                    Spacer()

                    AppColorScheme.getFoundationSub(rootEnvironment.scheme)
                        .frame(height: DeviceSizeUtility.isSESize ? 35 : 40)
                }
                .padding(6)
                .simultaneousGesture(
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
                .stroke(AppColorScheme.getText(rootEnvironment.scheme), lineWidth: 2)
        }.navigationDestination(isPresented: $isShowDetailView) {
            Text("")
        }
    }
}

#Preview {
    TheDayView(theDay: SCDate.demo)
}
