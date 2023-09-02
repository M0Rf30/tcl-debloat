#!/usr/bin/sh
set -e
TEMP_DIR=tmp-tcl-debloater
KODI_URL=https://mirrors.kodi.tv/releases/android/arm/kodi-20.2-Nexus-armeabi-v7a.apk
BLOAT=$(
  cat <<EOF
android.autoinstalls.config.google.gtvpai
au.com.stan.and
com.amazon.amazonvideo.livingroom
com.android.cts.ctsshim
com.android.cts.priv.ctsshim
com.android.dreams.basic
com.android.hotspot2.osulogin
com.android.htmlviewer
com.android.providers.userdictionary
com.android.settings.intelligence
com.android.soundpicker
com.android.statementservice
com.android.vending
com.google.android.apps.mediashell
com.google.android.apps.nbu.smartconnect.tv
com.google.android.apps.tv.dreamx
com.google.android.feedback
com.google.android.gms
com.google.android.gsf
com.google.android.inputmethod.latin
com.google.android.katniss
com.google.android.marvin.talkback
com.google.android.onetimeinitializer
com.google.android.overlay.modules.permissioncontroller
com.google.android.partnersetup
com.google.android.play.games
com.google.android.sss.authbridge
com.google.android.syncadapters.calendar
com.google.android.tts
com.google.android.videos
com.google.android.youtube.tv
com.google.android.youtube.tvmusic
com.netflix.ninja
com.tcl.accessibility
com.tcl.android.webview
org.chromium.webview_shell
tv.wuaki.apptv
EOF
)

BLOAT_EX=$(
  cat <<EOF
com.tcl.assistant
com.tcl.autopair
com.tcl.bi
com.tcl.browser
com.tcl.channelplus
com.tcl.dashboard
com.tcl.esticker
com.tcl.gallery
com.tcl.gamebar
com.tcl.guard
com.tcl.hearaid
com.tcl.keyhelp
com.tcl.messagebox
com.tcl.micmanager
com.tcl.MultiScreenInteraction_TV
com.tcl.notereminder
com.tcl.overseasappshow
com.tcl.smartalexa
com.tcl.t_solo
com.tcl.usercenter
com.tcl.waterfall.overseas
EOF
)

read -p "TCL IP: " TCL_IP
adb connect $TCL_IP | grep -q fail && echo "Unable to connect to TCL TV" && false

mkdir -p $TEMP_DIR

# echo "Downloading Kodi"
# wget $KODI_URL -O $TEMP_DIR/kodi.apk
# echo "Installing Kodi"
# adb install $TEMP_DIR/kodi.apk

rm -r $TEMP_DIR

# for package in $BLOAT; do
#   echo "Disabling ${package}"
#   adb shell pm disable-user --user 0 $package | true
# done

for package in $BLOAT_EX; do
  echo "Disabling ${package}"
  adb shell pm disable-user --user 0 $package | true
done

# restore uninstalled packages
# for package in $BLOAT
# do
# 	echo "enable ${package}"
# 	adb shell pm enable $package | true
# done

# restore uninstalled packages
# for package in $BLOAT_EX
# do
# 	echo "enable ${package}"
# 	adb shell pm enable $package | true
# done

# Not sure or needed
# com.android.providers.downloads
# com.android.providers.media
# com.android.providers.media.module
# com.tcl.inputmethod.international
# com.tcl.miracast # disabling this, no screen sharing
# com.tcl.partnercustomizer # disabling this, kill rc tv button
# com.tcl.tcl_bt_rcu_service
# com.tcl.tv.tclhome_passive
# com.tcl.useragreement
# com.tcl.versionUpdateApp
# com.tcl.xian.StartandroidService
