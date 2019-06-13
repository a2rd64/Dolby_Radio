#!/system/bin/sh


mount -o rw,remount /
mount -o rw,remount /cache
mount -o rw,remount /data
mount -o rw,remount /system


API=$(cat /system/build.prop | grep "ro.build.version.sdk=" | dd bs=1 skip=21 count=2)


if [ "$API" -ge "26" ]; then

  setenforce 0

fi


for MAGISK in /data/magisk.img /cache/magisk.img; do

  if [ -e "$MAGISK" ]; then

    source /data/magisk/util_functions.sh

    if [ "$MAGISK_VER_CODE" -lt "1400" ]; then

      SUPOLICY='sepolicy-inject --live'

    else

      SUPOLICY='supolicy --live'

    fi

  else

    SUPOLICY='supolicy --live'

  fi

done


$SUPOLICY "permissive audio_prop audioserver dolby_prop mediaserver priv_app"

$SUPOLICY "allow audioserver audioserver_tmpfs file *"

$SUPOLICY "allow mediaserver mediaserver_tmpfs file *"

$SUPOLICY "allow priv_app init unix_stream_socket *"

$SUPOLICY "allow priv_app property_socket sock_file *"


mount -o ro,remount /system


exit 0
