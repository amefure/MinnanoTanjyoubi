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
    // ViewModel
    @ObservedObject private var repository = RealmRepositoryViewModel.shared
    private let viewModel = EntryUserViewModel()

    // Updateデータ受け取り用
    public var user: User?

    // InputView
    @State private var name = ""
    @State private var ruby = ""
    @State private var date = Date()
    @State private var memo = ""
    @State private var selectedRelation: Relation = .other
    @State private var isAlert = true

    // 自身の表示モーダルフラグ
    @Binding var isModal: Bool
    // カレンダーON/OFF
    @State private var isWheel = true
    // バリデーションダイアログ
    @State private var showValidationDialog = false
    // TextField/TextEditor ActiveFlag
    @FocusState private var isFocusActive: Bool

    var body: some View {
        VStack(alignment: .center) {
            // MARK: - ViewComponent

            UpSideView()

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
                    DatePickerView(date: $date, isWheel: $isWheel)
                }.padding(5)

                // Input Relation
                HStack {
                    Text("関　　係")
                        .frame(width: 80)
                    Spacer()
                    RelationPickerView(selectedRelation: $selectedRelation)
                    Spacer()
                }.padding(5)

                // Input Relation

                if user == nil {
                    Toggle(isOn: $isAlert, label: {
                        Text("通知")
                    }).toggleStyle(SwitchToggleStyle(tint: AppColorScheme.getThema1()))
                }

                Text("MEMO")
                    .foregroundStyle(AppColorScheme.getText())
                    .fontWeight(.bold)
                    .opacity(0.8)

                NavigationStack {
                    TextEditor(text: $memo)
                        .padding(5)
                        .background(AppColorScheme.getFoundationSub())
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
                }.background(AppColorScheme.getFoundationSub())
                    .frame(minHeight: DeviceSizeUtility.isSESize ? 60 : 90)
                    .overBorder(radius: 5, color: AppColorScheme.getFoundationPrimary(), opacity: 0.4, lineWidth: 3)
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
                        alert: isAlert
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
                        alert: isAlert
                    )
                    repository.createUser(newUser: newUser)

                    if isAlert {
                        AppManager.sharedNotificationRequestManager.sendNotificationRequest(newUser.id, name, date)
                    }
                }

                isModal = false
            }, imageString: "checkmark")

        }.padding()
            .font(.system(size: 17))
            .background(AppColorScheme.getFoundationSub())
            .foregroundColor(AppColorScheme.getText())
            .onAppear {
                if let user = user {
                    // Update時なら初期値セット
                    name = user.name
                    ruby = user.ruby
                    date = user.date
                    selectedRelation = user.relation
                    memo = user.memo
                } else {
                    // 新規登録なら初期値年数を反映
                    date = viewModel.getInitYearDate()
                }
            }
            .onChange(of: isFocusActive, perform: { _ in
                if isFocusActive {
                    isWheel = true
                }
            })
            .navigationBarBackButtonHidden(true)
            .dialog(
                isPresented: $showValidationDialog,
                title: "エラー",
                message: "名前を入力してください。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    showValidationDialog = false
                }
            )
    }
}
