//
//  String+Extension.swift
//  IMDBClone
//
//  Created by Mina on 05/02/2023.
//

import Foundation

extension Optional where Wrapped == String {
    func convertStringIntoInt() -> Int {
        guard let self = self else {
            return 0
        }
        return Int(self) ?? 0
    }
    
    func convertStringIntoDouble() -> Double {
        guard let self = self else {
            return 0.0
        }
        return Double(self) ?? 0.0
    }
}
