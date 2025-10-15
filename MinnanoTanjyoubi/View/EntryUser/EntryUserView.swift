//
//  EntryUserView.swift
//  Pods
//
//  Created by t&a on 2022/09/30.
//

import RealmSwift
import SwiftUI
import WidgetKit

/// モーダル表示されるデータ登録ビュー
/// データ更新時も呼び出される
struct EntryUserView: View {
    // ViewModel
    @ObservedObject private var repository = RealmRepositoryViewModel.shared
    private let viewModel = EntryUserViewModel()

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    /// Updateデータ受け取り用
    var user: User?

    /// 新規登録時にカレンダーから遷移した場合に月と日だけ該当のものにする
    var isCalendarMonth: Int?
    var isCalendarDay: Int?

    // InputView
    @State private var name = ""
    @State private var ruby = ""
    @State private var date = Date()
    @State private var memo = ""
    @State private var selectedRelation: Relation = .other
    @State private var isAlert = true
    @State private var isYearsUnknown = false

    // 自身の表示モーダルフラグ
    @Binding var isModal: Bool
    // カレンダーON/OFF
    @State private var showWheel: Bool = false
    // バリデーションダイアログ
    @State private var showValidationDialog = false
    // TextField/TextEditor ActiveFlag
    @FocusState private var isFocusActive: Bool

    var body: some View {
        VStack(alignment: .center) {
            // MARK: - ViewComponent

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
                    TextField("名前", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.primary)
                        .focused($isFocusActive)
                }.padding(5)

                // Input Ruby
                HStack {
                    Text("ふりがな")
                        .frame(width: 80)
                    TextField("ふりがな", text: $ruby)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.primary)
                        .focused($isFocusActive)
                }.padding(5)

                // Input Date
                HStack {
                    Text("生年月日")
                        .frame(width: 80)
                    Spacer()
                    DatePickerView(date: $date, showWheel: $showWheel, isYearsUnknown: $isYearsUnknown)
                        .environmentObject(rootEnvironment)
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

                if user == nil {
                    Toggle(isOn: $isAlert, label: {
                        Text("通知")
                    }).toggleStyle(SwitchToggleStyle(tint: rootEnvironment.scheme.thema1))
                        .frame(width: DeviceSizeUtility.deviceWidth - 50)
                }

                Toggle(isOn: $isYearsUnknown, label: {
                    Text("年数の指定を未設定にする")
                }).toggleStyle(SwitchToggleStyle(tint: rootEnvironment.scheme.thema1))
                    .frame(width: DeviceSizeUtility.deviceWidth - 50)

                Text("MEMO")
                    .foregroundStyle(rootEnvironment.scheme.text)
                    .fontWeight(.bold)
                    .opacity(0.8)

                NavigationStack {
                    TextEditor(text: $memo)
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

            // MARK: - ViewComponent

            DownSideView(parentFunction: {
                guard viewModel.validationInput(name) else {
                    showValidationDialog = true
                    return
                }
                if let user = user {
                    // Update
                    let newUser = viewModel.getNewUser(
                        name: name,
                        ruby: ruby,
                        date: date,
                        selectedRelation: selectedRelation,
                        memo: memo,
                        alert: isAlert,
                        isYearsUnknown: isYearsUnknown
                    )
                    repository.updateUser(id: user.id, newUser: newUser)

                } else {
                    // Create
                    let newUser = viewModel.getNewUser(
                        name: name,
                        ruby: ruby,
                        date: date,
                        selectedRelation: selectedRelation,
                        memo: memo,
                        alert: isAlert,
                        isYearsUnknown: isYearsUnknown
                    )
                    repository.createUser(newUser: newUser)

                    if isAlert {
                        AppManager.sharedNotificationRequestManager.sendNotificationRequest(newUser.id, name, date)
                    }
                }
                // 登録 & 更新のタイミングでウィジェットも更新する
                WidgetCenter.shared.reloadAllTimelines()

                isModal = false
            }, imageString: "checkmark")
                .environmentObject(rootEnvironment)

        }.padding()
            .fontM()
            .background(rootEnvironment.scheme.foundationSub)
            .foregroundColor(rootEnvironment.scheme.text)
            .onAppear {
                if let user = user {
                    // Update時なら初期値セット
                    name = user.name
                    ruby = user.ruby
                    date = user.date
                    selectedRelation = user.relation
                    memo = user.memo
                    isYearsUnknown = user.isYearsUnknown
                } else {
                    // 新規登録なら初期値年数を反映
                    // カレンダーからの遷移なら日付まで指定する
                    date = viewModel.getInitDate(month: isCalendarMonth, day: isCalendarDay)
                    // 関係初期値を取得
                    selectedRelation = viewModel.getInitRelation()
                }
            }
            .onChange(of: isFocusActive, perform: { _ in
                if isFocusActive {
                    showWheel = false
                }
            })
            .navigationBarBackButtonHidden(true)
            .alert(
                isPresented: $showValidationDialog,
                title: "エラー",
                message: "名前を入力してください。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    showValidationDialog = false
                }
            )
    }
    
    /// 関係性ピッカー
    private func relationPickerView() -> some View {
        Picker(selection: $selectedRelation, label: Text("関係")) {
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
