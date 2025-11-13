# Testing Guide

This document explains how to run the Pester unit tests for the bootstrap script.

## Prerequisites

### Install Pester

The tests require Pester 5.0.0 or later. Install it with:

```powershell
Install-Module -Name Pester -MinimumVersion 5.0.0 -Force -SkipPublisherCheck
```

Verify installation:

```powershell
Get-Module -Name Pester -ListAvailable
```

## Running Tests

### Run All Tests

From the repository root:

```powershell
Invoke-Pester -Path .\bootstrap.Tests.ps1
```

### Run with Detailed Output

```powershell
Invoke-Pester -Path .\bootstrap.Tests.ps1 -Output Detailed
```

### Run Specific Test Suite

```powershell
# Test only Install-Chezmoi function
Invoke-Pester -Path .\bootstrap.Tests.ps1 -TagFilter 'Install-Chezmoi'

# Or use -FullNameFilter
Invoke-Pester -Path .\bootstrap.Tests.ps1 -FullNameFilter '*Install-Chezmoi*'
```

### Generate Code Coverage Report

```powershell
$config = New-PesterConfiguration
$config.Run.Path = '.\bootstrap.Tests.ps1'
$config.CodeCoverage.Enabled = $true
$config.CodeCoverage.Path = '.\bootstrap.ps1.example'
$config.CodeCoverage.OutputFormat = 'JaCoCo'
$config.CodeCoverage.OutputPath = '.\coverage.xml'

Invoke-Pester -Configuration $config
```

### Run Tests in CI/CD

```powershell
$config = New-PesterConfiguration
$config.Run.Path = '.\bootstrap.Tests.ps1'
$config.Run.Exit = $true
$config.TestResult.Enabled = $true
$config.TestResult.OutputFormat = 'NUnitXml'
$config.TestResult.OutputPath = '.\test-results.xml'

Invoke-Pester -Configuration $config
```

## Test Coverage

The test suite covers the following functions:

### ✓ Install-Chezmoi
- Detects existing chezmoi installation
- Installs via scoop when available (preferred method)
- Falls back to winget if scoop fails
- Installs via winget when scoop unavailable
- Refreshes PATH after winget installation
- Handles missing package managers gracefully
- Updates installation statistics

### ✓ Install-Scoop
- Detects existing scoop installation
- Installs scoop from official URL
- Changes execution policy when restricted
- Preserves execution policy when not restricted
- Handles installation failures
- Updates installation statistics

### ✓ Initialize-Chezmoi
- Converts GitHub shorthand (user/repo) to full URL
- Preserves full URLs when provided
- Handles HTTP/HTTPS URLs
- Passes branch parameter correctly
- Uses --apply flag during initialization
- Updates configuration statistics
- Handles initialization failures

### ✓ Set-EnvironmentVariables
- Sets XDG_CONFIG_HOME correctly
- Sets XDG_DATA_HOME correctly
- Sets XDG_STATE_HOME correctly
- Sets XDG_CACHE_HOME correctly
- Persists variables at User scope
- Updates current session environment
- Uses USERPROFILE as base path

### ✓ Test-CommandExists
- Returns true for existing commands
- Returns false for non-existent commands
- Handles errors gracefully

## Test Structure

Tests are organized using Pester's BDD-style syntax:

```powershell
Describe 'FunctionName' {
    Context 'When condition' {
        It 'Should behavior' {
            # Arrange, Act, Assert
        }
    }
}
```

### Mocking Strategy

The tests use extensive mocking to:
- Isolate functions from external dependencies
- Avoid actual system modifications
- Test error handling paths
- Verify correct parameters are passed to external commands

Example:
```powershell
Mock Test-CommandExists { $true } -ParameterFilter { $Command -eq 'scoop' }
```

## Common Issues

### Issue: Tests fail with "Module not found"

**Solution:** Ensure Pester 5.0+ is installed:
```powershell
Install-Module -Name Pester -Force -SkipPublisherCheck
```

### Issue: Tests modify actual system

**Solution:** All tests use mocks. If you see system changes, check that mocks are properly defined in `BeforeAll`/`BeforeEach` blocks.

### Issue: PATH not refreshing in tests

**Solution:** This is expected behavior. Tests mock environment variable operations to avoid side effects.

## Continuous Integration

Example GitHub Actions workflow:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install Pester
        shell: pwsh
        run: Install-Module -Name Pester -MinimumVersion 5.0.0 -Force
      
      - name: Run Tests
        shell: pwsh
        run: |
          $config = New-PesterConfiguration
          $config.Run.Path = '.\bootstrap.Tests.ps1'
          $config.Run.Exit = $true
          $config.TestResult.Enabled = $true
          Invoke-Pester -Configuration $config
      
      - name: Upload Test Results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: test-results
          path: test-results.xml
```

## Adding New Tests

When adding new functions to `bootstrap.ps1.example`, follow this pattern:

1. Create a new `Describe` block with the function name
2. Group related tests in `Context` blocks
3. Use `BeforeEach` to reset state
4. Mock external dependencies
5. Test both success and failure paths
6. Verify side effects (stats, environment variables, etc.)

Example:

```powershell
Describe 'New-Function' {
    BeforeEach {
        # Reset state
    }
    
    Context 'When successful' {
        It 'Should perform expected action' {
            # Arrange
            Mock External-Dependency { }
            
            # Act
            $result = New-Function
            
            # Assert
            $result | Should -Be $expected
        }
    }
    
    Context 'When failure occurs' {
        It 'Should handle error gracefully' {
            Mock External-Dependency { throw "Error" }
            
            $result = New-Function
            
            $result | Should -Be $false
        }
    }
}
```

## Additional Resources

- [Pester Documentation](https://pester.dev/docs/quick-start)
- [Pester Best Practices](https://pester.dev/docs/usage/mocking)
- [PowerShell Testing Guide](https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/test-with-pester)
