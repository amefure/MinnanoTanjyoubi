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
    
    @StateObject private var viewModel = EntryUserViewModel()
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    /// Updateデータ受け取り用
    var updateUserId: ObjectId?

    /// 新規登録時にカレンダーから遷移した場合に月と日だけ該当のものにする
    var isCalendarMonth: Int?
    var isCalendarDay: Int?
    
    /// 自身の表示モーダルフラグ
    @Binding var isSelfShowModal: Bool
    /// TextField/TextEditor ActiveFlag
    @FocusState private var isFocusActive: Bool

    var body: some View {
        VStack(alignment: .center) {

            UpSideView()
                .environmentObject(rootEnvironment)

            if !DeviceSizeUtility.isSESize {
                Spacer()
            }

            VStack(spacing: DeviceSizeUtility.isSESize ? 5 : 20) {
                // Input Name
                HStack {
                    Text("名　　前")
                        .frame(width: 80)
                    TextField("名前", text: $viewModel.name)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.primary)
                        .focused($isFocusActive)
                }.padding(5)

                // Input Ruby
                HStack {
                    Text("ふりがな")
                        .frame(width: 80)
                    TextField("ふりがな", text: $viewModel.ruby)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.primary)
                        .focused($isFocusActive)
                }.padding(5)

                // Input Date
                HStack {
                    Text("生年月日")
                        .frame(width: 80)
                    Spacer()
                    DatePickerView(
                        date: $viewModel.date,
                        showWheel: $viewModel.showWheel,
                        isYearsUnknown: $viewModel.isYearsUnknown
                    ).environmentObject(rootEnvironment)
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

                if viewModel.targetUser == nil {
                    Toggle(
                        isOn: $viewModel.isAlert,
                        label: { Text("通知") }
                    ).toggleStyle(SwitchToggleStyle(tint: rootEnvironment.scheme.thema1))
                        .frame(width: DeviceSizeUtility.deviceWidth - 50)
                }

                Toggle(
                    isOn: $viewModel.isYearsUnknown,
                    label: { Text("年数の指定を未設定にする") }
                ).toggleStyle(SwitchToggleStyle(tint: rootEnvironment.scheme.thema1))
                    .frame(width: DeviceSizeUtility.deviceWidth - 50)

                Text("MEMO")
                    .foregroundStyle(rootEnvironment.scheme.text)
                    .fontWeight(.bold)
                    .opacity(0.8)

                NavigationStack {
                    TextEditor(text: $viewModel.memo)
                        .padding(5)
                        .background(rootEnvironment.scheme.foundationSub)
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
                }.background(rootEnvironment.scheme.foundationSub)
                    .frame(minHeight: DeviceSizeUtility.isSESize ? 60 : 90)
                    .overBorder(radius: 5, color: rootEnvironment.scheme.foundationPrimary, opacity: 0.4, lineWidth: 3)
            }

            Spacer()

            DownSideView(
                parentFunction: {
                    let result = viewModel.createOrUpdateUser()
                    guard result else { return }
                    isSelfShowModal = false
                },
                imageString: "checkmark"
            ).environmentObject(rootEnvironment)

        }.padding()
            .fontM()
            .background(rootEnvironment.scheme.foundationSub)
            .foregroundColor(rootEnvironment.scheme.text)
            .onAppear {
                viewModel.onAppear(
                    updateUserId: updateUserId,
                    isCalendarMonth: isCalendarMonth,
                    isCalendarDay: isCalendarDay
                )
            }
            .onChange(of: isFocusActive, perform: { _ in
                if isFocusActive {
                    viewModel.showWheel = false
                }
            })
            .navigationBarBackButtonHidden(true)
            .alert(
                isPresented: $viewModel.isShowValidationDialog,
                title: "エラー",
                message: "名前を入力してください。",
                positiveButtonTitle: "OK",
            )
    }
    
    /// 関係性ピッカー
    private func relationPickerView() -> some View {
        
        Picker(
            selection: $viewModel.selectedRelation,
            label: Text("関係")
        ) {
            ForEach(Array(rootEnvironment.relationNameList.enumerated()), id: \.element) { index, item in
                Text(item)
                    .tag(Relation.getIndexbyRelation(index))
            }
        }.pickerStyle(.menu)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(rootEnvironment.scheme.text.opacity(0.4), lineWidth: 2)
            ).tint(rootEnvironment.scheme.text)
    }
}
