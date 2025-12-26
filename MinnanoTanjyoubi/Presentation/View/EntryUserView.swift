//
//  EntryUserView.swift
//  Pods
//
//  Created by t&a on 2022/09/30.
//

import RealmSwift
import SwiftUI

/// モーダル表示されるデータ登録ビュー
/// データ更新時も呼び出される
struct EntryUserView: View {
    @State private var viewModel = DIContainer.shared.resolve(EntryUserViewModel.self)
    @Environment(\.rootEnvironment) private var rootEnvironment

    /// Updateデータ受け取り用
    var updateUserId: ObjectId?

    /// 新規登録時にカレンダーから遷移した場合に月と日だけ該当のものにする
    var isCalendarMonth: Int?
    var isCalendarDay: Int?
    /// TextField/TextEditor ActiveFlag
    @FocusState private var isFocusActive: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .center) {
            UpSideView(scheme: rootEnvironment.state.scheme)

            if !DeviceSizeUtility.isSESize {
                Spacer()
            }

            VStack(spacing: DeviceSizeUtility.isSESize ? 5 : 20) {
                CustomInputView(
                    title: "名　　前",
                    placeholder: "名前",
                    text: $viewModel.state.name,
                    scheme: rootEnvironment.state.scheme
                ).focused($isFocusActive)

                CustomInputView(
                    title: "ふりがな",
                    placeholder: "ふりがな",
                    text: $viewModel.state.ruby,
                    scheme: rootEnvironment.state.scheme
                ).focused($isFocusActive)

                // Input Date
                HStack {
                    Text("生年月日")
                        .frame(width: 80)
                    Spacer()
                    DatePickerView(
                        date: $viewModel.state.date,
                        showWheel: $viewModel.state.showWheel,
                        isYearsUnknown: $viewModel.state.isYearsUnknown,
                        scheme: rootEnvironment.state.scheme
                    )
                }.padding(5)

                // Input Relation
                HStack {
                    Text("関　　係")
                        .frame(width: 80)
                    Spacer()

                    relationPickerView()

                    Spacer()
                }.padding(5)

                // Input Relation

                // 新規登録時のみ通知フラグをONにする
                if updateUserId == nil {
                    Toggle(
                        isOn: $viewModel.state.isAlert,
                        label: { Text("通知") }
                    ).toggleStyle(SwitchToggleStyle(tint: rootEnvironment.state.scheme.thema1))
                        .frame(width: DeviceSizeUtility.deviceWidth - 50)
                }

                Toggle(
                    isOn: $viewModel.state.isYearsUnknown,
                    label: { Text("年数の指定を未設定にする") }
                ).toggleStyle(SwitchToggleStyle(tint: rootEnvironment.state.scheme.thema1))
                    .frame(width: DeviceSizeUtility.deviceWidth - 50)

                Text("MEMO")
                    .foregroundStyle(rootEnvironment.state.scheme.text)
                    .fontWeight(.bold)
                    .opacity(0.8)

                NavigationStack {
                    TextEditor(text: $viewModel.state.memo)
                        .padding(5)
                        .background(rootEnvironment.state.scheme.foundationSub)
                        .focused($isFocusActive)
                        .scrollContentBackground(.hidden)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer() // 右寄せにする
                                Button {
                                    isFocusActive = false
                                } label: {
                                    Text("閉じる")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                }.background(rootEnvironment.state.scheme.foundationSub)
                    .frame(minHeight: DeviceSizeUtility.isSESize ? 60 : 90)
                    .overBorder(radius: 5, color: rootEnvironment.state.scheme.foundationPrimary, opacity: 0.4, lineWidth: 3)
            }

            Spacer()

            DownSideView(
                parentFunction: {
                    let result = viewModel.createOrUpdateUser()
                    guard result else { return }
                    dismiss()
                },
                imageString: "checkmark",
                scheme: rootEnvironment.state.scheme
            )

        }.padding()
            .fontM()
            .background(rootEnvironment.state.scheme.foundationSub)
            .foregroundColor(rootEnvironment.state.scheme.text)
            .onAppear {
                viewModel.onAppear(
                    updateUserId: updateUserId,
                    isCalendarMonth: isCalendarMonth,
                    isCalendarDay: isCalendarDay
                )
            }
            .onChange(of: isFocusActive) { _, newValue in
                guard newValue else { return }
                viewModel.state.showWheel = false
            }
            .navigationBarBackButtonHidden(true)
            .alert(
                isPresented: $viewModel.state.isShowValidationDialog,
                title: "エラー",
                message: "名前を入力してください。",
                positiveButtonTitle: "OK"
            )
    }

    /// 関係性ピッカー
    private func relationPickerView() -> some View {
        Picker(
            selection: $viewModel.state.selectedRelation,
            label: Text("関係")
        ) {
            ForEach(Array(rootEnvironment.state.relationNameList.enumerated()), id: \.element) { index, item in
                Text(item)
                    .tag(Relation.getIndexbyRelation(index))
            }
        }.pickerStyle(.menu)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(rootEnvironment.state.scheme.text.opacity(0.4), lineWidth: 2)
            ).tint(rootEnvironment.state.scheme.text)
    }
}

private struct DatePickerView: View {
    private let dfmJp = DateFormatUtility(format: .jp)
    private let dfmJpOnlyDate = DateFormatUtility(format: .jpOnlyDate)

    @Binding var date: Date
    @State private var dateStr: String = ""
    @Binding var showWheel: Bool
    @Binding var isYearsUnknown: Bool
    /// Color Scheme
    let scheme: AppColorScheme
    private let isSESize: Bool = DeviceSizeUtility.isSESize

    var body: some View {
        HStack {
            if showWheel {
                DatePicker(
                    selection: $date,
                    displayedComponents: DatePickerComponents.date,
                    label: { Text("誕生日") }
                ).environment(\.locale, Locale(identifier: "ja_JP"))
                    .environment(\.calendar, Calendar(identifier: .gregorian))
                    .onChange(of: date) { _, newValue in
                        if isYearsUnknown {
                            dateStr = dfmJpOnlyDate.getString(date: newValue)
                        } else {
                            dateStr = dfmJp.getString(date: newValue)
                        }
                    }
                    .colorInvert()
                    .colorMultiply(scheme.text)
                    .frame(width: DeviceSizeUtility.deviceWidth - 180)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .scaleEffect(x: isSESize ? 0.8 : 0.9, y: isSESize ? 0.8 : 0.9)

                Button {
                    showWheel = false
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                        .padding(3)
                        .background(scheme.thema2)
                        .opacity(0.8)
                        .cornerRadius(5)
                }.padding([.leading, .top, .bottom])
            } else {
                Text(dateStr)
                    .fontM()
                    .frame(width: DeviceSizeUtility.deviceWidth - 120)
                    .onTapGesture {
                        showWheel = true
                    }.onChange(of: isYearsUnknown) { _, newValue in
                        if newValue {
                            dateStr = dfmJpOnlyDate.getString(date: date)
                        } else {
                            dateStr = dfmJp.getString(date: date)
                        }
                    }
            }
        }.onAppear {
            if isYearsUnknown {
                dateStr = dfmJpOnlyDate.getString(date: date)
            } else {
                dateStr = dfmJp.getString(date: date)
            }
        }
    }
}
