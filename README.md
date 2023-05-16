# Phobic
Phobic is a declarative concurrent programming language based on the higher order pi-calculus and designed with a focus on simulation, verification, and general purpose programming. Phobic can be thought of as a "process-oriented" language in which every program is composed of numerous processes communicating with one another. In fact, every computation in the language is a transmission across a named channel. Since the language is higher-order, processes and channels can themselves be communicated across channels as if they were data. In addition, the language includes probabilistic operators allowing computations to be selected with a specific probability. Phobic's type system allows the programmer to fine-tune the kinds of data that channels can communicate, how the data is communicated, and what kinds of side effects the transmission is allowed to have. In addition, Phobic implements a liquid type system which allows the user to specify subtypes that are constrained by formulas in first order logic. For examples of Phobic code see the `test/` directory. 

## Types
Phobic's type system is complex and has three layers. The first layer is called the behavioral layer, any agent is said to be well behaved (assigned the type `Proc` or `Obj`) precisely when each channel communication it contains type checks and the configuration of its operators is syntactically correct. The second layer is the channel layer. This layer allows one to specify if a channel is synchronous or asynchronous and allows or whether the channel contains specialized behaviors. The last and most extensive layer is the data layer which is the portion of the type system that governs the behavior of data communicated across channels.

### Standard Types
Literals and variables can be assigned one of the following basic types:
- 64-bit integers `Int`
- Double precision floating point `Float`
- Boolean type `Bool`
- Character/string type `String`
Channels can be assigned the following types:
- Sycnrhonous channel `#Type`
- Asynchronous channels `$Type`
- Some channels can engage in specialized behaviors, their types are given by:
   - Data encryption `ENCRYPT{Type, algorithm}`
   - Data decryption `DECRYPT{Type, algorithm}`
   - Random value generator `RAND{Type}`
   - stdio communication `IO{Type}`
   - File communication `FILE{Type}`
   - Socket communication `SOCKET{Type}` 
Phobic also supports tuples and finite arrays as indicated by the following notations
- Tuple `<type1, type2, ...>`
- Finite array `[type | size]`
Any type can be typed as unsafe in which case it has the option taking the value `nothing` with the notation `~Type`

### Liquid Types 
Liquid types are subtypes of standard types that must satisfy particular constraints in first order logic. Liquid types are defined using standard types that are restricted to a smaller subset of basic types. A liquid type is declared with two pieces, a type expression and a constraint. A type expression is a type annotation similar to the one above except that one or more basic types, `B`, are replaced by variables, `x:B`. The constraint expresses a formula in first order logic containing the variables bound in the type expression. A liquid type can be defined with the syntax `(type name) {refine TypeExpression with Constraint}`

### Examples
- Tuple of asychronous channels that encrypt/decrypt integers `(type AsyncIntAES) { <$ENCRYPT{Int, "AES"}, $DECRYPT{Int, "AES"}> }`
- 8x8 matrix of floating point numbers `(type Matrix_8x8) { [ [Float | 8] | 8] }
- Even integers `(type Even) {refine  x:Int with x%2=0 }`
- Pair of integers where the left is greater than the right and each is greater than 0 `(type Pair) {refine < x:Float, y:Float > with x >= y and 0 < x and 0 < y }`

## Operators
Phobic uses a restricted syntax primarily and can be thought of a message passing system with recursion.
### Definitions:
- Define a type `(type name param1, param2,...) {...}`
- Define a process (called an "agent") `(agent name param1:type1, param2:type2, ...) {...}`
- Define a class `(class name :- public base1, private base2,...) {...}`
### Core Language Constructions:
- Create a new channel with a limited scope `(new chan1:type1, chan2:type2, ...) {...}`
- Send a value along a channel `chan!<value>`
- Receive a value from a channel `chan?(value)`
- Perform two operations in parallel `op1 | op2`
- Perform two operations in sequence `op1 . op2`
- Randomly select non-blocking operation `op1 @ op2`
- Randomly select non-blocking operation with bias `op1 @{bias} op2`
- If-then-else block `(if condition) {...} (else if condition) {...} (else) {...}`
- Switch statement `(switch var){ (case value1) {...} (case value2) {...} ... (default) {...} }`
- Invoke agent `name {param1, param2, ...}`
- Perform type check at runtime `(assert var1:type1, var2:type2, ...) {...}`
- Perform operation unsafely `(unsafe) {...}`


## Classes and Objects
Object-orientation in Phobic is essentially syntactic sugar allowing the programmer to encapsulate systems of agents and the channels the communicate with in a common interface. Classes consist of one or more constructor definitions followed by member definitions where each member of the class must begin with `public`, `private`, or `protected`. A constructor is a specialized agent for building an object and can be specified with the syntax `(constructor param1:Type1, param2:Type2, ...) {...}`. The syntax for defining classes is given by:
```
(class base) {
   (constructor param1:Type1, param2:Type2, ...) {
      ...
   }

   public chan1 : Type1
   private chan2 : Type2
   ...
   protected (agent proc1 param:Type1) {
      ...
   }
   ...
}

(class derived :- public base) {
   (constructor) {
      ...
   }
   ...
}
```

