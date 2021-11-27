# splunkpstool
Powershell script that provides the ability to download various Splunk Universal Forwarder packages along with the ability to install with an assortment of paramters on a local machine.

## How it Works
Run the script from powershell directly or from a CMD prompt

## Help

```
powershell -ExecutionPolicy Bypass -File splunkpstool.ps1 -?
```

**Option 1** - Download
```
powershell -ExecutionPolicy Bypass -File splunkpstool.ps1 -download
```
**Option 2** - Download with paramters
```
powershell -ExecutionPolicy Bypass -File splunkpstool.ps1 -download -agent_version 7.3.3 -platform windows -arch x86_64
```
**Option 3** - Download with paramters and install
```
powershell -ExecutionPolicy Bypass -File splunkpstool.ps1 -download -install -agent_version 7.3.3 -platform windows -arch x86_64 
```
