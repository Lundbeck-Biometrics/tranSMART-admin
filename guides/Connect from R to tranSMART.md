# Guide for connecting from R to tranSMART

This guide describes how to connect from R to the tranSMART server. It refers to public documentation available for tranSMART and adds specific information that applies to our infrastructure. 

## Prerequisites 


### Using a Windows machine 


If using a Windows machine, the user should: 

* have R and R Studio installed on own computer 
* have credentials for logging in to the tranSMART instance 
* have installed the transmartRClient or follow the installation procedure below 

#### Installing the transmartRClient: 

Open R Studio and run the following: 

```
install.packages('devtools') 
library('devtools') 
install_github('transmart/RInterface') 
```

### Using the RStudio Server 

If using our RStudio Server, the user should: 

* have credentials for logging in to the tranSMART instance 

The transmartRClient is already installed on the RStudio Server. 

## Connecting to tranSMART from R 


### How it works 

In order to connect to tranSMART from R you can use an R library for communicating with tranSMART. Source code and examples for this library can be found here: https://github.com/tranSMART/RInterface.  

The R client uses the REST API in order to access the data from tranSMART. Documentation on the tranSMART REST API can be found here: https://github.com/transmart/transmart-rest-api.


### Using the library 


To get started with a simple example you can follow the `demoCommands.R` code: https://github.com/tranSMART-Foundation/RInterface/blob/release-16.2/demo/demoCommands.R 

Authentication is handled when you start connecting to tranSMART and an access token will be needed in order to be able to access the data. The `connectToTransmart` call will return a URL to be used in order to retrieve the access token, and you will have to type this token back in R. See screenshot below for an example. 

![Example connection to tranSMART](https://github.com/Lundbeck-Biometrics/tranSMART-admin/blob/master/guides/example_transmart_R.png?raw=true "Example connection to tranSMART")

## Admin Guide: Installation of transmartRClient on RStudio Server 


To install the package on a Linux machine, you will have to install the `protobuf` dependency from command line. Installing RProtoBuf through R interface will fail. 

Ubuntu: 

`apt-get install libprotobuf-dev protobuf-c-compiler`

Red Hat: 

`yum install protobuf-compiler protobuf protobuf-devel`


Then install `dev-tools` and `transmartRClient`: 

```
require(devtools) 
install_github('transmart/RInterface')  
```
