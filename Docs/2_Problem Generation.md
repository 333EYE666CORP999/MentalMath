# Problem Generation

## Intro

This doc is focused on describing how problems are generated, breaking down the anatomy of generation process.

## Rationale

As discussed at the very beginning, all problem generation logic should be abstracted to separate namespace. This will allow for scalability so the mobile teams would only have to write frontend. Game aspects such as:

1. Problem generation
2. Problem solution check
3. Score tracking
4. Statistics
5. Analytics
6. Insights

will be stored in separate package written in [Rust](https://www.rust-lang.org). See technical consideration of selecting Rust as a primary language for game logic in [Core in Rust](./4_4_TDR%3A%20Core%20in%20Rust.md). Not only should the game logic be thoroughly encoded in a framework, it should have meaningful textual description to facilitate migration to Rust. Moreover, stated methodology mill allow for targeted unit-testing.

## Enforcing Methodology in Code

`XCTestCase` is a good option to enforce methodology through the system of test cases. For one, randomness ratios, edge cases and conforming to methodology principles can be tested via unit testing. Having these tests in place will alert a developer each time he has broken the crucial logic.
These tests should be structured according to the methodology described below. 

```suggestion

## Problem Generation Methodology

Problem generation anatomy comprises of the following steps:

1. Determining the operation
2. Selecting digits capacity
3. Defining the upper and lower bounds for random number selection range
4. Pikcing random number from the range
5. Optional zero-check for division operations

### Determining The Operation

The operation is selected randomly from the finite set of [basic arithmetic operations](https://en.wikipedia.org/wiki/Arithmetic#:~:text=The%20main%20arithmetic%20operations%20are,subtraction%2C%20multiplication%2C%20and%20division.).

### Selecting Digits Capacity

Digits capacity is selected based on provided max capacity number. Capacity is selected randomly from a range where the lower bound is always 1 and the upper bound is the max capacity number. Selected capacity is later used to determine the range from which the random number will be selected.

### Defining the upper and lower bounds for random number selection range

Upper and lower bounds of number selection series are determined via formulas:

- $\text{always zero}$

- $\text{max value}=10^{\text{maxValueExponent}} - 1$

### Pikcing random number from the range

The number is selected randomly and stored into a `var`.

### Optional zero-check for division operations

In some cases the number should not be zero. If, in such context, it appears to be zero, fallback random selection engages. There, random number is selected from the range, where the lower bound is `1` and the upper bound is max value.

## Constructing Division Problems Over Multiplication

When constructng division problem via the above described algorithm, two challenges arise:

- How to avoid zero rhs's?

- How to avoid fractional solution?

First one is tackled with optional zero-check for division operations. Second is dealt with through constructing and solving multiplication problem. Once constructed, it's solution (product) is taken as a dividend and one of the factors selected as a divisor. Therefore the solution cannot be fractional.