#!/usr/bin/env bash
# Update-Paket (als root, EINMAL ausfuehren, nach umbau-afk.sh):
#   Prism-Clients : afk1 (= bisheriger afk3, bleibt unveraendert, Port 5901)
#                   afk2 (= NEU, leer, Port 5902)
#                   alte afk2/afk4/afk5/afk6/afk7 werden entfernt (Konten -> /root/konten-umzug.txt)
#   Java-Chat-Bots: j1..j5     Bedrock-Chat-Bots: b1..b5     (alle hugosmp.net)
#   VNC-Steuerung : neue Ziele + Chat-Ports fuer den Windows-Controller
set -Eeuo pipefail

[[ $EUID -eq 0 ]] || { echo "Bitte als root starten." >&2; exit 1; }

U=autosell
H=/home/$U
UID_N=$(id -u "$U")
DIR=$H/bedrock-bots
STAMP=$(date +%F-%H%M)
BK=/root/backup-update-$STAMP
SHARED=$H/shared
BOTS_J="j1 j2 j3 j4 j5"
BOTS_B="b1 b2 b3 b4 b5"
PRISM="afk1 afk2"
declare -A DISP=([afk1]=:99 [afk2]=:98)
declare -A PORT=([afk1]=5901 [afk2]=5902)
MARK=$H/.update-prism-done

uctl() {
  runuser -u "$U" -- env XDG_RUNTIME_DIR="/run/user/$UID_N" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID_N/bus" systemctl --user "$@"
}
atomic_write() { local tmp; tmp=$(mktemp "$1.XXXX"); cat > "$tmp"; chmod "$2" "$tmp"; mv -f "$tmp" "$1"; }
setkv() { if grep -q "^$2=" "$1"; then sed -i "s|^$2=.*|$2=$3|" "$1"; else echo "$2=$3" >> "$1"; fi; }
account_names() { # accounts.json -> Spielernamen
  python3 - "$1" <<'PY' 2>/dev/null || true
import json, sys
try:
    for a in json.load(open(sys.argv[1])).get("accounts", []):
        n = (a.get("profile") or {}).get("name")
        if n:
            print(n)
except Exception:
    pass
PY
}

[[ -x /usr/local/sbin/minecraft-vnc-control-root ]] || { echo "Zuerst umbau-afk.sh ausfuehren." >&2; exit 1; }

if [[ -f $MARK ]]; then
  echo "Prism-Umbau war schon (Marker $MARK) - ueberspringe die Instanz-Umstellung."
  SKIP_PRISM=1
else
  SKIP_PRISM=0
  [[ -d $H/afk-client-3/prism-data && -d $H/afk-client-2/prism-data ]] || { echo "afk-client-2/3 nicht gefunden." >&2; exit 1; }
  echo "Plan:"
  echo "  * afk-client-3 wird zu afk-client-1 (Konto bleibt, Port 5901)"
  echo "  * afk-client-2 wird als NEUE leere Instanz aufgebaut (Konto wird entfernt, Port 5902)"
  echo "  * afk-client-4, -5, -6, -7 werden geloescht (Backup unter $BK)"
  echo "  * 5 Java-Bots (j1-j5) + 5 Bedrock-Bots (b1-b5) fuer hugosmp.net werden eingerichtet"
  echo "  Die bisherigen Konten von afk2/afk4/afk5 merkst du dir fuer die Bots (Liste: /root/konten-umzug.txt)."
  read -r -p "Zum Fortfahren JA tippen: " ans
  [[ $ans == JA ]] || { echo "Abgebrochen."; exit 1; }
fi
apt-get install -y rsync curl ca-certificates xz-utils python3 >/dev/null

# ---------- 1. Backup + Konten-Liste ----------
echo ">>> 1/8 Backup nach $BK"
mkdir -p "$BK"; chmod 700 "$BK"
if [[ $SKIP_PRISM == 0 ]]; then
  {
    echo "Konten der bisherigen Clients (Stand $STAMP) - diese Konten mit  bot-login j1 / j2 / ...  als Chat-Bot neu anmelden:"
    echo "  (afk3 bleibt unveraendert und heisst jetzt afk1)"
    for n in 2 4 5 6 7; do
      f=$H/afk-client-$n/prism-data/accounts.json
      [[ -f $f ]] && echo "  alter afk$n: $(account_names "$f" | paste -sd, -)"
    done
  } > /root/konten-umzug.txt
  chmod 600 /root/konten-umzug.txt
  (cd "$H" && tar czf "$BK/prism.tgz" --exclude='*/prism-data/java' --exclude='*/prism-data/assets' \
    --exclude='*/prism-data/libraries' --exclude='*.log' afk-client-* .config/systemd/user .local/lib/minecraft-vnc-control)
fi
tar czf "$BK/steuerung.tgz" /etc/sudoers.d/minecraft-vnc-control /usr/local/sbin/minecraft-vnc-control-root \
  /usr/local/bin/minecraft-vnc-guest-command /etc/ssh/sshd_config.d/90-minecraft-vnc-guest.conf 2>/dev/null || true
chmod 600 "$BK"/*

# ---------- 2. Prism-Umbau ----------
if [[ $SKIP_PRISM == 0 ]]; then
  echo ">>> 2/8 Alte Prism-Dienste stoppen"
  for n in 2 3 4 5 6 7; do
    uctl disable --now "minecraft-afk$n.service" "minecraft-vnc-bridge@afk$n.service" 2>/dev/null || true
  done
  pkill -u "$U" -f "$H/afk-client-[2-7]/" 2>/dev/null || true
  sleep 3

  echo ">>> 3/8 afk3 -> afk1, neue leere afk2, Rest loeschen"
  # eigenes Java fuer afk1 sicherstellen (zeigte bisher evtl. auf afk-client-2)
  if [[ ! -d $H/afk-client-3/prism-data/java ]]; then cp -a "$H/afk-client-2/prism-data/java" "$H/afk-client-3/prism-data/java"; fi
  # neue, leere afk2 vorbereiten (Original bleibt bis zum Tausch unberuehrt)
  rm -rf "$H/afk-client-2.new"
  rsync -a --exclude=accounts.json --exclude='*.log' --exclude='logs/' --exclude='crash-reports/' \
    "$H/afk-client-2/" "$H/afk-client-2.new/"
  e=$(ls "$H"/afk-client-2.new/*.env | head -1); p=$(grep -m1 -oE '^AFK[0-9]_' "$e")
  setkv "$e" "${p}DISPLAY" "${DISP[afk2]}"
  setkv "$e" "${p}VNC_PORT" "${PORT[afk2]}"
  setkv "$e" "${p}PRISM_PATH" "$SHARED/prismlauncher"

  mv "$H/afk-client-3" "$H/afk-client-1"
  find "$H/afk-client-1/prism-data" -maxdepth 3 -name '*.cfg' -exec sed -i \
    "s|$H/afk-client-3|$H/afk-client-1|g; s|$H/afk-client-2/prism-data/java|$H/afk-client-1/prism-data/java|g" {} +
  sed -i 's|afk-client-3|afk-client-1|g' "$H"/afk-client-1/bin/*.sh
  e=$(ls "$H"/afk-client-1/*.env | head -1); p=$(grep -m1 -oE '^AFK[0-9]_' "$e")
  setkv "$e" "${p}DISPLAY" "${DISP[afk1]}"
  setkv "$e" "${p}VNC_PORT" "${PORT[afk1]}"
  setkv "$e" "${p}PRISM_PATH" "$SHARED/prismlauncher"
  sed "s|afk-client-3|afk-client-1|g; s|^Description=.*|Description=Minecraft Prism-Client afk1|" \
    "$H/.config/systemd/user/minecraft-afk3.service" > "$H/.config/systemd/user/minecraft-afk1.service"

  rm -rf "$H/afk-client-2" "$H/afk-client-4" "$H/afk-client-5" "$H/afk-client-6" "$H/afk-client-7"
  mv "$H/afk-client-2.new" "$H/afk-client-2"
  for n in 3 4 5 6 7; do rm -f "$H/.config/systemd/user/minecraft-afk$n.service"; done
  chown -R "$U:$U" "$H/afk-client-1" "$H/afk-client-2" "$H/.config/systemd/user"
  touch "$MARK"
fi

# ---------- 3. Node.js ----------
if ! /usr/local/bin/node -v 2>/dev/null | grep -q '^v2[2-9]'; then
  echo ">>> 4/8 Node.js 22 installieren"
  BASE=https://nodejs.org/dist/latest-v22.x
  FILE=$(curl -fsSL "$BASE/SHASUMS256.txt" | awk '/linux-x64\.tar\.xz$/ {print $2}')
  [[ -n $FILE ]] || { echo "Node-Download nicht gefunden" >&2; exit 1; }
  TMP=$(mktemp -d)
  curl -fsSL "$BASE/$FILE" -o "$TMP/$FILE"
  (cd "$TMP" && curl -fsSL "$BASE/SHASUMS256.txt" | grep " $FILE\$" | sha256sum -c -)
  rm -rf /opt/node22 && mkdir -p /opt/node22 && tar -xJf "$TMP/$FILE" -C /opt/node22 --strip-components=1
  ln -sf /opt/node22/bin/node /usr/local/bin/node; ln -sf /opt/node22/bin/npm /usr/local/bin/npm; ln -sf /opt/node22/bin/npx /usr/local/bin/npx
  rm -rf "$TMP"
else
  echo ">>> 4/8 Node.js vorhanden: $(/usr/local/bin/node -v)"
fi

# ---------- 4. Bot-Programm ----------
echo ">>> 5/8 Bots installieren nach $DIR"
# alte Bot-Prozesse (Dienste UND uebrig gebliebene bot-login-Laeufe) beenden
uctl stop 'bot@*.service' 2>/dev/null || true
pkill -u "$U" -f 'bot\.js [jb][0-9]' 2>/dev/null || true
sleep 2
pkill -9 -u "$U" -f 'bot\.js [jb][0-9]' 2>/dev/null || true
rm -f "$DIR"/state/*.lock 2>/dev/null || true
install -d -o "$U" -g "$U" "$DIR" "$DIR/env" "$DIR/state" "$DIR/profiles"
@@FILES@@
[[ -f $DIR/common.env ]] || cat > "$DIR/common.env" <<'ENV_EOF'
# Gemeinsame Einstellungen aller Chat-Bots (pro Bot ueberschreibbar in env/<id>.env, z. B. env/j1.env)
BOT_HOST=hugosmp.net
BOT_JAVA_PORT=25565
BOT_BEDROCK_PORT=19132
# Geplanter Relog alle X Minuten (0 = nur bei Kick/Abbruch neu einloggen)
RELOG_MINUTES=0
# Anti-AFK: none oder swing (Arm schwingen alle 25-40 s)
ANTI_AFK=none
ENV_EOF
chown -R "$U:$U" "$DIR"
runuser -l "$U" -c "cd $DIR && npm install --ignore-scripts --no-audit --no-fund --omit=dev && node fix-prebuild.js"
runuser -l "$U" -c "cd $DIR && node --check bot.js core.js java.js bedrock.js" && echo "    Bot-Code ok"

# ---------- 5. systemd ----------
echo ">>> 6/8 Dienste einrichten"
atomic_write "$H/.config/systemd/user/bot@.service" 644 <<'UNIT_EOF'
[Unit]
Description=Chat-Bot %i
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=%h/bedrock-bots
EnvironmentFile=%h/bedrock-bots/common.env
EnvironmentFile=-%h/bedrock-bots/env/%i.env
ExecStart=/usr/local/bin/node %h/bedrock-bots/bot.js %i
Restart=always
RestartSec=10
# Exit 78 = Microsoft-Login fehlt: nicht in Endlosschleife neu starten
RestartPreventExitStatus=78
StartLimitIntervalSec=0
TimeoutStopSec=15

[Install]
WantedBy=default.target
UNIT_EOF
chown "$U:$U" "$H/.config/systemd/user/bot@.service"

atomic_write /usr/local/bin/bot-login 755 <<'LOGIN_EOF'
#!/usr/bin/env bash
# Einmaliger Microsoft-Login fuer einen Chat-Bot:  bot-login j1 [Anmeldeweg]
#   j1-j5 = Java, b1-b5 = Bedrock.  Anmeldeweg (optional, wird fuer diesen Bot gespeichert):
#   switch (Standard) | java | android | ios | xboxapp     - hilft bei Konten, die Microsoft sonst ablehnt
set -Eeuo pipefail
ID="${1:-}"
AUTH="${2:-}"
[[ $ID =~ ^[jb][1-9][0-9]*$ ]] || { echo "Aufruf: bot-login j1 [switch|java|android|ios|xboxapp]" >&2; exit 2; }
[[ -z $AUTH || $AUTH =~ ^(switch|java|android|ios|xboxapp)$ ]] || { echo "Unbekannter Anmeldeweg: $AUTH" >&2; exit 2; }
[[ $EUID -eq 0 ]] || { echo "Bitte als root starten." >&2; exit 1; }
U=autosell
UID_N=$(id -u "$U")
ENVF="/home/$U/bedrock-bots/env/$ID.env"
uctl() { runuser -u "$U" -- env XDG_RUNTIME_DIR="/run/user/$UID_N" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID_N/bus" systemctl --user "$@"; }
uctl stop "bot@$ID.service" 2>/dev/null || true
# uebrig gebliebene Prozesse dieses Bots (z. B. von einem frueheren Strg+C) beenden
pkill -u "$U" -f "bot\.js $ID( |\$)" 2>/dev/null || true
sleep 1
if [[ -n $AUTH ]]; then
  touch "$ENVF"; sed -i '/^BOT_AUTH=/d' "$ENVF"; echo "BOT_AUTH=$AUTH" >> "$ENVF"; chown "$U:$U" "$ENVF"
  echo "Anmeldeweg fuer $ID: $AUTH"
fi
# --session-command: Strg+C erreicht den Bot; exec: kein Zwischenprozess
runuser -l "$U" --session-command "set -a; . ~/bedrock-bots/common.env; [ -f ~/bedrock-bots/env/$ID.env ] && . ~/bedrock-bots/env/$ID.env; set +a; cd ~/bedrock-bots && exec node bot.js $ID --login"
uctl enable --now "bot@$ID.service"
echo "Bot $ID laeuft jetzt (Autostart aktiv)."
LOGIN_EOF

atomic_write /usr/local/bin/bot-auth-check 755 <<'CHECK_EOF'
#!/usr/bin/env bash
# Zeigt, bei welchem Schritt die Anmeldung eines Kontos scheitert:
#   bot-auth-check j2 [--neu] [--auth switch|java|android|ios|xboxapp]
set -Eeuo pipefail
ID="${1:-}"; shift || true
[[ $ID =~ ^[jb][1-9][0-9]*$ ]] || { echo "Aufruf: bot-auth-check j2 [--neu] [--auth java|android|ios|xboxapp]" >&2; exit 2; }
NEW=0; AUTH=""
while [[ $# -gt 0 ]]; do
  case "$1" in --neu) NEW=1 ;; --auth) AUTH="${2:-}"; shift ;; *) echo "Unbekannte Option: $1" >&2; exit 2 ;; esac
  shift
done
[[ -z $AUTH || $AUTH =~ ^(switch|java|android|ios|xboxapp)$ ]] || { echo "Unbekannter Anmeldeweg: $AUTH" >&2; exit 2; }
[[ $EUID -eq 0 ]] || { echo "Bitte als root starten." >&2; exit 1; }
U=autosell
UID_N=$(id -u "$U")
runuser -u "$U" -- env XDG_RUNTIME_DIR="/run/user/$UID_N" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID_N/bus" systemctl --user stop "bot@$ID.service" 2>/dev/null || true
pkill -u "$U" -f "bot\.js $ID( |\$)" 2>/dev/null || true
if [[ $NEW == 1 ]]; then rm -rf "/home/$U/bedrock-bots/profiles/$ID"; fi
runuser -l "$U" --session-command "cd ~/bedrock-bots && BOT_AUTH='${AUTH:-switch}' exec node auth-check.js $ID"
CHECK_EOF

# ---------- 6. VNC-Steuerung ----------
echo ">>> 7/8 VNC-Steuerung aktualisieren"
CASE_ATTACH=""; CASE_ROOT=""; SUDO=""; GUEST=""; OPEN=""; TARGETS="$PRISM $BOTS_J $BOTS_B"
for t in $PRISM; do
  CASE_ATTACH+="  $t) DISPLAY_VALUE=\"${DISP[$t]}\"; VNC_PORT=\"${PORT[$t]}\" ;;"$'\n'
  CASE_ROOT+="    $t) SERVICE=\"minecraft-$t.service\"; PORT=\"${PORT[$t]}\"; KIND=\"prism\" ;;"$'\n'
  OPEN+=" 127.0.0.1:${PORT[$t]}"
done
for t in $BOTS_J $BOTS_B; do
  CASE_ROOT+="    $t) SERVICE=\"bot@$t.service\"; PORT=\"\"; KIND=\"bot\" ;;"$'\n'
  [[ $t == j* ]] && OPEN+=" 127.0.0.1:$((6100 + ${t#j}))" || OPEN+=" 127.0.0.1:$((6200 + ${t#b}))"
done
for t in $TARGETS; do
  for a in restart repair; do
    SUDO+="vncguest ALL=(root) NOPASSWD: /usr/local/sbin/minecraft-vnc-control-root $a $t"$'\n'
    GUEST+="  \"vnc-control $a $t\")"$'\n'"    exec sudo -n /usr/local/sbin/minecraft-vnc-control-root $a $t"$'\n'"    ;;"$'\n'
  done
done

read -r -d '' TPL_ATTACH <<'ATTACH_EOF' || true
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
ATTACH_EOF
printf '%s\n' "${TPL_ATTACH/@@CASE@@/$CASE_ATTACH}" | atomic_write "$H/.local/lib/minecraft-vnc-control/attach-vnc.sh" 755
chown "$U:$U" "$H/.local/lib/minecraft-vnc-control/attach-vnc.sh"

read -r -d '' TPL_ROOT <<'ROOT_EOF' || true
#!/usr/bin/env bash
set -Eeuo pipefail

MINECRAFT_USER="autosell"
MINECRAFT_UID="$(id -u "$MINECRAFT_USER")"
STATE_DIR="/home/$MINECRAFT_USER/bedrock-bots/state"

user_systemctl() {
  runuser -u "$MINECRAFT_USER" -- env \
    XDG_RUNTIME_DIR="/run/user/$MINECRAFT_UID" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$MINECRAFT_UID/bus" \
    systemctl --user "$@"
}

target_values() {
  KIND=""
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

# Zustand eines Chat-Bots aus seiner Statusdatei: up / login / down
bot_state() {
  local file="$STATE_DIR/$1" content age
  [[ -f "$file" ]] || { echo "down"; return; }
  content="$(head -c 20 "$file" | tr -d '\n')"
  age=$(( $(date +%s) - $(stat -c %Y "$file") ))
  if [[ "$content" == "login" ]]; then
    echo "login"
  elif [[ "$content" == "online" && "$age" -lt 60 ]]; then
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
    if [[ "$KIND" == "bot" ]]; then
      printf '%s|%s|%s\n' "$target" "$(service_state "$SERVICE")" "$(bot_state "$target")"
    else
      printf '%s|%s|%s\n' "$target" "$(service_state "$SERVICE")" "$(port_state "$PORT")"
    fi
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
  if [[ "$KIND" != "bot" ]]; then
    user_systemctl restart "$BRIDGE"
    echo "$target wurde neu gestartet. VNC kann während des Minecraft-Starts kurz nicht erreichbar sein."
  else
    echo "$target wurde neu gestartet (Relog)."
  fi
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
  if [[ "$KIND" != "bot" ]]; then
    user_systemctl restart "$BRIDGE"
  fi
  echo "$target wird repariert."
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
ROOT_EOF
TPL_ROOT=${TPL_ROOT/@@CASE@@/$CASE_ROOT}
printf '%s\n' "${TPL_ROOT/@@TARGETS@@/$TARGETS}" | atomic_write /usr/local/sbin/minecraft-vnc-control-root 755

{ echo "vncguest ALL=(root) NOPASSWD: /usr/local/sbin/minecraft-vnc-control-root status"; printf '%s' "$SUDO"; } \
  | atomic_write /etc/sudoers.d/minecraft-vnc-control 440
if ! visudo -cf /etc/sudoers.d/minecraft-vnc-control >/dev/null; then
  echo "sudoers ungueltig - stelle Backup wieder her" >&2
  tar xzf "$BK/steuerung.tgz" -C /; exit 1
fi

{
  printf '%s\n' '#!/usr/bin/env bash' 'set -Eeuo pipefail' '' 'case "${SSH_ORIGINAL_COMMAND:-}" in' \
    '  "vnc-control status")' '    exec sudo -n /usr/local/sbin/minecraft-vnc-control-root status' '    ;;'
  printf '%s' "$GUEST"
  printf '%s\n' '  *)' '    echo "Dieser Zugang erlaubt keine Shell. Bitte Minecraft VNC Control verwenden." >&2' \
    '    exit 1' '    ;;' 'esac'
} | atomic_write /usr/local/bin/minecraft-vnc-guest-command 755

DROPIN=/etc/ssh/sshd_config.d/90-minecraft-vnc-guest.conf
cp -a "$DROPIN" "$BK/sshd-dropin.bak"
sed -E "s|^( *PermitOpen).*|\1${OPEN}|" "$BK/sshd-dropin.bak" | atomic_write "$DROPIN" 644
if ! sshd -t; then
  echo "sshd-Konfiguration ungueltig - Backup wird zurueckgespielt" >&2
  cp -a "$BK/sshd-dropin.bak" "$DROPIN"; exit 1
fi
systemctl reload ssh 2>/dev/null || systemctl reload sshd

# ---------- 7. Starten ----------
echo ">>> 8/8 Dienste aktivieren"
loginctl enable-linger "$U"
uctl daemon-reload
uctl enable --now minecraft-afk1.service                       # laeuft mit dem bisherigen afk3-Konto weiter
uctl enable minecraft-afk2.service                             # neu: erst nach dem Konto-Login starten
for t in $PRISM; do uctl enable --now "minecraft-vnc-bridge@$t.service"; done
if [[ -z $(swapon --show --noheadings) ]]; then
  fallocate -l 8G /swapfile && chmod 600 /swapfile && mkswap /swapfile >/dev/null && swapon /swapfile
  grep -q '^/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

bash -n /usr/local/sbin/minecraft-vnc-control-root
echo; echo "===== FERTIG ====="
/usr/local/sbin/minecraft-vnc-control-root status
echo
[[ -f /root/konten-umzug.txt ]] && cat /root/konten-umzug.txt
cat <<MSG

Naechste Schritte
-----------------
1) Chat-Bots anmelden (je Bot einmal, Code im Browser eingeben):
     bot-login j1   bot-login j2 ...   (Java, j1 bis j5)   - jedes Konto in jedem Platz moeglich
     Klappt ein Konto nicht:  bot-auth-check j2 --neu   (zeigt die genaue Ursache)
       dann anderen Anmeldeweg testen:  bot-auth-check j2 --neu --auth java   und bei Erfolg:  bot-login j2 java
     bot-login b1   bot-login b2 ...   (Bedrock, b1 bis b5)
2) Neuer Prism-Platz afk2: Konto in Prism hinzufuegen
     sudo -iu autosell /home/autosell/afk-client-2/bin/setup-gui.sh   (VNC Port 5902), danach in der App 'Neu starten'
Einstellungen (Server/Port/Relog/Anti-AFK):  $DIR/common.env   (pro Bot: $DIR/env/<id>.env)
Backup:  $BK
MSG
