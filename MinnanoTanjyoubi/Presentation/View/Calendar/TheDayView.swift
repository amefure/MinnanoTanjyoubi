//
//  TheDayView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

import SCCalendar
import SwiftUI

struct TheDayView: View {
    let theDay: SCDate
    let onTapDay: (SCDate) -> Void
    let scheme: AppColorScheme

    var body: some View {
        VStack {
            if theDay.day == -1 {
                scheme.foundationPrimary
            } else {
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(theDay.day)")
                        .frame(width: 18, height: 18)
                        .background(theDay.isToday ? Asset.Colors.exThemaRed.swiftUIColor : Color.clear)
                        .fontSS(bold: true)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .foregroundStyle(theDay.isToday ? Color.white : theDay.dayColor(defaultColor: scheme.text))

                    // SEサイズなら最大2人まで表示
                    ForEach(theDay.users.prefix(DeviceSizeUtility.isSESize ? 2 : 3)) { user in
                        Text(user.name)
                            .lineLimit(1)
                            .fontSSS(bold: true)
                            .foregroundStyle(.white)
                            .frame(height: 15)
                            .frame(maxWidth: .infinity)
                            .background(theDay.isToday ? Asset.Colors.exThemaRed.swiftUIColor : Asset.Colors.exThemaYellow.swiftUIColor)
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                    }

                    // スペーサー用(スワイプタップ判定領域確保のため)
                    scheme.foundationSub
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 3)
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            onTapDay(theDay)
                        }
                )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: DeviceSizeUtility.isSESize ? 74 : 80)
        .overlay {
            Rectangle()
                .stroke(scheme.text, lineWidth: 2)
        }
    }
}

#Preview {
    TheDayView(
        theDay: SCDate.demo,
        onTapDay: { _ in },
        scheme: .original
    )
}
