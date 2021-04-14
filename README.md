# EPSON Printer Updater

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/timoschwarzer/epson-updater-web?style=for-the-badge)

This tool helps to upload firmware binaries to EPSON printers where the EPSON update
utility is not feasible to use because of restricted broadcast traffic or lack of a
machine running Windows.

### Tested printers

| Model                                | works |
|--------------------------------------|-------|
| Workforce Pro WF-C5790DWF BAM        | ✅    |


### Option 1: Run the web interface with Docker

```shell
docker run -p 3000:3000 timoschwarzer/epson-update-web
```

Now you can open `http://localhost:3000` in your browser and run the firmware update.


### Option 2: Run the script manually

The script can be found [here](./scripts/epson-update.sh).

Dependencies:
- coreutils
- curl

Usage:

```shell
./epson-update.sh <printer ip> <firmware>
```

NOTE: The firmware file has to be extracted from the *.efu archive (e.g. open the *.efu file with 7zip)


### Disclaimer

This project is not affiliated with EPSON in any way and comes without any warranty.
Use at your own risk.
