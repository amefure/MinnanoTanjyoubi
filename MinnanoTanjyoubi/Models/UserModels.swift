//
//  UserModels.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/29.
//

import RealmSwift

class User: Object ,ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted  var name:String = ""
    @Persisted  var ruby:String = ""
    @Persisted  var date:Date = Date()
    @Persisted  var relation:Relation
    @Persisted  var memo:String = ""
    @Persisted  var alert:Bool = false
    
    // MARK: - 誕生日まであとX日
    public var daysLater:Int {
        let dm = DateManagerModel()
        let df = dm.df
        let dateStr = df.string(from: date)
        let today = dm.today
        let pre = dateStr.prefix(4)
        let range = dateStr.range(of: pre)
        let nowYear = df.string(for: today)?.prefix(4)
        var replaceStr = dateStr.replacingCharacters(in: range!, with: nowYear! )
        
        var targetDate = df.date(from: replaceStr)
        if targetDate == nil  {
            // MARK: - 日付変換失敗；閏年 →　3/1
            replaceStr = "\(nowYear!)/3/1"
            targetDate = df.date(from: replaceStr)!
        }
        
        let num = targetDate!.timeIntervalSince(today)
        
        var result = ceil(num / ( 60 * 60 * 24))
        if result < 0 {
            result = result + 365
        }
        return Int(result)
    }
    
    //MARK: - 今何歳
    public var currentAge:Int{
        let seconds = date.timeIntervalSinceNow
        if seconds > 0 {
            return 0  // 未来の日付を渡されている場合は０歳にする
        }
        let late = seconds / (60 * 60 * 24 * 365)
        let result = floor(abs(late))
        return Int(result)
    }
    
    //MARK: - 文字列型生年月日
    public var dateOfBirthString:String{
        let dm = DateManagerModel()
        dm.conversionJapanese()
        let df = dm.df
        return df.string(from: date)
    }
    
    
}

struct calcDateOfBirth{
    
    // MARK: - 12星座
    public func signOfZodiac(_ date:Date) -> String {
        let df = DateManagerModel().df
        // 年数は指定日の年数を取得→範囲を識別するため
        let thisYear = df.string(from: date).prefix(4)
        let nowYear = "\(thisYear)/" // "2023/" 形式
        let lateYear = "\(Int(thisYear)! + 1)/" // "2024/" 翌年形式
        
        switch date {
        case df.date(from: String(nowYear + "3/21"))!...df.date(from: String(nowYear + "4/20"))!:
            return "おひつじ座"
        case df.date(from: String(nowYear + "4/20"))!...df.date(from: String(nowYear + "5/21"))!:
            return "おうし座"
        case df.date(from: String(nowYear + "5/21"))!...df.date(from: String(nowYear + "6/22"))!:
            return "ふたご座"
        case df.date(from: String(nowYear + "6/22"))!...df.date(from: String(nowYear + "7/23"))!:
            return "かに座"
        case df.date(from: String(nowYear + "7/23"))!...df.date(from: String(nowYear + "8/23"))!:
            return "しし座"
        case df.date(from: String(nowYear + "8/23"))!...df.date(from: String(nowYear + "9/23"))!:
            return "おとめ座"
        case df.date(from: String(nowYear + "9/23"))!...df.date(from: String(nowYear + "10/24"))!:
            return "てんびん座"
        case df.date(from: String(nowYear + "10/24"))!...df.date(from: String(nowYear + "11/23"))!:
            return "さそり座"
        case df.date(from: String(nowYear + "11/23"))!...df.date(from: String(nowYear + "12/22"))!:
            return "いて座"
        case df.date(from: String(nowYear + "12/22"))!...df.date(from: String(lateYear + "1/1"))!:
            return "やぎ座"
        case df.date(from: String(nowYear + "1/1"))!...df.date(from: String(nowYear + "1/20"))!:
            return "やぎ座"
        case df.date(from: String(nowYear + "1/20"))!...df.date(from: String(nowYear + "2/19"))!:
            return "みずがめ座"
        case df.date(from: String(nowYear + "2/19"))!...df.date(from: String(nowYear + "3/21"))!:
            return "うお座"
        default:
            return "..."
        }
        
    }
    // MARK: - 十二支
    public func zodiac(_ date:Date) -> String {
        
        let df = DateManagerModel().df
        let nowYear = df.string(from: date).prefix(4)
        guard Int(nowYear) != nil else {
            // 文字列の場合
            return "..."
        }
        let num = Int(nowYear)! % 12
        switch num {
        case 4:
            return "ねずみ年"
        case 5:
            return "うし年"
        case 6:
            return "とら年"
        case 7:
            return "うさぎ年"
        case 8:
            return "たつ年"
        case 9:
            return "へび年"
        case 10:
            return "うま年"
        case 11:
            return "ひつじ年"
        case 0:
            return "さる年"
        case 1:
            return "とり年"
        case 2:
            return "いぬ年"
        case 3:
            return "いのしし年"
        default:
            return "..."
        }
    }
}
