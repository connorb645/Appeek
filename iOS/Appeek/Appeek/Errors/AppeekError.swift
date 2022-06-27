//
//  AppeekError.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import Foundation

protocol AppeekError: LocalizedError {
    var friendlyMessage: String { get }
}
