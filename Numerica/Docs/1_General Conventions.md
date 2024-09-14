# General Conventions

Here are some conventional things that are enforced on the project.

## Naming Persistable Entities and Their in-Memory Twins

### Convention

Entities that are stored in SwiftData should:
- have `Object` suffix
- implement `PersistentObject` protocol

Entities that are stored in memory, but hold the same data, as persistent objects, should:
- have `Model` suffix
- implement `PersistableModel` protocol

Example

Entity for persistent storage:
```swift
@Model
final class ProblemObject {

    var problem: String
    var solution: Int
    var solved: Bool

    init... // omitted for brevity
}

extension ProblemObject: PersistentObject {

    func convertToModel() -> ProblemModel {
        ProblemModel(
            problem: problem,
            solution: solution,
            solved: solved
        )
    }
}

```

In-memory entity that holds the same data:
```swift
final class ProblemModel {

    var problem: String
    var solution: Int
    var solved: Bool

    init... // omitted for brevity
}

extension ProblemModel: PersistableModel {

    func convertToObject() -> ProblemObject {
        ProblemObject(
            problem: problem,
            solution: solution,
            solved: solved
        )
    }
}
```

### Rationale
SwiftData has some disappointing intricacies concerning mutating `@Model` objects on the fly. 
Therefore any modifications and passing here and there should be made with `Model` (not `@Model`) entities.

