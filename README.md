# みんなの誕生日

友達や家族などの誕生日をメモして通知が届くアプリ

## アプリ概要

＼大切な人の大切な日を忘れずにお祝いするためのアプリ／

◇「みんなの誕生日」でできること
1. 友達の誕生日を記録
2. 年齢や星座、干支を自動計算
3. 誕生日まで後何日か一目でわかる
4. 誕生日当日または前日に通知が届く
5. 通知メッセージもカスタマイズ可能！
6. 関係ごとにカテゴライズ(カテゴリ名は編集可能)
7. レイアウトは「All」と「カテゴリ別」で変更可能
8. アプリにロックもかけられる(生体認証(指紋/顔)でログイン)
9. 好きな画像を人単位で保存できる(※)
10. 友達に登録した誕生日情報を転送可能
11. カレンダー機能で誕生日がわかりやすく表示
※タップで全体表示、長押しで削除が可能です。

アプリの設定から色々な設定が可能です。
- 通知時間
- 誕生日当日か前日か
- 年齢表記の変更(○歳 ←→ ○歳○ヶ月)
- 誕生日までの日数表記(○日 ←→ ○ヶ月(1ヶ月以内は○日))
- 関係性の名称変更
- 誕生日登録時の初期値年数の変更
- 週始まりを変更


※ インストール自体は無料ですが一部アプリ内課金要素があります。
- 広告削除機能
- 容量制限解放(無料でも広告を視聴いただくことで容量は増加させることが可能です。)

## 開発環境

- Xcode：26.0.1
- Swift：6
- iOS：16〜26
- Mac M1：Tahoe 26.0.1

### アーキテクチャ

- MVVM + Repository + Manager

### 機能一覧

- 誕生日情報保存・取得機能
- プッシュ通知
- アプリ内課金
- 生体認証
- データ転送
- 画像添付
- リワード広告

### 自動化
fastlaneを使用してビルドアップロードを自動化しています。

```
$ bundle exec fastlane release
```

Test Flightへのアップロードも自動化しています。

```
$ bundle exec fastlane upload_test_flight
```

### アプリ内課金テスト環境

AsyncProducts.storekitを用意

1. Schemeを「StoreKit-Test」に変更
2. ビルド
3. 広告削除 & 容量解放画面からテスト購入可能


### Unit Test

- Framework：Swift Testing
- Test Coverage：15%

▼ 単体テスト
```
@Suite
struct MinnanoTanjyoubiTests {
    static let allTests = [
        UserTest.self,
        DateFormatUtilityTests.self,
        CryptoUtilityTests.self,
        JsonConvertUtilityTests.self,
    ] as [Any]
}
```

### アセット管理
アセットの管理にはSwiftGenを使用しています。以下のコマンドを実行することでアセット管理クラスを自動生成します。

```
$ swiftgen config run
```

## ライブラリ

### ライブラリ管理ツール
~~Cocoa Pods：1.16.2 (移行済み) ~~

Swift Package Manager

### Storage

- RealmSwift・・・アプリ内DB

### Analyze

- FirebaseCrashlytics・・・クラッシュ解析
- FirebaseAnalytics・・・イベント解析
- FirebasePerformance・・・パフォーマンス解析

### Utility

- Google-Mobile-Ads-SDK・・・AdMob 広告表示
- FirebaseRemoteConfig・・・レビューポップアップ表示管理
- CryptoSwift・・・暗号化・複合化 データ送信機能

### Debug
- ~~SwiftFormat/CLI・・・フォーマット~~

## ドキュメント

DeepWikiを使用したドキュメント

https://deepwiki.com/amefure/MinnanoTanjyoubi
