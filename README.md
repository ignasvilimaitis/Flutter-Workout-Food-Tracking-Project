# README
## Description
A major pain point in many of the free fitness applications is the lack of passion and the maximisation of revenue. In a world where data is becoming increasingly valuable, these motives are a genuine concern that lead to questionable practices within the industry, from overcharging, to AI misinformation, to subscription model "enshitification" that cost the equivalent to a premium gym subscription itself.

The aim of this project is to provide an all-in-one application combining dietary and gym tracking, with the user at the core. This project strictly believes in being open-source and respecting personal privacy at the heart of every design decision, that's why no data will ever be stored outside of the device, external endpoints are strictly limited, and the UI/UX is user-autonomy-first.

While the dream is big, the project is directly inspired by data privacy movements and hopes to make a valuable impact for individuals who want a simple yet competent tracker for their fitness.

## Installation
Currently due to being WIP this can only be run locally, and so the installation instructions are just how I personally run the project to develop it.
### Pre-requisites
- This project is created using the [[Flutter]] development kit, using the Dart programming language. A guide on [how to install flutter is here.](https://docs.flutter.dev/install)
- An IDE (like VsCode)
- ADB and scrcpy packages for mirroring Android device onto computer.

### Steps
1. Clone the Git repository
2. Mirror the Android device to the computer:
	- **Wireless:**
```
# Connect device using a cable if first time.

# Once connected - check if device shows up:
adb devices

# Connect to device using the local IP of the device:
adb connect 192.168.0.237:5555

# Output should be:
# "connected to 192.168.0.237:5555"

# Launch scrcpy:
scrcpy

# A window should open with the mirrored connected android device
```

- **Wired**
```
# Connect device using cable

# Ensure device is connected:
adb devices

# Launch scrcpy
scrcpy

# A window should open with the mirrored connected android device
```

3. Navigate to IDE with the cloned repository
4. run the project with "flutter run"

## Authors and acknowledgement
The project has been split between two students with the hope of making the world a slightly better place.