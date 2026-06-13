# Development and setup
This document is here to show how to setup this project for local testing, and some problems I personally ran into. 

# Testing
## 2 parallel 
```bash
Successful (7):
  ✓ earthly +systems          Attempts: 1  Time: 461.8s
  ✓ earthly +jvm              Attempts: 1  Time: 492.2s
  ✓ earthly +dotnet           Attempts: 1  Time: 490.8s
  ✓ earthly +functional       Attempts: 1  Time: 153.8s
  ✓ earthly +scripting        Attempts: 2  Time: 1471.6s
  ✓ earthly +javascript       Attempts: 1  Time: 76.7s
  ✓ earthly +other-compiled   Attempts: 1  Time: 703.9s
Failed (0):
================================================================================
Total elapsed time: 3850.7 seconds
Total elapsed time: 64.2 minutes
```
Ran with:
```bash
earthly config global.buildkit_max_parallelism 2
```

## 4 Parallel
```bash
Successful (7):
  ✓ earthly +systems          Attempts: 1  Time: 437.9s
  ✓ earthly +jvm              Attempts: 1  Time: 504.7s
  ✓ earthly +dotnet           Attempts: 2  Time: 1173.2s
  ✓ earthly +functional       Attempts: 2  Time: 303.3s
  ✓ earthly +scripting        Attempts: 1  Time: 841.4s
  ✓ earthly +javascript       Attempts: 1  Time: 69.5s
  ✓ earthly +other-compiled   Attempts: 1  Time: 139.0s
Failed (0):
================================================================================
Total elapsed time: 3469.0 seconds
Total elapsed time: 57.8 minutes
```
Ran with:
```bash
earthly config global.buildkit_max_parallelism 4
```

## 6 Parallel
```bash
Successful (7):
  ✓ earthly +systems          Attempts: 2  Time: 570.3s
  ✓ earthly +jvm              Attempts: 1  Time: 496.0s
  ✓ earthly +dotnet           Attempts: 1  Time: 632.7s
  ✓ earthly +functional       Attempts: 1  Time: 240.4s
  ✓ earthly +scripting        Attempts: 1  Time: 672.3s
  ✓ earthly +javascript       Attempts: 1  Time: 16.6s
  ✓ earthly +other-compiled   Attempts: 1  Time: 135.3s
Failed (0):
================================================================================
Total elapsed time: 2763.6 seconds
Total elapsed time: 46.1 minutes
```
Ran with:
```bash
earthly config global.buildkit_max_parallelism 6
```
