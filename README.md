# TMS FNC Cloud Pack #

FREE open-source components for seamless access to various REST services.

## Installation notes ##
Each subfolder of this repository contains a set of files based on the <a href="http://www.tmssoftware.com/site/tmsfnccloudpack.asp" target="_blank">TMS FNC Cloud Pack</a> and <a href="http://www.tmssoftware.com/site/tmsfnccore.asp" target="_blank">TMS FNC Core</a>
To install these components, please follow the steps below
### FMX ###
<ol>
  <li>Create a new package</li>
  <li>Add the FMX*.pas files to the package</li>
  <li>Add dependencies to FMXTMSFNCCloudPackPkg*.dcp and FMXTMSFNCCorePkg*.dcp</li>
  <li>Build and install the package</li>
  <li>Update the library path with the local folder source checkout of the subfolder of this repository</li>
</ol>

### VCL/WEB ###
<ol>
  <li>Create a new package</li>
  <li>Add the VCL*.pas files to the package</li>
  <li>Add dependencies to VCLTMSFNCCloudPackPkg*.dcp and VCLTMSFNCCorePkg*.dcp</li>
  <li>Build and install the package</li>
  <li>Update the library path with the local folder source checkout of the subfolder of this repository</li>
  <li>For WEB: update the TMS WEB library path under Options</li>
</ol>

### LCL ###
<ol>
  <li>Create a new package</li>
  <li>Add the LCL*.pas files to the package</li>
  <li>Add dependencies to LCLTMSFNCCloudPackPkg*.dcp and LCLTMSFNCCorePkg*.dcp</li>
  <li>Build and install the package</li> 
</ol>

### Samples ###
Each subfolder of this repository contains a QuickStart.html page that contains a code snippet to get up and running.
<br/>
<i>*:The name of the units you want to add.</i>
<br/>
<i>**:The version of RAD Studio you are using (ex. XE12 = RAD Studio 10.3 Rio).</i>
