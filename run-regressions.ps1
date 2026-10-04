param(
    [string] $Cxc = 'cxc',
    [string] $CxCoreDir = (Join-Path $PSScriptRoot '..\cxcore'),
    [string] $CMake = 'cmake'
)

$ErrorActionPreference = 'Stop'
$examplesRoot = (Resolve-Path $PSScriptRoot).Path
$cxCorePath = (Resolve-Path $CxCoreDir).Path
$cases = @(
    @{ Source = '0. Hello World\HelloWorld.cx'; Module = 'HelloWorld'; Arguments = @('first', 'beta'); Output = 'Hello world!' },
    @{ Source = '1. Classes\Classes.cx'; Module = 'Classes'; Arguments = @(); Output = '' },
    @{ Source = '2. Enums and Switch\EnumsAndSwitch.cx'; Module = 'EnumsAndSwitch'; Arguments = @(); Output = 'enum pass' },
    @{ Source = '3. Arrays and Loops\ArraysAndLoops.cx'; Module = 'ArraysAndLoops'; Arguments = @(); Output = 'arrays pass' },
    @{ Source = '4. Properties\Properties.cx'; Module = 'Properties'; Arguments = @(); Output = 'properties pass' },
    @{ Source = '5. Expressions\Expressions.cx'; Module = 'Expressions'; Arguments = @(); Output = 'expressions pass' },
    @{ Source = '6. Generics\Generics.cx'; Module = 'Generics'; Arguments = @(); Output = 'generics pass' }
)

$originalPath = $env:PATH
try {
    if (Test-Path -LiteralPath $CMake -PathType Leaf) {
        $env:PATH = "$(Split-Path -Parent (Resolve-Path $CMake).Path);$env:PATH"
    }

    foreach ($case in $cases) {
        $sourcePath = Join-Path $examplesRoot $case.Source
        $compilerArguments = @(
            '--compile', '--cxcore-dir', $cxCorePath, '--verbosity', 'quiet', $sourcePath
        )

        if ($Cxc.EndsWith('.dll', [StringComparison]::OrdinalIgnoreCase)) {
            & dotnet $Cxc @compilerArguments
        }
        else {
            & $Cxc @compilerArguments
        }
        if ($LASTEXITCODE -ne 0) {
            throw "Compilation failed for $($case.Source) (exit $LASTEXITCODE)."
        }

        $binaryDirectory = Join-Path (Split-Path -Parent $sourcePath) '.bin'
        $executable = Get-ChildItem -LiteralPath $binaryDirectory -Filter "$($case.Module).exe" -File -Recurse |
            Select-Object -First 1
        if ($null -eq $executable) {
            throw "Native executable was not created for $($case.Module)."
        }

        $programArguments = @($case.Arguments)
        $actualOutput = (& $executable.FullName @programArguments | ForEach-Object { "$_" }) -join "`n"
        $exitCode = $LASTEXITCODE
        if ($exitCode -ne 0 -or $actualOutput.Trim() -ne $case.Output) {
            throw "$($case.Module) failed: exit=$exitCode output='$($actualOutput.Trim())'."
        }
        Write-Output "PASS $($case.Module)"
    }
}
finally {
    $env:PATH = $originalPath
}
