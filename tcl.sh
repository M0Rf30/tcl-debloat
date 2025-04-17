#!/bin/bash
set -e

# -----------------------------------------------------------------------------
# Configuration variables
# -----------------------------------------------------------------------------
TEMP_DIR=tmp-tcl-debloater
FLAUNCHER_URL="https://github.com/CocoCR300/flauncher/releases/download/v2024.12.004/flauncher-armeabi-v7a-release.apk"
KODI_URL="https://mirrors.kodi.tv/releases/android/arm/kodi-21.2-Omega-armeabi-v7a.apk"
SMARTTUBE_URL="https://github.com/yuliskov/SmartTube/releases/download/27.03s/SmartTube_stable_27.03_armeabi-v7a.apk"

# List of packages to process
BLOAT=(
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
  com.google.android.tungsten.setupwraith
  com.google.android.tv.remote.service
  com.google.android.videos
  com.google.android.youtube.tv
  com.google.android.youtube.tvmusic
  com.netflix.ninja
  com.tcl.accessibility
  com.tcl.android.webview
  org.chromium.webview_shell
  tv.wuaki.apptv
)

BLOAT_EX=(
  com.tcl.MultiScreenInteraction_TV
  com.tcl.assistant
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
  com.tcl.notereminder
  com.tcl.ocean.instructions
  com.tcl.overseasappshow
  com.tcl.smartalexa
  com.tcl.t_solo
  com.tcl.tcl_bt_rcu_service # although the name, seems not related to rc auto-pair
  com.tcl.tv.tclhome_passive
  com.tcl.ui_mediaCenter
  com.tcl.useragreement
  com.tcl.usercenter
  com.tcl.versionUpdateApp
  com.tcl.waterfall.overseas
  com.tcl.xian.StartandroidService
)

# -----------------------------------------------------------------------------
# Defaults & Usage
# -----------------------------------------------------------------------------
ACTION="list" # default action

usage() {
  echo "Usage: $0 [--enable | --disable | --extras | --list]"
  echo "   --enable    Enable all the packages (restores them)"
  echo "   --disable   Disable the packages (default behavior)"
  echo "   --extras    Enable extra packages"
  echo "   --list      List all the packages"
}

# -----------------------------------------------------------------------------
# Parse Arguments
# -----------------------------------------------------------------------------
if [ "$#" -gt 1 ]; then
  usage
fi

if [ "$#" -eq 1 ]; then
  case "$1" in
    --enable)
      ACTION="enable"
      ;;
    --disable)
      ACTION="disable"
      ;;
    --extras)
      ACTION="extras"
      ;;
    --list)
      ACTION="list"
      ;;
    *)
      usage
      ;;
  esac
fi

# -----------------------------------------------------------------------------
# Main script functionality
# -----------------------------------------------------------------------------
echo -n "TCL IP: "
read TCL_IP

if ! adb connect "$TCL_IP" | grep -q "connected"; then
  echo "Unable to connect to TCL TV"
  exit 1
fi

# Download and install Kodi and SmartTube Next extras.
if [ "$ACTION" = "extras" ]; then
  mkdir -p "$TEMP_DIR"

  echo "Downloading Kodi"
  wget "$KODI_URL" -O "$TEMP_DIR/kodi.apk"
  echo "Installing Kodi"
  adb install "$TEMP_DIR/kodi.apk"

  echo "Downloading SmartTube Next"
  wget "$SMARTTUBE_URL" -O "$TEMP_DIR/stn.apk"
  echo "Installing SmartTube Next"
  adb install "$TEMP_DIR/stn.apk"

  rm -r "$TEMP_DIR"
fi

if [ "$ACTION" = "list" ]; then
  echo "Listing all packages"
  adb shell pm list packages
fi

# Loop through packages and either disable or enable them
process_packages() {
  local action_command="$1"
  shift
  local package_list=("$@")
  for package in "${package_list[@]}"; do
    echo "${action_command^}ing ${package}"
    # suppress failure error output with "| true" in case the package is already in the desired state
    adb shell pm "$action_command" "$package" || true
  done
}

if [ "$ACTION" = "disable" ]; then
  process_packages disable-user "${BLOAT[@]}"
  process_packages disable-user "${BLOAT_EX[@]}"
elif [ "$ACTION" = "enable" ]; then
  process_packages enable "${BLOAT[@]}"
  process_packages enable "${BLOAT_EX[@]}"
fi

echo "Done."

# Not sure or needed
# com.android.providers.downloads
# com.android.providers.media
# com.android.providers.media.module
# com.tcl.autopair # seems that this disable bt rc pairing
# com.tcl.inputmethod.international
# com.tcl.miracast # disabling this, no screen sharing
# com.tcl.partnercustomizer # disabling this, kill rc tv button
