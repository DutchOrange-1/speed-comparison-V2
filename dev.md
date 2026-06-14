# Development and setup
This document is here to show how to setup this project for local testing, and some problems I personally ran into. 

# Running Earthly
### Run everything
Earthly allows to run everything with a single command:
```bash
earthly +all
```
This will run all tasks to collect all measurements and then run the analysis.

### Collect data
To collect data for all languages run:
```bash
earthly +collect-data
```


# Installing Earthly
I found the documentation on this quite hard, hence here is what I used:

## 1. Verify Docker Installation

Ensure Docker is installed and running:

```bash
docker --version
```

## 2. Download the Latest Earthly Binary

```bash
wget https://github.com/earthly/earthly/releases/latest/download/earthly-linux-amd64
```

Alternatively:

```bash
curl -L -o earthly-linux-amd64 \
https://github.com/earthly/earthly/releases/latest/download/earthly-linux-amd64
```

## 3. Make the Binary Executable and Install It

```bash
chmod +x earthly-linux-amd64
sudo mv earthly-linux-amd64 /usr/local/bin/earthly
```

## 4. Verify the Installation

```bash
earthly --version
```

## 5. Bootstrap Earthly

```bash
sudo earthly bootstrap --with-autocomplete
```

## 6. Test the Installation

```bash
earthly github.com/earthly/hello-world+hello
```

If the command completes successfully, Earthly has been installed correctly.

If you are still confused, check out [The Claude MD file](./CLAUDE.md) as it seems to contain more infor that the main one.  

# Extra commands:
To publish the data:
```bash
python3 publish.py --results ./results/ --docs ./docs/
```
Note for those running it on their own server, when running +all, the volume of files temprarily created is around 10-15 GB. Have this open else you will run into a error. 
<br><br>
Also, make sure to use:

```bash
earthly prune
```
to clean up the docker containers ! I have noticed after several runs, the images can build up to about 50 GB of data. 
<br>
I have noticed several times, that languges would fail, as they are limited due to then umber of parallel containers, this should fix this error on smaller machines:

```bash
earthly config global.buildkit_max_parallelism 4
```
The above code sadly did not work for me, hence had to manually do this through a command to make it serial. 
```bash
earthly +systems && \
earthly +jvm && \
earthly +dotnet && \
earthly +functional && \
earthly +scripting && \
earthly +javascript && \
earthly +other-compiled
```
This is not ideal, but due to my location / wifi it seems I get flagged more easily when making multiple requests. 
<br>
To automate this, I made the script,  [collect_all_data_safe.py](./collect_all_data_safe.py) which also logs the time, and re-executes the code if they do fail. 

```bash
python3 collect_all_data_safe.py
```
Another fix seems to be to just login, via **docker login** to allow for more requests. 

# Adding new languges

XXX

# Testing
This was to evaluate the number of max parallelism and possible failures. 
### 2 parallel 
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

### 4 Parallel
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

### 6 Parallel
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

# Testing caching 
## No Cach (Running systems)
```

```
# cached


Still need to find a way to purge the old content if needed. 
