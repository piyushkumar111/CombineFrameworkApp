//
//  ApiHandler.swift
//  CombineIntro
//
//  Created by Piyush Kachariya on 3/4/22.
//

import Foundation
import Combine

class ApiHandler {
    
    static let shared = ApiHandler()
        
    func fetchListOfCompnines() -> Future<[String], Error> {
        return Future { promixe in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                promixe(.success(["Facebook", "Apple", "Amazon", "Nextflix", "Google"]))
            }
        }
    }
}
