# ubuntu-pms-loop-fs-maker

Change your plex systemd such that:

```
execStartPre=/bin/sh -c '/usr/bin/test -d "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}" || /bin/mkdir -p "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}"'
```

Becomes:
```
execStartPre=/bin/sh -c 'test -d /dev/shm/plex || sudo /usr/local/bin/plex-temp-filesystem.sh ; /usr/bin/test -d "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}" || /bin/mkdir -p "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}"'
```

Then:

```
% sudo systemctl daemon-reload
```

This will restart your PMS, this will restart plex *and* create a loop fs in memory at /dev/shm/plex
```
% df -h /dev/shm/plex
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0      2.0G  6.0M  1.8G   1% /dev/shm/plex
```

Then, enter your settings -> server -> transcoder, then click "show advanced" and change the:

"Transcoder temporary directory" to be /dev/shm/plex

I saw a dramatic increase in transcoding speed but YRMV

