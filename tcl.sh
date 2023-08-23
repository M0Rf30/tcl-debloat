#!/usr/bin/sh
set -e
TEMP_DIR=tmp-tcl-debloater
KODI_URL=https://mirrors.kodi.tv/releases/android/arm/kodi-20.2-Nexus-armeabi-v7a.apk
FLAUNCHER_URL=https://gitlab.com/flauncher/flauncher/-/releases/0.18.0/downloads/flauncher-0.18.0.apk
# MATERIALFILES_URL=https://f-droid.org/repo/me.zhanghai.android.files_31.apk
BLOAT=$(cat <<EOF
au.com.stan.and
com.amazon.amazonvideo.livingroom
com.android.printspooler
com.android.vending
com.google.android.feedback
com.google.android.katniss
com.google.android.marvin.talkback
com.google.android.onetimeinitializer
com.google.android.partnersetup
com.google.android.tv.assistant
com.google.android.youtube.tv
com.google.android.youtube.tvmusic
com.netflix.ninja
com.tcl.android.webview
com.tcl.assistant
com.tcl.autopair
com.tcl.bi
com.tcl.browser
com.tcl.channelplus
com.tcl.dashboard
com.tcl.esticker
com.tcl.gallery
com.tcl.guard
com.tcl.inputmethod.international
com.tcl.keyhelp
com.tcl.messagebox
com.tcl.micmanager
com.tcl.miracast
com.tcl.MultiScreenInteraction_TV
com.tcl.notereminder
com.tcl.overseasappshow
com.tcl.partnercustomizer
com.tcl.smartalexa
com.tcl.t_solo
com.tcl.tcl_bt_rcu_service
com.tcl.tv.tclhome_passive
com.tcl.ui_mediaCenter
com.tcl.useragreement
com.tcl.usercenter
com.tcl.versionUpdateApp
com.tcl.waterfall.overseas
com.tcl.xian.StartandroidService
org.chromium.webview_shell
tv.wuaki.apptv
EOF
)

read -p "TCL IP: " TCL_IP
adb connect $TCL_IP | grep -q fail && echo "Unable to connect to TCL TV" && false

mkdir -p $TEMP_DIR

# echo "Downloading Kodi"
# wget $KODI_URL -O $TEMP_DIR/kodi.apk
# echo "Installing Kodi"
# adb install $TEMP_DIR/kodi.apk

# echo "Downloading FLauncher" 
# wget $FLAUNCHER_URL -O $TEMP_DIR/flauncher.apk
# echo "Installing FLaucher"
# adb install $TEMP_DIR/flauncher.apk

# echo "Downloading Material Files"
# wget $MATERIALFILES_URL -O $TEMP_DIR/materialfiles.apk
# echo "Installing Material Files"
# adb install $TEMP_DIR/materialfiles.apk
# echo "Grating permission for Material Files"
# adb shell pm grant me.zhanghai.android.files android.permission.READ_EXTERNAL_STORAGE
# adb shell pm grant me.zhanghai.android.files android.permission.WRITE_EXTERNAL_STORAGE

rm -r $TEMP_DIR

for package in $BLOAT
do
	echo "Disabling ${package}"
	adb shell pm uninstall --user 0 $package | true
done

# echo "Rebooting TV"
# adb reboot

# Debloat - unsecure elements
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
# com.android.vpndialogs
# com.android.wallpaperbackup
# com.android.wifi.resources
# com.google.android.apps.mediashell
# com.google.android.apps.nbu.smartconnect.tv
# com.google.android.apps.tv.dreamx
# com.google.android.apps.tv.launcherx
# com.google.android.ext.services
# com.google.android.ext.shared
# com.google.android.gms
# com.google.android.gsf
# com.google.android.inputmethod.latin
# com.google.android.modulemetadata
# com.google.android.overlay.modules.ext.services
# com.google.android.overlay.modules.modulemetadata.forframework
# com.google.android.overlay.modules.permissioncontroller
# com.google.android.overlay.modules.permissioncontroller.forframework
# com.google.android.packageinstaller
# com.google.android.permissioncontroller
# com.google.android.play.games
# com.google.android.sss.authbridge
# com.google.android.syncadapters.calendar
# com.google.android.tts
# com.google.android.tungsten.setupwraith
# com.google.android.tv.frameworkpackagestubs
# com.google.android.tv.remote.service
# com.google.android.videos
# com.google.android.webview
# com.tcl.accessibility
# com.tcl.cast.framework
# com.tcl.common.shortcutmenu
# com.tcl.factory.view
# com.tcl.gamebar
# com.tcl.hearaid
# com.tcl.initsetup
# com.tcl.logkit
# com.tcl.providers.config
# com.tcl.settings
# com.tcl.suspension
# com.tcl.system.server
# com.tcl.tv
# com.tcl.tvinput
# com.tvos
