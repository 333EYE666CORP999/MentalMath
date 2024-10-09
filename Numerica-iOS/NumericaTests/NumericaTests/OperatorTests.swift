import Foundation
@testable import Numerica
import Testing

@Suite("Operator Integrity Tests")
struct OperatorIntegrityTests {

    @Test("Test operators have right variants")
    func testOperatorsHaveRightVariants() {
        #expect(Operator.allCases.count == 4)
    }

    @Test("Test operators assigned to correct raw values")
    func testOperatorsAssignedToCorrectRawValues() {
        Operator.allCases.forEach {
            switch $0 {
            case .addition:
                #expect($0.rawValue == "+")
            case .subtraction:
                #expect($0.rawValue == "-")
            case .multiplication:
                #expect($0.rawValue == "*")
            case .division:
                #expect($0.rawValue == "/")
            }
        }
    }
}
