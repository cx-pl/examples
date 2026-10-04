# CX examples

Each directory contains a small, focused CX source example. An executable CX
`Main` function is used as the generated C entry point; it may take no
parameters or one `string[] args` parameter and return `void` or `int`.

- `0. Hello World` — imports and a simple entry point.
- `1. Classes` — classes, structs, interfaces, inheritance, and overrides.
- `2. Enums and Switch` — enums with explicit values and `switch`.
- `3. Arrays and Loops` — array allocation, indexing, `for`, `foreach`, and
  loop exit statements.
- `4. Properties` — regular, static, and indexed property declarations.
- `5. Expressions` — arithmetic, bitwise, conditional, and null-coalescing
  expressions.
- `6. Generics` — inferred and explicit generic calls, generic arrays and
  nested types, and a two-parameter generic class with a generic method.

The regression script checks each sample's expected output and exit code. The
Hello World sample exercises `Main(string[] args)`. With the compiler,
CMake, and a local `cxcore` checkout available, run the set from the workspace
root:

```powershell
.\examples\run-regressions.ps1 -Cxc cxc -CxCoreDir .\cxcore
```

If CMake is not on `PATH`, pass its executable with `-CMake`. The compiler writes
generated files beneath each sample's `.obj/` directory and places executables
under `.bin/`. Use `--output-dir` when compiling a sample directly to keep
generated files in a separate build directory.
