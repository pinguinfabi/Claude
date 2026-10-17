#!/usr/bin/env bash
# Richtet 5 Bedrock-AFK-Bots (b1..b5) fuer hugosmp.net ein und erweitert die VNC-Steuerung.
# Als root ausfuehren, NACH umbau-afk.sh.  Mehrfach ausfuehrbar.
set -Eeuo pipefail

[[ $EUID -eq 0 ]] || { echo "Bitte als root starten." >&2; exit 1; }

U=autosell
H=/home/$U
UID_N=$(id -u "$U")
DIR=$H/bedrock-bots
BOTS="b1 b2 b3 b4 b5"
JAVA="afk2 afk3 afk4 afk5 afk6 afk7"
declare -A PORT=([afk2]=5902 [afk3]=5903 [afk4]=5904 [afk5]=5905 [afk6]=5906 [afk7]=5907)
BK=/root/backup-bedrock-$(date +%F-%H%M)

uctl() {
  runuser -u "$U" -- env XDG_RUNTIME_DIR="/run/user/$UID_N" \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID_N/bus" systemctl --user "$@"
}
atomic_write() { # Zieldatei Modus (Inhalt von stdin)
  local tmp; tmp=$(mktemp "$1.XXXX"); cat > "$tmp"; chmod "$2" "$tmp"; mv -f "$tmp" "$1"
}

[[ -x /usr/local/sbin/minecraft-vnc-control-root ]] || { echo "Zuerst umbau-afk.sh ausfuehren." >&2; exit 1; }

# ---------- 1. Backup der VNC-Steuerung ----------
echo ">>> 1/6 Backup der Steuerungsdateien nach $BK"
mkdir -p "$BK"; chmod 700 "$BK"
tar czf "$BK/steuerung.tgz" /etc/sudoers.d/minecraft-vnc-control /usr/local/sbin/minecraft-vnc-control-root \
  /usr/local/bin/minecraft-vnc-guest-command 2>/dev/null || true

# ---------- 2. Node.js (offizielles Release, Pruefsumme wird kontrolliert) ----------
if ! /usr/local/bin/node -v 2>/dev/null | grep -q '^v2[2-9]'; then
  echo ">>> 2/6 Node.js 22 installieren"
  apt-get install -y curl ca-certificates xz-utils >/dev/null
  BASE=https://nodejs.org/dist/latest-v22.x
  FILE=$(curl -fsSL "$BASE/SHASUMS256.txt" | awk '/linux-x64\.tar\.xz$/ {print $2}')
  [[ -n $FILE ]] || { echo "Node-Download nicht gefunden" >&2; exit 1; }
  TMP=$(mktemp -d)
  curl -fsSL "$BASE/$FILE" -o "$TMP/$FILE"
  (cd "$TMP" && curl -fsSL "$BASE/SHASUMS256.txt" | grep " $FILE\$" | sha256sum -c -)
  rm -rf /opt/node22 && mkdir -p /opt/node22 && tar -xJf "$TMP/$FILE" -C /opt/node22 --strip-components=1
  ln -sf /opt/node22/bin/node /usr/local/bin/node
  ln -sf /opt/node22/bin/npm /usr/local/bin/npm
  ln -sf /opt/node22/bin/npx /usr/local/bin/npx
  rm -rf "$TMP"
else
  echo ">>> 2/6 Node.js vorhanden: $(/usr/local/bin/node -v)"
fi

# ---------- 3. Bot-Programm ----------
echo ">>> 3/6 Bot installieren nach $DIR"
install -d -o "$U" -g "$U" "$DIR" "$DIR/env" "$DIR/state" "$DIR/profiles"
cat > "$DIR/bot.js" <<'BOT_JS_EOF'
@@BOT_JS@@
BOT_JS_EOF
cat > "$DIR/fix-prebuild.js" <<'FIX_JS_EOF'
@@FIX_JS@@
FIX_JS_EOF
cat > "$DIR/package.json" <<'PKG_JSON_EOF'
@@PKG_JSON@@
PKG_JSON_EOF
[[ -f $DIR/common.env ]] || cat > "$DIR/common.env" <<'ENV_EOF'
# Gemeinsame Einstellungen aller Bedrock-Bots
BOT_HOST=hugosmp.net
BOT_PORT=19132
# Geplanter Relog alle X Minuten (0 = nur bei Kick/Abbruch neu einloggen)
RELOG_MINUTES=0
# Anti-AFK: none oder swing (Arm schwingen alle 25-40 s)
ANTI_AFK=none
ENV_EOF
chown -R "$U:$U" "$DIR"
runuser -l "$U" -c "cd $DIR && npm install --ignore-scripts --no-audit --no-fund --omit=dev && node fix-prebuild.js"
runuser -l "$U" -c "cd $DIR && node --check bot.js" && echo "    Bot-Code ok"

# ---------- 4. systemd-Dienste ----------
echo ">>> 4/6 Dienste einrichten"
install -d -o "$U" -g "$U" "$H/.config/systemd/user"
atomic_write "$H/.config/systemd/user/bedrock-bot@.service" 644 <<'UNIT_EOF'
[Unit]
Description=Bedrock AFK-Bot %i
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
chown "$U:$U" "$H/.config/systemd/user/bedrock-bot@.service"
uctl daemon-reload

atomic_write /usr/local/bin/bedrock-login 755 <<'LOGIN_EOF'
#!/usr/bin/env bash
# Einmaliger Microsoft-Login fuer einen Bedrock-Bot:  bedrock-login b1
set -Eeuo pipefail
ID="${1:-}"
[[ $ID =~ ^b[1-9][0-9]*$ ]] || { echo "Aufruf: bedrock-login b1   (b1 bis b5)" >&2; exit 2; }
[[ $EUID -eq 0 ]] || { echo "Bitte als root starten." >&2; exit 1; }
U=autosell
UID_N=$(id -u "$U")
uctl() { runuser -u "$U" -- env XDG_RUNTIME_DIR="/run/user/$UID_N" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID_N/bus" systemctl --user "$@"; }
uctl stop "bedrock-bot@$ID.service" 2>/dev/null || true
runuser -l "$U" -c "set -a; . ~/bedrock-bots/common.env; [ -f ~/bedrock-bots/env/$ID.env ] && . ~/bedrock-bots/env/$ID.env; set +a; cd ~/bedrock-bots && node bot.js $ID --login"
uctl enable --now "bedrock-bot@$ID.service"
echo "Bot $ID laeuft jetzt (Autostart aktiv)."
LOGIN_EOF

# ---------- 5. VNC-Steuerung um die Bots erweitern ----------
echo ">>> 5/6 VNC-Steuerung erweitern"
CASE_ROOT=""; SUDO=""; GUEST=""; TARGETS="$JAVA $BOTS"
for t in $JAVA; do
  CASE_ROOT+="    $t) SERVICE=\"minecraft-$t.service\"; PORT=\"${PORT[$t]}\"; KIND=\"java\" ;;"$'\n'
done
for t in $BOTS; do
  CASE_ROOT+="    $t) SERVICE=\"bedrock-bot@$t.service\"; PORT=\"\"; KIND=\"bedrock\" ;;"$'\n'
done
for t in $TARGETS; do
  for a in restart repair; do
    SUDO+="vncguest ALL=(root) NOPASSWD: /usr/local/sbin/minecraft-vnc-control-root $a $t"$'\n'
    GUEST+="  \"vnc-control $a $t\")"$'\n'"    exec sudo -n /usr/local/sbin/minecraft-vnc-control-root $a $t"$'\n'"    ;;"$'\n'
  done
done

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

# Zustand eines Bedrock-Bots aus seiner Statusdatei: up / login / down
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
    if [[ "$KIND" == "bedrock" ]]; then
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
  if [[ "$KIND" != "bedrock" ]]; then
    user_systemctl restart "$BRIDGE"
  fi
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
  if [[ "$KIND" != "bedrock" ]]; then
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

# ---------- 6. Pruefen ----------
echo ">>> 6/6 Test"
bash -n /usr/local/sbin/minecraft-vnc-control-root
/usr/local/sbin/minecraft-vnc-control-root status
echo
echo "===== FERTIG ====="
echo "Jetzt fuer jeden Bot einmal den Xbox-Login machen (Code im Browser eingeben):"
for t in $BOTS; do echo "   bedrock-login $t"; done
echo
echo "Einstellungen (Server/Port/Relog/Anti-AFK):  $DIR/common.env   (pro Bot: $DIR/env/bN.env)"
echo "Log eines Bots:  runuser -u $U -- env XDG_RUNTIME_DIR=/run/user/$UID_N journalctl --user -u bedrock-bot@b1 -n 50 --no-pager"
