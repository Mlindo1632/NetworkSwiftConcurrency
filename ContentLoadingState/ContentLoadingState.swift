//
//  ContentLoadingState.swift
//  NetworkSwiftConcurrency
//
//  Created by Lindokuhle Khumalo on 2025/10/06.
//

import Foundation

enum ContentLoadingState <T: Codable> {
    case loading
    case empty
    case error(Error)
    case complete(data: T)
}
