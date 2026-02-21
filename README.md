# DriverHarvest (Shark Rider)

**Driver companion tool for Snapp & Tapsi drivers**  
Silent ride & chat logger + passenger reputation scoring + proof capture (local-only, sideloaded APK for Android 8.0+).

Built for Iranian drivers — counters platform asymmetry (passenger protection vs. driver vulnerability).

## Features
- Real-time scraping from Snapp (`cab.snapp.driver`) & Tapsi (`taxi.tap30.driver`)
- Passenger fingerprinting & reputation (rude, thief, tipper, etc.)
- USB webcam proof recording (optional OTG cam + phone mic)
- Local Room DB storage + CSV/JSON export
- No cloud (yet) — fully offline, private

## Status
- MVP core: ride capture + export
- In progress: rating system, USB cam integration
- Planned: controlled hashed sharing (driver communities)

## Requirements
- Android 8.0+ (tested on Samsung A23 class)
- AccessibilityService enabled (one-time setup)
- Optional: USB OTG + cheap UVC webcam (\~$5–15)

## Installation (Sideloaded)
1. Download latest APK from [Releases](https://github.com/YOURUSERNAME/driverharvest/releases)
2. Enable "Install unknown apps" for your browser/file manager
3. Install → open → grant Accessibility (Settings > Accessibility > DriverHarvest > On)
4. Done — it watches Snapp/Tapsi automatically

## Build from Source
```bash
git clone https://github.com/YOURUSERNAME/driverharvest.git
cd driverharvest
./gradlew assembleDebug
