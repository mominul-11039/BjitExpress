//
//  Utils.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 19/5/23.
//

import Foundation

func getCurrentTimeInMinutes() -> Int {
    let date = Date()
    let calendar = Calendar.current
    let minutes = calendar.component(.minute, from: date)
    let hour = calendar.component(.hour, from: date)
    return (hour * 60) + minutes
}
