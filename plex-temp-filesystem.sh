#!/bin/bash

function ts () {
    echo -n "$(date +'%F-%R:%S ')"
    echo $*
}

LOOP_FS_MOUNT="/run/shm/plex"
LOOP_FS_FILE="${LOOP_FS_MOUNT}/plex_temp_fs"
SIZE="2G"

ts "Is the plex fs mounted?"
df -h ${LOOP_FS_MOUNT} 
if [[ "$?" == "0" ]] ; then
    ts "${LOOP_FS_MOUNT} is mounted, unmounting"
    umount -v ${LOOP_FS_MOUNT}
fi

ts "ls /run/shm | grep plex"
ls -la /run/shm | grep plex

# Make sure the directory is there, and correct
if [[ -e "${LOOP_FS_MOUNT}" ]] ; then
    ts "${LOOP_FS_MOUNT} exists"
    if [[ ! -d "${LOOP_FS_MOUNT}" ]] ; then 
        ls ${LOOP_FS_MOUNT}
        ts "rm ${LOOP_FS_MOUNT}"
        rm -v ${LOOP_FS_MOUNT} 
    fi
fi

ts "mkdir -vp ${LOOP_FS_MOUNT}"
mkdir -vp ${LOOP_FS_MOUNT}

ts "Creating loop FS"
echo dd count=0 bs=1 if=/dev/zero of=${LOOP_FS_FILE} seek=${SIZE}
dd count=0 bs=1 if=/dev/zero of=${LOOP_FS_FILE} seek=${SIZE}
ls ${LOOP_FS_FILE}

ts "Making a fs into ${LOOP_FS_FILE}"
echo mkfs.ext4 -F ${LOOP_FS_FILE} ; sleep 2
mkfs.ext4 -F ${LOOP_FS_FILE}


ts "Chowing the file into \"plex\""
chown -Rv plex: ${LOOP_FS_MOUNT}

ts "Loop mounting ${LOOP_FS_FILE} to ${LOOP_FS_MOUNT}"
mount -v ${LOOP_FS_FILE} ${LOOP_FS_MOUNT}

ts "Chowing into the loop FS"
chown -Rv plex: ${LOOP_FS_MOUNT}

ts "Is the plex fs mounted?"
df -h ${LOOP_FS_MOUNT}
if [[ "$?" == "0" ]] ; then
    ts "${LOOP_FS_MOUNT} is mounted"
else
    ts "${LOOP_FS_MOUNT} is unmounted"
fi 
