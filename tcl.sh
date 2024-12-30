#!/usr/bin/sh
set -e
TEMP_DIR=tmp-tcl-debloater
FLAUNCHER_URL=https://github.com/CocoCR300/flauncher/releases/download/v2024.12.004/flauncher-armeabi-v7a-release.apk
KODI_URL=https://mirrors.kodi.tv/releases/android/arm/kodi-21.1-Nexus-armeabi-v7a.apk
SMARTTUBE_URL=https://github.com/yuliskov/SmartTube/releases/download/25.24s/SmartTube_stable_25.24_armeabi-v7a.apk

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
com.google.android.apps.tv.launcherx
com.google.android.feedback
com.google.android.gms # V8-R51MT05-LF1V578 requires this for launcherx; not true for V8-R51MT05-LF1V599
com.google.android.gsf # V8-R51MT05-LF1V578 requires this for launcherx; not true for V8-R51MT05-LF1V599
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
com.google.android.tungsten.setupwraith
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
com.tcl.autopair # seems that this disable bt rc pairing
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
com.tcl.tcl_bt_rcu_service # although the name, seems not related to rc auto-pair
com.tcl.useragreement
com.tcl.usercenter
com.tcl.waterfall.overseas
com.tcl.xian.StartandroidService
EOF
)

echo "TCL IP:"
TCL_IP=$(cat)
adb connect "$TCL_IP" | grep -q fail && echo "Unable to connect to TCL TV" && false

mkdir -p $TEMP_DIR


echo "Downloading FLauncher"
wget $FLAUNCHER_URL -O $TEMP_DIR/flauncher.apk
echo "Installing FLauncher"
adb install $TEMP_DIR/flauncher.apk

echo "Downloading Kodi"
wget $KODI_URL -O $TEMP_DIR/kodi.apk
echo "Installing Kodi"
adb install $TEMP_DIR/kodi.apk

echo "Downloading SmartTube Next"
wget $SMARTTUBE_URL -O $TEMP_DIR/stn.apk
echo "Installing SmartTube Next"
adb install $TEMP_DIR/stn.apk

rm -r $TEMP_DIR

for package in $BLOAT; do
  echo "Disabling ${package}"
  adb shell pm disable-user --user 0 "$package" | true
done

for package in $BLOAT_EX; do
  echo "Disabling ${package}"
  adb shell pm disable-user --user 0 "$package" | true
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
# com.tcl.tv.tclhome_passive
# com.tcl.versionUpdateApp


# Entire list on 50C6459
# adb shell pm list packages | sort

# android
# android.autoinstalls.config.google.gtvpai
# au.com.stan.and
# com.amazon.amazonvideo.livingroom
# com.android.backupconfirm
# com.android.bluetooth
# com.android.camera2
# com.android.captiveportallogin
# com.android.certinstaller
# com.android.companiondevicemanager
# com.android.cts.ctsshim
# com.android.cts.priv.ctsshim
# com.android.dreams.basic
# com.android.dynsystem
# com.android.externalstorage
# com.android.hotspot2.osulogin
# com.android.htmlviewer
# com.android.inputdevices
# com.android.keychain
# com.android.localtransport
# com.android.location.fused
# com.android.messaging
# com.android.networkstack.inprocess
# com.android.networkstack.permissionconfig
# com.android.networkstack.tethering.inprocess
# com.android.pacprocessor
# com.android.printspooler
# com.android.providers.calendar
# com.android.providers.contacts
# com.android.providers.downloads
# com.android.providers.media
# com.android.providers.media.module
# com.android.providers.settings
# com.android.providers.tv
# com.android.providers.userdictionary
# com.android.proxyhandler
# com.android.se
# com.android.settings.intelligence
# com.android.sharedstoragebackup
# com.android.shell
# com.android.soundpicker
# com.android.statementservice
# com.android.systemui
# com.android.tethering.overlay
# com.android.tethering.overlay.gsi
# com.android.tv.settings
# com.android.tv.settings.google.resoverlay
# com.android.tv.settings.vendor.resoverlay
# com.android.vending
# com.android.vpndialogs
# com.android.wallpaperbackup
# com.android.wifi.resources
# com.google.android.apps.mediashell
# com.google.android.apps.nbu.smartconnect.tv
# com.google.android.apps.tv.dreamx
# com.google.android.apps.tv.launcherx
# com.google.android.ext.services
# com.google.android.ext.shared
# com.google.android.feedback
# com.google.android.gms
# com.google.android.gsf
# com.google.android.inputmethod.latin
# com.google.android.katniss
# com.google.android.marvin.talkback
# com.google.android.modulemetadata
# com.google.android.onetimeinitializer
# com.google.android.overlay.modules.ext.services
# com.google.android.overlay.modules.modulemetadata.forframework
# com.google.android.overlay.modules.permissioncontroller
# com.google.android.overlay.modules.permissioncontroller.forframework
# com.google.android.packageinstaller
# com.google.android.partnersetup
# com.google.android.permissioncontroller
# com.google.android.play.games
# com.google.android.sss.authbridge
# com.google.android.syncadapters.calendar
# com.google.android.tts
# com.google.android.tungsten.setupwraith
# com.google.android.tv.assistant
# com.google.android.tv.frameworkpackagestubs
# com.google.android.tv.remote.service
# com.google.android.videos
# com.google.android.webview
# com.google.android.youtube.tv
# com.google.android.youtube.tvmusic
# com.netflix.ninja
# com.tcl.accessibility
# com.tcl.android.webview
# com.tcl.assistant
# com.tcl.autopair
# com.tcl.bi
# com.tcl.browser
# com.tcl.cast.framework
# com.tcl.channelplus
# com.tcl.common.shortcutmenu
# com.tcl.dashboard
# com.tcl.esticker
# com.tcl.factory.view
# com.tcl.gallery
# com.tcl.gamebar
# com.tcl.guard
# com.tcl.hearaid
# com.tcl.initsetup
# com.tcl.inputmethod.international
# com.tcl.keyhelp
# com.tcl.logkit
# com.tcl.messagebox
# com.tcl.micmanager
# com.tcl.miracast
# com.tcl.MultiScreenInteraction_TV
# com.tcl.notereminder
# com.tcl.overseasappshow
# com.tcl.partnercustomizer
# com.tcl.providers.config
# com.tcl.settings
# com.tcl.smartalexa
# com.tcl.suspension
# com.tcl.system.server
# com.tcl.t_solo
# com.tcl.tcl_bt_rcu_service
# com.tcl.tv
# com.tcl.tv.tclhome_passive
# com.tcl.tvinput
# com.tcl.ui_mediaCenter
# com.tcl.useragreement
# com.tcl.usercenter
# com.tcl.versionUpdateApp
# com.tcl.waterfall.overseas
# com.tcl.xian.StartandroidService
# com.tvos
# org.chromium.webview_shell
# tv.wuaki.apptv
