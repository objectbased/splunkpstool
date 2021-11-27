# splunkpstool
Powershell script that provides the ability to download various Splunk Universal Forwarder packages along with the ability to install with an assortment of paramters on a local machine.

## Switches
```
powershell -ExecutionPolicy Bypass -File splunkpstool.ps1 -?
[[-agent_version] <string>] [[-platform] <string>] [[-arch] <string>] [[-binary] <string>] [[-ds] <string>] [[-install_dir] <string>] [-download] [-install]
```


|   Switches & Parameters   | Description | Example |
| ------------- | ------------- | ------------- |
| -agent_version  | Set a specific agent version. If not supplied a list of available versions will be shown and user input will be requred.  | -agent_version 8.0.0
| -platform  | Set a specific platform to use. The options are Windows or Linux. If not supplied user input will be required. | -platform windows
| -arch | Set a specific architecture to use. If not supplied a list of available architecture types will be shown and user input will be required | -arch x86
| -binary | Full path of local Splunk Universal Forwarder binary to install. If not supplied using the -download switch will allow you download a package locally from www.splunk.com | -binary "C:\Downloads\splunkforwarder-8.1.1-08187535c166-x64-release.msi"
| -ds | Provide the name of a deployment server to configure when installing the agent. | -ds "https://splunk.com:8089"
| -install_dir | Set the install directory to a custom location. If not set the default path will be used C:\Program Files\SplunkUniversalForwarder. | -install_dir "G:\SplunkForwarder"
| -download | Switch is required when downloading a package locally and can be used with -install for installation. This switch is a boolean. | -download
| -install | Switch is required when installing a pack locally on the machine. This switch is a boolean | -install

## How it Works
Run the script from powershell directly or from a CMD prompt

**Option 1** - Download
```
powershell -ExecutionPolicy Bypass -File splunkpstool.ps1 -download
```
**Option 2** - Download with parameters
```
powershell -ExecutionPolicy Bypass -File splunkpstool.ps1 -download -agent_version 7.3.3 -platform windows -arch x86_64
```
**Option 3** - Download with parameters and install
```
powershell -ExecutionPolicy Bypass -File splunkpstool.ps1 -download -install -agent_version 7.3.3 -platform windows -arch x86_64 
```
