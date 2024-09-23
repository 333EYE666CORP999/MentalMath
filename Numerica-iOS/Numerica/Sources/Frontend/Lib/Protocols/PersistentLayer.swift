import Foundation

protocol PersistentObject {

    associatedtype Model
    func convertToModel() -> Model
}

protocol PersistableModel {

    associatedtype Object
    func convertToObject() -> Object
}
