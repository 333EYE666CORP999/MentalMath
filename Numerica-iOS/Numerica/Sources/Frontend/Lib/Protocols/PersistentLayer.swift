protocol PersistentObject {

    associatedtype Model
    func convertToModel() -> Model
}

protocol PersistableModel {

    associatedtype Object
    func convertToObject() -> Object
}

extension Sequence where Element: PersistableModel {

    func convertToObjects() -> [Element.Object] {
        map { $0.convertToObject() }
    }
}
