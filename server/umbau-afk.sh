#!/usr/bin/env bash
# HINWEIS: nur EINMAL ausfuehren. Die Bedrock-Bots danach mit bedrock-setup.sh einrichten (erweitert diese Steuerung).
# Umbau der AFK-Clients (als root ausfuehren):
#   BLEIBT : afk2 (Crafter), afk3
#   WEG    : autosell, autosell2, altes afk4
#   NEU    : afk4, afk5, afk6, afk7 (Klone von afk2, ohne Account)
set -Eeuo pipefail

[[ $EUID -eq 0 ]] || { echo "Bitte als root starten." >&2; exit 1; }

U=autosell
H=/home/$U
UID_N=$(id -u "$U")
BK=/root/backup-umbau-$(date +%F-%H%M)
SHARED=$H/shared
SRC=$H/afk-client-2

KEEP="afk2 afk3"
NEW="afk4 afk5 afk6 afk7"
ALL="$KEEP $NEW"
declare -A DISP=([afk2]=:98 [afk3]=:97 [afk4]=:96 [afk5]=:95 [afk6]=:94 [afk7]=:93)
declare -A PORT=([afk2]=5902 [afk3]=5903 [afk4]=5904 [afk5]=5905 [afk6]=5906 [afk7]=5907)
dir_of() { echo "$H/afk-client-${1#afk}"; }

uctl() {
  runuser -u "$U" -- env XDG_RUNTIME_DIR="/run/user/$UID_N" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID_N/bus" systemctl --user "$@"
}
setkv() { # Datei KEY WERT
  if grep -q "^$2=" "$1"; then sed -i "s|^$2=.*|$2=$3|" "$1"; else echo "$2=$3" >> "$1"; fi
}
atomic_write() { # Zieldatei Modus  (Inhalt von stdin) - neue Inode, damit laufende Skripte nicht kaputtgehen
  local tmp; tmp=$(mktemp "$1.XXXX"); cat > "$tmp"; chmod "$2" "$tmp"; mv -f "$tmp" "$1"
}

# ---------- Vorpruefung ----------
[[ -d $SRC/prism-data && -f $SRC/afk2.env ]] || { echo "afk-client-2 nicht gefunden." >&2; exit 1; }
[[ -d $H/afk-client-3/prism-data ]] || { echo "afk-client-3 nicht gefunden." >&2; exit 1; }
echo "Bleibt: afk2 (Crafter), afk3"
echo "Wird GELOESCHT: autosell-afk, autosell-afk-2, afk-client-4 (Backup unter $BK)"
echo "Neu: afk4 afk5 afk6 afk7 als Klone von afk2 (ohne Account)"
read -r -p "Zum Fortfahren JA tippen: " ans
[[ $ans == JA ]] || { echo "Abgebrochen."; exit 1; }

apt-get install -y rsync >/dev/null

# ---------- 1. Backup ----------
echo ">>> 1/8 Backup"
mkdir -p "$BK"; chmod 700 "$BK"
tar czf "$BK/behalten.tgz" -C "$H" \
  --exclude='*/prism-data/java' --exclude='*/prism-data/assets' --exclude='*/prism-data/libraries' --exclude='*.log' \
  afk-client-2 afk-client-3 .config/systemd/user .local/lib/minecraft-vnc-control
tar czf "$BK/geloescht.tgz" -C "$H" \
  --exclude='*/prism-data/java' --exclude='*/prism-data/assets' --exclude='*/prism-data/libraries' \
  --exclude='*/releases' --exclude='*.log' \
  autosell-afk autosell-afk-2 afk-client-4
tar czf "$BK/system.tgz" /etc/sudoers.d/minecraft-vnc-control /etc/ssh/sshd_config.d/90-minecraft-vnc-guest.conf \
  /usr/local/sbin/minecraft-vnc-control-root /usr/local/bin/minecraft-vnc-guest-command 2>/dev/null || true
chmod 600 "$BK"/*

# ---------- 2. Alte Dienste weg ----------
echo ">>> 2/8 Alte Dienste stoppen"
for s in autosell-afk.service autosell2-afk.service minecraft-afk4.service \
         minecraft-vnc-bridge@autosell.service minecraft-vnc-bridge@autosell2.service minecraft-vnc-bridge@afk4.service; do
  uctl disable --now "$s" 2>/dev/null || true
done
rm -f "$H/.config/systemd/user/"{autosell-afk,autosell2-afk,minecraft-afk4}.service
pkill -u "$U" -f "$H/(autosell-afk|autosell-afk-2|afk-client-4)/" 2>/dev/null || true
sleep 3

# ---------- 3. Launcher an gemeinsamen Ort ----------
echo ">>> 3/8 Prism-Launcher nach $SHARED"
mkdir -p "$SHARED"
if [[ -d $H/autosell-afk/releases && ! -e $SHARED/releases ]]; then mv "$H/autosell-afk/releases" "$SHARED/releases"; fi
APPRUN=$(ls -d "$SHARED"/releases/prism-*/squashfs-root/AppRun | tail -1)
ln -sfn "$APPRUN" "$SHARED/prismlauncher"
chown -R "$U:$U" "$SHARED"
[[ -x $SHARED/prismlauncher ]] || { echo "Launcher nicht ausfuehrbar - Abbruch VOR dem Loeschen." >&2; exit 1; }
for t in $KEEP; do
  d=$(dir_of "$t"); e=$(ls "$d"/*.env | head -1); p=$(grep -m1 -oE '^AFK[0-9]_' "$e")
  setkv "$e" "${p}PRISM_PATH" "$SHARED/prismlauncher"
  sed -i 's|autosell-afk/prismlauncher|shared/prismlauncher|g' "$d"/bin/*.sh
done

# ---------- 4. Loeschen ----------
echo ">>> 4/8 Alte Instanzen loeschen"
rm -rf "$H/autosell-afk" "$H/autosell-afk-2" "$H/afk-client-4"

# ---------- 5. Klone von afk2 ----------
echo ">>> 5/8 Neue Instanzen aus Vorlage afk2"
for t in $NEW; do
  d=$(dir_of "$t"); n=${t#afk}
  if [[ -e $d ]]; then echo "  $t existiert schon, ueberspringe"; continue; fi
  rsync -a --exclude=accounts.json --exclude='*.log' --exclude='logs/' --exclude='crash-reports/' "$SRC/" "$d/"
  find "$d/prism-data" -maxdepth 3 -name '*.cfg' -exec sed -i "s|$SRC|$d|g" {} +
  sed -i "s|afk-client-2|afk-client-$n|g" "$d"/bin/*.sh
  setkv "$d/afk2.env" AFK2_DISPLAY "${DISP[$t]}"
  setkv "$d/afk2.env" AFK2_VNC_PORT "${PORT[$t]}"
  setkv "$d/afk2.env" AFK2_PRISM_PATH "$SHARED/prismlauncher"
  chown -R "$U:$U" "$d"; chmod 600 "$d/afk2.env"
  unit=$H/.config/systemd/user/minecraft-$t.service
  sed "s|afk-client-2|afk-client-$n|g; s|^Description=.*|Description=Minecraft AFK-Client $t|" \
    "$H/.config/systemd/user/minecraft-afk2.service" > "$unit"
  chown "$U:$U" "$unit"
done

# ---------- 6. VNC-Steuerung (Gegenstelle der Windows-App) ----------
echo ">>> 6/8 VNC-Steuerung aktualisieren"
CASE_ATTACH=""; CASE_ROOT=""; SUDO=""; GUEST=""; OPEN=""
for t in $ALL; do
  CASE_ATTACH+="  $t) DISPLAY_VALUE=\"${DISP[$t]}\"; VNC_PORT=\"${PORT[$t]}\" ;;"$'\n'
  CASE_ROOT+="    $t) SERVICE=\"minecraft-$t.service\"; PORT=\"${PORT[$t]}\" ;;"$'\n'
  for a in restart repair; do
    SUDO+="vncguest ALL=(root) NOPASSWD: /usr/local/sbin/minecraft-vnc-control-root $a $t"$'\n'
    GUEST+="  \"vnc-control $a $t\")"$'\n'"    exec sudo -n /usr/local/sbin/minecraft-vnc-control-root $a $t"$'\n'"    ;;"$'\n'
  done
  OPEN+=" 127.0.0.1:${PORT[$t]}"
done

read -r -d '' TPL_ATTACH <<'EOF' || true
#!/usr/bin/env bash
set -Eeuo pipefail

TARGET="${1:-}"
CURRENT_USER="$(id -un)"
case "$TARGET" in
@@CASE@@  *) echo "Unbekanntes Ziel: $TARGET" >&2; exit 2 ;;
esac

port_is_open() {
  ss -H -ltn | awk '{print $4}' | grep -Eq "(^|:)${VNC_PORT}$"
}

find_xvfb_pid() {
  pgrep -a -u "$CURRENT_USER" Xvfb | awk -v display="$DISPLAY_VALUE" \
    '$0 ~ ("Xvfb " display "([[:space:]]|$)") { print $1; exit }'
}

while true; do
  if port_is_open; then
    sleep 5
    continue
  fi

  XVFB_PID="$(find_xvfb_pid || true)"
  if [[ -z "$XVFB_PID" || ! -r "/proc/$XVFB_PID/cmdline" ]]; then
    sleep 3
    continue
  fi

  XAUTH_FILE="$(tr '\0' '\n' < "/proc/$XVFB_PID/cmdline" | \
    awk 'previous == "-auth" { print; exit } { previous=$0 }')"

  echo "Verbinde VNC-Ziel $TARGET mit Display $DISPLAY_VALUE auf localhost:$VNC_PORT"
  if [[ -n "$XAUTH_FILE" && -r "$XAUTH_FILE" ]]; then
    exec x11vnc -display "$DISPLAY_VALUE" -auth "$XAUTH_FILE" \
      -localhost -forever -shared -nopw -rfbport "$VNC_PORT"
  fi

  exec x11vnc -display "$DISPLAY_VALUE" -auth guess \
    -localhost -forever -shared -nopw -rfbport "$VNC_PORT"
done
EOF
printf '%s\n' "${TPL_ATTACH/@@CASE@@/$CASE_ATTACH}" | atomic_write "$H/.local/lib/minecraft-vnc-control/attach-vnc.sh" 755
chown "$U:$U" "$H/.local/lib/minecraft-vnc-control/attach-vnc.sh"

read -r -d '' TPL_ROOT <<'EOF' || true
#!/usr/bin/env bash
set -Eeuo pipefail

MINECRAFT_USER="autosell"
MINECRAFT_UID="$(id -u "$MINECRAFT_USER")"

user_systemctl() {
  runuser -u "$MINECRAFT_USER" -- env \
    XDG_RUNTIME_DIR="/run/user/$MINECRAFT_UID" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$MINECRAFT_UID/bus" \
    systemctl --user "$@"
}

target_values() {
  case "$1" in
@@CASE@@    *) echo "Unbekanntes Ziel." >&2; exit 2 ;;
  esac
  BRIDGE="minecraft-vnc-bridge@$1.service"
}

port_state() {
  if ss -H -ltn | awk '{print $4}' | grep -Eq "(^|:)${1}$"; then
    echo "up"
  else
    echo "down"
  fi
}

service_state() {
  local service="$1"
  local load_state
  load_state="$(user_systemctl show "$service" -p LoadState --value 2>/dev/null || true)"
  if [[ "$load_state" != "loaded" ]]; then
    echo "missing"
    return
  fi
  user_systemctl is-active "$service" 2>/dev/null || true
}

status_all() {
  local target
  for target in @@TARGETS@@; do
    target_values "$target"
    printf '%s|%s|%s\n' "$target" "$(service_state "$SERVICE")" "$(port_state "$PORT")"
  done
}

restart_target() {
  local target="$1"
  target_values "$target"
  if [[ "$(service_state "$SERVICE")" == "missing" ]]; then
    echo "Der Dienst $SERVICE ist nicht eingerichtet." >&2
    exit 3
  fi
  user_systemctl restart "$SERVICE"
  user_systemctl restart "$BRIDGE"
  echo "$target wurde neu gestartet. VNC kann während des Minecraft-Starts kurz nicht erreichbar sein."
}

repair_target() {
  local target="$1"
  target_values "$target"
  local state
  state="$(service_state "$SERVICE")"
  if [[ "$state" == "missing" ]]; then
    echo "Der Dienst $SERVICE ist nicht eingerichtet." >&2
    exit 3
  fi
  if [[ "$state" != "active" ]]; then
    user_systemctl restart "$SERVICE"
  fi
  user_systemctl restart "$BRIDGE"
  echo "$target-VNC wird repariert."
}

case "${1:-}" in
  status)
    [[ $# -eq 1 ]] || exit 2
    status_all
    ;;
  restart)
    [[ $# -eq 2 ]] || exit 2
    restart_target "$2"
    ;;
  repair)
    [[ $# -eq 2 ]] || exit 2
    repair_target "$2"
    ;;
  *)
    echo "Erlaubt: status, restart TARGET, repair TARGET" >&2
    exit 2
    ;;
esac
EOF
TPL_ROOT=${TPL_ROOT/@@CASE@@/$CASE_ROOT}
printf '%s\n' "${TPL_ROOT/@@TARGETS@@/$ALL}" | atomic_write /usr/local/sbin/minecraft-vnc-control-root 755

{ echo "vncguest ALL=(root) NOPASSWD: /usr/local/sbin/minecraft-vnc-control-root status"; printf '%s' "$SUDO"; } \
  | atomic_write /etc/sudoers.d/minecraft-vnc-control 440
visudo -cf /etc/sudoers.d/minecraft-vnc-control >/dev/null || {
  echo "sudoers ungueltig - stelle Backup wieder her" >&2
  tar xzf "$BK/system.tgz" -C / etc/sudoers.d/minecraft-vnc-control; exit 1; }

{
  printf '%s\n' '#!/usr/bin/env bash' 'set -Eeuo pipefail' '' 'case "${SSH_ORIGINAL_COMMAND:-}" in' \
    '  "vnc-control status")' '    exec sudo -n /usr/local/sbin/minecraft-vnc-control-root status' '    ;;'
  printf '%s' "$GUEST"
  printf '%s\n' '  *)' '    echo "Dieser Zugang erlaubt keine Shell. Bitte Minecraft VNC Control verwenden." >&2' \
    '    exit 1' '    ;;' 'esac'
} | atomic_write /usr/local/bin/minecraft-vnc-guest-command 755

DROPIN=/etc/ssh/sshd_config.d/90-minecraft-vnc-guest.conf
cp -a "$DROPIN" "$BK/sshd-dropin.bak" 2>/dev/null || true
sed -E "s|^( *PermitOpen).*|\1${OPEN}|" "$BK/sshd-dropin.bak" | atomic_write "$DROPIN" 644
if ! sshd -t; then
  echo "sshd-Konfiguration ungueltig - Backup wird zurueckgespielt" >&2
  cp -a "$BK/sshd-dropin.bak" "$DROPIN"; exit 1
fi
systemctl reload ssh 2>/dev/null || systemctl reload sshd

# ---------- 7. Dienste ----------
echo ">>> 7/8 Dienste aktivieren (Autostart)"
loginctl enable-linger "$U"
uctl daemon-reload
for t in $KEEP; do uctl enable --now "minecraft-$t.service"; done     # afk3 war vorher NICHT fuer den Autostart aktiviert
for t in $NEW;  do uctl enable "minecraft-$t.service"; done           # starten erst nach dem Account-Login
for t in $ALL;  do uctl enable --now "minecraft-vnc-bridge@$t.service"; done

# ---------- 8. Swap als Puffer ----------
echo ">>> 8/8 Swap"
if [[ -z $(swapon --show --noheadings) ]]; then
  fallocate -l 8G /swapfile && chmod 600 /swapfile && mkswap /swapfile >/dev/null && swapon /swapfile
  grep -q '^/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

echo; echo "===== FERTIG ====="
/usr/local/sbin/minecraft-vnc-control-root status
echo; free -h | head -2
echo
echo "Backup: $BK"
echo "SSH-Fingerabdruck (unveraendert):"; ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub -E sha256
cat <<MSG

Account-Login der neuen Instanzen (je Instanz einmal, afk4 bis afk7):
  1. sudo -iu autosell /home/autosell/afk-client-4/bin/setup-gui.sh      (Nummer anpassen)
  2. Per VNC auf Port 5904 verbinden, in Prism 'Konten > Microsoft-Konto hinzufuegen', dann Prism schliessen / Strg+C
  3. runuser -u autosell -- env XDG_RUNTIME_DIR=/run/user/$UID_N systemctl --user start minecraft-afk4.service
MSG
