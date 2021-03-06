## Using the Python client for tranSMART REST API

### Developer info

While developing new features into the client, use the following to install the tranSMART client from a folder: 

```
pip3 install -e transmart-api-client-py
```

To uninstall:

```
pip3 uninstall transmart
```

### Sys admin info

To install the tranSMART client system-wide:

* From latest release: 
```
sudo pip3 install transmart
```
* From our GitHub repo: 
```
sudo pip3 install git+https://github.com/Lundbeck-Biometrics/transmart-api-client-py.git

# Or from a certain branch:
sudo pip3 install git+https://github.com/Lundbeck-Biometrics/transmart-api-client-py.git@add_gwas_endpoints
```
