# Phobic

Phobic is a programming language based on the pi-calculus. Phobic is the closest english word to the acronym PHOPPiC (Probailistic Higher Order Pi-Calculus), the computational model that phobic uses. 

## Operators
0. Define macro `[def-macro Name Param1:Type1, Param2:Type2, ..]{ ...} foo`
1. Spawn new channel `[new Channel1:Type1, Channel2:Type2, ...]{...}`
2. Send across channel `Channel<X1, X2, ..., Xn> . foo`
3. Receive from channel `Channel(X1, X2, ...,Xn) . foo`
4. Do nothing (to be extended) `silent . foo`
5. Test syntactic equality `[if Term1 == Term2] { ... } . foo`
6. Test syntactic disequality `[if Term1 != Term2] { ... } . foo`
7. Expand macro `[MacroName]{Value1, Value2, ..., ValueN} . foo`
8. Execute in parallel `Term1 $ Term2`
9. Disjoin (with equal probability) `Term1 @ Term2`
10. Disjoin (with specific probability) `Term1 @{Probability} Term2`
11. Replicate `!Term1`
13. Stop execution `_`

## Notes:

0. Higher order communicating systems all for processes to be transmitted across channels, additionally, channels are polyadic meaning more than one value can be communicated across the channel. To declare a polyadic channel use the follow format `Channel:Type1\Type2\Type3\...`.
1. The only primitive types currently supported are:
   - `Int`
   - `Float`
   - `Bool`
   - `Char`
   - `String`
   - `Proc`
2. Standard arithmetic and logic have been implemented (more details coming soon)

##To Do
1. Build and include unit tests
2. Create tutorial and sample programs
3. Create semantic analysis module
4. Create execution environment
5. Create logic analysis units (designs coming later)
