# esx_server
Hello, and welcome to my base level ESX server. Please let me know what you think. I can be reached at <cscawley@mac.com>.

# download server

Manually download the latest FiveM server binaries from:

https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/
 
or

https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/

Extract the contents to a 'server' directory.

# execute sql

```
mysql -u ADMINUSER -p < schema/run.sql
```

# run server

In the root of the project folder

**Command Prompt**

```
C:\PATH\TO\DIRECTORY\server\run.cmd +exec server.cfg
```

**Shell**

```
/PATH/TO/DIRECTORY/server/run.cmd +exec server.cfg
```
