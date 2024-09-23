//
//  Protocols.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 13.09.2024.
//

import Foundation

protocol PersistentObject {

    associatedtype Model
    func convertToModel() -> Model
}

protocol PersistableModel {

    associatedtype Object
    func convertToObject() -> Object
}
