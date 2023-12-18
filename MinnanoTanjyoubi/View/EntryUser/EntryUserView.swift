//
//  EntryUserView.swift
//  Pods
//
//  Created by t&a on 2022/09/30.
//

import RealmSwift
import SwiftUI

// MARK: - モーダル表示されるデータ登録ビュー

// データ更新時も呼び出される

struct EntryUserView: View {
    // MARK: - Models

    @ObservedObject private var repository = RealmRepositoryViewModel.shared

    // Updateデータ受け取り用
    public var user: User?

    // MARK: - Setting

    private let isSESize: Bool = DeviceSizeManager.isSESize

    // MARK: - Input View

    @State var name: String = ""
    @State var ruby: String = ""
    @State var date: Date = .init()
    @State var memo: String = ""
    @State var selectedRelation: Relation = .other
    @State var isON: Bool = false

    // MARK: - View  Control

    @Binding var isModal: Bool // 自信の表示モーダルフラグ
    @State var isWheel: Bool = true // カレンダーON/OFF
    @FocusState var isFocusActive: Bool // TextField/TextEditor ActiveFlag

    // MARK: - バリデーション

    private func validationInput() -> Bool {
        if name == "" {
            return false
        }
        return true
    }

    private func getNewUser() -> User {
        let newUser = User()
        newUser.name = name
        newUser.ruby = ruby
        newUser.date = date
        newUser.relation = selectedRelation
        newUser.memo = memo
        newUser.alert = isON
        return newUser
    }

    var body: some View {
        VStack(alignment: .center) {
            // MARK: - ViewComponent

            UpSideView()

            if !isSESize {
                Spacer()
            }

            VStack(spacing: isSESize ? 5 : 20) {
                // Input Name
                HStack {
                    Text("名　　前").frame(width: 80)
                    TextField("名前", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.primary)
                        .focused($isFocusActive)
                }.padding(5)

                // Input Ruby
                HStack {
                    Text("ふりがな").frame(width: 80)
                    TextField("ふりがな", text: $ruby)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.primary)
                        .focused($isFocusActive)
                }.padding(5)

                // Input Date
                HStack {
                    Text("生年月日").frame(width: 80)
                    Spacer()
                    DatePickerView(date: $date, isWheel: $isWheel)
                }.padding(5)

                // Input Relation
                HStack {
                    Text("関　　係").frame(width: 80)
                    Spacer()
                    RelationPickerView(selectedRelation: $selectedRelation)
                    Spacer()
                }.padding(5)

                // Input Relation

                if user == nil {
                    // MARK: - 通知ビュー

                    Toggle(isOn: $isON, label: {
                        Text("通知")
                    }).toggleStyle(SwitchToggleStyle(tint: ColorAsset.themaColor1.thisColor))
                }

                Text("MEMO").foregroundColor(ColorAsset.foundationColorDark.thisColor).fontWeight(.bold).opacity(0.8)
                NavigationStack {
                    TextEditor(text: $memo)
                        .padding(5)
                        .background(ColorAsset.foundationColorLight.thisColor)
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
                }.background(ColorAsset.foundationColorLight.thisColor)
                    .frame(minHeight: isSESize ? 60 : 90)
                    .overBorder(radius: 5, color: ColorAsset.foundationColorDark.thisColor, opacity: 0.4, lineWidth: 3)
            }

            Spacer()

            // MARK: - ViewComponent

            DownSideView(parentFunction: {
                if validationInput() {
                    if let user = user {
                        // Update
                        let newUser = getNewUser()
                        repository.updateUser(id: user.id, newUser: newUser)

                    } else {
                        // Create

                        let newUser = getNewUser()
                        repository.createUser(newUser: newUser)

                        if isON {
                            let dfm = DateFormatManager()
                            let dateString = dfm.getNotifyString(date: date)
                            NotificationRequestManager().sendNotificationRequest(newUser.id, name, dateString)
                        }
                    }

                    isModal = false
                } // validationInput
            }, imageString: "checkmark")

        }.padding()
            .background(ColorAsset.foundationColorLight.thisColor)
            .foregroundColor(.white)
            .onAppear {
                // Update時なら初期値セット
                if let user = user {
                    name = user.name
                    ruby = user.ruby
                    date = user.date
                    selectedRelation = user.relation
                    memo = user.memo
                }
            }
            .onChange(of: isFocusActive, perform: { _ in
                if isFocusActive {
                    isWheel = true
                }
            })
            .navigationBarBackButtonHidden(true)
    }
}
