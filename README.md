# esx_server
Hello, and welcome to my base level ESX server. Please let me know what you think. I can be reached at <cscawley@mac.com>.

# download server

Manually download the latest FiveM server binaries from:

https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/
 
or

https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/

Extract the contents to a 'server' directory.

# Create Developer Accounts And Apply Access Keys

**Login to the Steam API key access portal where you can generate a Steam API key https://steamcommunity.com/dev/apikey**

replace the key on line 9 in server.cfg

```
set steam_webApiKey "87688E3EE9A373BA28C48A7AE8F8B0C5"
```

Don't worry. That one's already revoked :)

**Create a FiveM account https://forum.fivem.net**

login to the FiveM Keymaster portal and generate a server key https://keymaster.fivem.net/

replace the key on line 11 in server.cfg

```
sv_licenseKey "16qiq5pzd25xrkfckfma8nordms8ot2n"
```

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
