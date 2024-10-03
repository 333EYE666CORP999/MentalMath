//
//  BundleTests.swift
//  NumericaTests
//
//  Created by Dmitry Aksyonov on 03.10.2024.
//

@testable import Numerica
import Foundation
import Testing

@Suite("Tests for Bundle")
struct BundleTests {

    @Test("Test bundle path")
    func bundle() {
        #expect(Bundle.main.bundlePath.hasSuffix("Tests"))
    }
}
