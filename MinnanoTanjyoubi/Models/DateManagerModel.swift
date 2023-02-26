//
//  DateManagerModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/12.
//

import UIKit

class DateManagerModel {
    
    public let df = DateFormatter()
    public let today = Date()
    
    
    init(){
        conversionSlash()
        df.locale = Locale(identifier: "ja_JP")
        df.calendar = Calendar(identifier: .gregorian)
    }
    
    public func conversionJapanese (){
        df.dateFormat = "yyyy年M月dd日"
    }
    
    public func conversionJapaneseEraName (){
        df.calendar = Calendar(identifier: .japanese)
        df.dateFormat = "Gy年"
    }
    
    public func conversionSlash (){
        df.dateFormat =  "yyyy/MM/dd"
    }
    
}
