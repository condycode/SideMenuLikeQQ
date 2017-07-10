//
//  Double+DateFormater.swift
//  SQLIteSwift
//
//  Created by 胜波蔡 on 2017/6/23.
//  Copyright © 2017年 胜波蔡. All rights reserved.
//

import Foundation

extension Double {
    
    static let secondsOneDay:Double = 60*60*24
    
    func normalFarmaterString() -> String {
        
        let nowDate = Date()
        let now = nowDate.timeIntervalSince1970
        
        let thisTime = self / 1000
        let thisDate = Date(timeIntervalSince1970: thisTime)
        
        let apartDay = getHowManyDaysApart(date1: nowDate, date2: thisDate)
        
        var result = ""
        if now - thisTime < Double.secondsOneDay {
            
            if apartDay == 1 {
                result = "昨天"
            } else {
                let formart = DateFormatter()
                formart.dateFormat = "HH:mm"
                result = formart.string(from: thisDate)
            }
        } else if now - thisTime < Double.secondsOneDay * 2 {
            if apartDay == 2 {
                result = "前天"
            } else {
                result = "昨天"
            }
        } else if now - thisTime < Double.secondsOneDay * 3 {
            if apartDay == 3 {
                let formart = DateFormatter()
                formart.dateFormat = "YYYY-MM-dd"
                result = formart.string(from: thisDate)
            } else {
                result = "前天"
            }
        } else {
            let formart = DateFormatter()
            formart.dateFormat = "YYYY-MM-dd"
            result = formart.string(from: thisDate)
        }
        return result
    }
    
    func homeOrderTimeString() -> String {
        
        let nowDate = Date()
        let now = nowDate.timeIntervalSince1970
        
        let thisTime = self
        let thisDate = Date(timeIntervalSince1970: thisTime)
        
        let apartDay = getHowManyDaysApart(date1: nowDate, date2: thisDate)
        
        var result = ""
        if now - thisTime < 60*60 {
            let formart = DateFormatter()
            formart.dateFormat = "mm分钟前"
            result = formart.string(from: thisDate)
        } else if now - thisTime < Double.secondsOneDay {
            
            if apartDay == 1 {
                let formart = DateFormatter()
                formart.dateFormat = "MM月dd日"
                result = formart.string(from: thisDate)
            } else {
                let formart = DateFormatter()
                formart.dateFormat = "HH:mm"
                result = formart.string(from: thisDate)
            }
            
        } else {
            let formart = DateFormatter()
            formart.dateFormat = "MM月dd日"
            result = formart.string(from: thisDate)
        }
        return result
    }
    
    // MARK: - 获取两个日期之间差了几天，比如： 2017.05.23 23:59分 与 2017.05.24 00:01分 之间差了一天
    /// 获取两个日期之间差了几天，比如： 2017.05.23 23:59分 与 2017.05.24 00:01分 之间差了一天
    /// - Parameter date1: 日期
    /// - Parameter date2: 日期
    private func getHowManyDaysApart(date1: Date, date2: Date) -> Int {
        
        let calendar = Calendar.current
        
        // 首先获取两个日期的 年份
        var year1 = calendar.component(Calendar.Component.year, from: date1)
        var year2 = calendar.component(Calendar.Component.year, from: date2)
        
        // 利用DateFormatter获取这个日期是此年中的第几天
        let countDayFormater = DateFormatter()
        countDayFormater.dateFormat = "DDD"
        var day1 = Int(countDayFormater.string(from: date1))
        var day2 = Int(countDayFormater.string(from: date2))
        
        // 返回的都是正数，把date1 跟 date2 做比较，计算时用 大的日期 减去 小的日期
        if year1 < year2 {
            let temp = year1
            year1 = year2
            year2 = temp
            
            let tempDay = day1
            day1 = day2
            day2 = tempDay
        }
        
        // 如果年份相同，直接计算 相差几天
        if year1 == year2 {
            
            let tempDay = day1! - day2!
            
            return tempDay
        } else {    // 如果年份不同
            
            // 相差几年
            let apart = year1 - year2 - 1
            // 4年一轮，有几轮
            let loopCount = apart / 4
            // 闰年的个数
            let leapYearCount = loopCount
            // date2 此年中有几天
            var daysInYear2 = 365
            if (year2%4 == 0 && year2%100 != 0) || year2%400 == 0 {
                daysInYear2 = 366
            }
            // 计算天数
            print(leapYearCount)
            let day = leapYearCount * 366 + (apart - leapYearCount) * 365 + (daysInYear2 - day2!) + day1!
            
            return day
        }
    }
}
