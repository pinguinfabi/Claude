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
# merken, welche Bots gerade laufen (werden nach dem Update wieder gestartet)
RUNNING_BOTS=$(uctl list-units 'bot@*.service' --state=active --no-legend --plain 2>/dev/null | awk '{print $1}' || true)
# alte Bot-Prozesse (Dienste UND uebrig gebliebene bot-login-Laeufe) beenden
uctl stop 'bot@*.service' 2>/dev/null || true
pkill -u "$U" -f 'bot\.js [jb][0-9]' 2>/dev/null || true
sleep 2
pkill -9 -u "$U" -f 'bot\.js [jb][0-9]' 2>/dev/null || true
rm -f "$DIR"/state/*.lock 2>/dev/null || true
install -d -o "$U" -g "$U" "$DIR" "$DIR/env" "$DIR/state" "$DIR/profiles"
cat > "$DIR/bot.js" <<'EOF_BOT_JS'
'use strict'
// Aufruf:  node bot.js <id> [--login]      id = j1..jN (Java) oder b1..bN (Bedrock)
const id = process.argv[2] || process.env.BOT_ID
const type = /^j[1-9]\d*$/.test(id || '') ? 'java' : /^b[1-9]\d*$/.test(id || '') ? 'bedrock' : null
if (!type) {
  console.error('Aufruf: node bot.js <j1..jN | b1..bN> [--login]')
  process.exit(2)
}
require('./core').run({ id, type, adapter: require(type === 'java' ? './java' : './bedrock') })
EOF_BOT_JS
cat > "$DIR/core.js" <<'EOF_CORE_JS'
'use strict'
// Gemeinsamer Kern fuer alle Chat-Bots (Java "j*" und Bedrock "b*"):
//   * Status-Datei (fuer die VNC-Steuerung), Relog bei Kick/Abbruch/Funkstille, geplanter Relog
//   * Chat-Schnittstelle fuer den Windows-Controller (lokaler TCP-Port, JSON pro Zeile)
const fs = require('fs')
const path = require('path')
const net = require('net')
const { hint, watchAuthErrors } = require('./authhint')

const env = (k, d) => (process.env[k] !== undefined && process.env[k] !== '' ? process.env[k] : d)

function run ({ id, type, adapter }) {
  const loginMode = process.argv.includes('--login')
  const HOST = env('BOT_HOST', 'hugosmp.net')
  const PORT = parseInt(env('BOT_PORT', env(type === 'java' ? 'BOT_JAVA_PORT' : 'BOT_BEDROCK_PORT', type === 'java' ? '25565' : '19132')), 10)
  const VERSION = env('BOT_VERSION', env(type === 'java' ? 'BOT_JAVA_VERSION' : 'BOT_BEDROCK_VERSION', ''))
  const RELOG_MINUTES = parseFloat(env('RELOG_MINUTES', '0'))
  const ANTI_AFK = env('ANTI_AFK', 'none') // none | swing
  const OFFLINE = env('BOT_OFFLINE', '0') === '1' // nur fuer Tests
  const BASE_DIR = env('BOT_DIR', __dirname)
  const PROFILES = path.join(BASE_DIR, 'profiles', id)
  const STATE_DIR = env('BOT_STATE_DIR', path.join(BASE_DIR, 'state'))
  const defaultControl = (type === 'java' ? 6100 : 6200) + parseInt(id.slice(1), 10)
  const CONTROL_PORT = parseInt(env('BOT_CONTROL_PORT', String(defaultControl)), 10)
  const BACKOFF_BASE_MS = parseInt(env('BOT_BACKOFF_BASE_MS', '15000'), 10)
  const BACKOFF_MAX_MS = parseInt(env('BOT_BACKOFF_MAX_MS', '300000'), 10)
  const SILENCE_MS = parseInt(env('BOT_SILENCE_MS', '90000'), 10)
  const STABLE_MS = parseInt(env('BOT_STABLE_MS', '60000'), 10)
  const CONNECT_MS = parseInt(env('BOT_CONNECT_MS', '75000'), 10)
  const FALLBACK_MS = parseInt(env('BOT_FALLBACK_MS', '12000'), 10) // Verbindung steht, aber kein Spawn-Signal

  fs.mkdirSync(PROFILES, { recursive: true })
  fs.mkdirSync(STATE_DIR, { recursive: true })
  const log = (...a) => console.log(new Date().toISOString(), `[${id}]`, ...a)

  // Sperre: pro Bot darf nur EIN Prozess laufen (sonst zerstoeren sich zwei Anmeldungen gegenseitig)
  const lockFile = path.join(STATE_DIR, id + '.lock')
  try {
    const other = parseInt(fs.readFileSync(lockFile, 'utf8'), 10)
    if (other && other !== process.pid) {
      let alive = false
      try { process.kill(other, 0); alive = true } catch (e) { /* tot */ }
      if (alive) {
        console.error(`Bot ${id} laeuft schon (PID ${other}). Zuerst beenden:  kill ${other}`)
        process.exit(3)
      }
    }
  } catch (e) { /* keine Sperre vorhanden */ }
  fs.writeFileSync(lockFile, String(process.pid))
  const removeLock = () => { try { if (fs.readFileSync(lockFile, 'utf8') === String(process.pid)) fs.unlinkSync(lockFile) } catch (e) { /* egal */ } }
  process.on('exit', removeLock)

  // ---------- Statusdatei ----------
  let state = 'connecting'
  function writeState () {
    try {
      const f = path.join(STATE_DIR, id)
      fs.writeFileSync(f + '.tmp', state + '\n')
      fs.renameSync(f + '.tmp', f)
    } catch (e) { log('Statusdatei nicht schreibbar:', e.message) }
  }
  function setState (s) {
    state = s
    writeState()
    broadcast({ t: 'state', state })
  }
  const heartbeat = setInterval(writeState, 15000)

  // ---------- Chat-Schnittstelle ----------
  const history = []
  const clients = new Set()
  function send (sock, obj) { try { sock.write(JSON.stringify(obj) + '\n') } catch (e) { /* Verbindung weg */ } }
  function broadcast (obj) { for (const s of clients) send(s, obj) }
  function pushChat (entry, quiet = false) {
    entry.ts = Date.now()
    history.push(entry)
    if (history.length > 300) history.shift()
    broadcast({ t: 'chat', ...entry })
    if (!quiet) log(entry.kind === 'self' ? '>>' : '<<', entry.from ? `${entry.from}: ${entry.msg}` : entry.msg)
  }
  // Wichtige Ereignisse (Kick, Relog, Online ...) erscheinen auch im Chat-Fenster der App
  const note = m => { if (!loginMode) pushChat({ kind: 'system', from: '', msg: '⚙ ' + m }, true) }
  let lastSay = 0
  function handleLine (sock, line) {
    let m
    try { m = JSON.parse(line) } catch (e) { return }
    if (m.t !== 'say') return
    const text = typeof m.msg === 'string' ? m.msg.replace(/[\r\n]+/g, ' ').trim() : ''
    if (!text || text.length > 256) return send(sock, { t: 'error', msg: 'Nachricht leer oder laenger als 256 Zeichen.' })
    if (!client || dead || state !== 'online') return send(sock, { t: 'error', msg: 'Bot ist nicht im Spiel.' })
    if (Date.now() - lastSay < 800) return send(sock, { t: 'error', msg: 'Bitte kurz warten (Spam-Schutz).' })
    lastSay = Date.now()
    try {
      client.say(text)
      pushChat({ kind: 'self', from: 'Du', msg: text })
    } catch (e) {
      send(sock, { t: 'error', msg: 'Senden fehlgeschlagen: ' + e.message })
    }
  }
  if (!loginMode) {
    const srv = net.createServer(sock => {
      sock.setEncoding('utf8')
      clients.add(sock)
      send(sock, { t: 'hello', id, type, state })
      for (const h of history) send(sock, { t: 'chat', ...h, old: true })
      let buf = ''
      sock.on('data', d => {
        buf += d
        if (buf.length > 4096) buf = ''
        let i
        while ((i = buf.indexOf('\n')) >= 0) { handleLine(sock, buf.slice(0, i)); buf = buf.slice(i + 1) }
      })
      sock.on('close', () => clients.delete(sock))
      sock.on('error', () => clients.delete(sock))
    })
    srv.on('error', e => log('Chat-Port', CONTROL_PORT, 'nicht nutzbar:', e.message))
    srv.listen(CONTROL_PORT, '127.0.0.1')
  }

  // ---------- Verbindungsschleife ----------
  let client = null // { close(), say(text), keepalive?() }
  let dead = true
  let attempt = 0
  let onlineSince = 0
  let lastPacket = 0
  let connectStart = 0
  let reconnectTimer = null
  let relogTimer = null
  let afkTimer = null
  let stopping = false
  let loginDone = false
  let joinTimer = null
  let lastDiag = ''

  function connect () {
    clearTimeout(reconnectTimer)
    setState('connecting')
    dead = false
    lastPacket = connectStart = Date.now()
    lastDiag = ''
    log(`Verbinde mit ${HOST}:${PORT} (${type}) ...`)

    const mine = { conn: null }
    const guard = fn => (...a) => { if (mine.conn === client || mine.conn === null) fn(...a) }
    const ctx = {
      id, host: HOST, port: PORT, version: VERSION, offline: OFFLINE, profiles: PROFILES, log,
      onMsaCode,
      // Verbindungsdiagnose: wo haengt der Aufbau? (Journal immer, Chat nur in den ersten Versuchen)
      diag: m => { lastDiag = m; log('  .', m); if (attempt < 3) note(m) },
      authenticated: () => {
        if (!loginMode || loginDone) return
        loginDone = true
        log('Microsoft-Login erfolgreich und gespeichert. Beende in 3 s ...')
        setTimeout(() => shutdown(0), 3000)
      },
      packet: () => { lastPacket = Date.now() },
      join: () => {
        log('Login ok, Welt wird geladen ...')
        note('Login ok, Welt wird geladen ...')
        clearTimeout(joinTimer)
        joinTimer = setTimeout(() => {
          if (state !== 'online' && mine.conn && mine.conn === client && !dead) goOnline(mine, 'Verbindung steht (kein Spawn-Signal vom Server)')
        }, FALLBACK_MS)
      },
      spawn: guard(() => goOnline(mine, 'im Spiel gespawnt')),
      chat: e => { if (!loginMode) pushChat(e) },
      kick: text => {
        const t = String(text || '').replace(/\n/g, ' ')
        log('Vom Server getrennt:', t)
        note('Vom Server getrennt: ' + t)
      },
      closed: reason => drop(mine.conn, reason || 'Verbindung geschlossen')
    }
    try {
      mine.conn = adapter.connect(ctx)
    } catch (e) {
      log('Fehler beim Erstellen des Clients:', e.message)
      dead = true
      return scheduleReconnect('createClient')
    }
    client = mine.conn
  }

  function goOnline (mine, why) {
    if (state === 'online' || !mine.conn) return
    clearTimeout(joinTimer)
    onlineSince = Date.now()
    setState('online')
    log(`ONLINE – ${why}.`)
    note(`ONLINE – ${why}`)
    startKeepalive()
    if (loginMode) {
      log('Login erfolgreich gespeichert. Beende in 5 s ...')
      setTimeout(() => shutdown(0), 5000)
    } else if (RELOG_MINUTES > 0) {
      const ms = RELOG_MINUTES * 60000 * (0.9 + Math.random() * 0.2)
      relogTimer = setTimeout(() => drop(mine.conn, `geplanter Relog nach ${Math.round(ms / 60000)} min`, true), ms)
    }
  }

  function onMsaCode (data) {
    const url = data.verification_uri || 'https://www.microsoft.com/link'
    if (loginMode) {
      console.log('\n==================== MICROSOFT-LOGIN ====================')
      console.log(` 1. Auf deinem PC im Browser oeffnen: ${url}`)
      console.log(` 2. Diesen Code eingeben:  ${data.user_code}`)
      console.log(' 3. Mit dem Minecraft-Konto fuer diesen Bot anmelden.')
      console.log('==========================================================\n')
    } else {
      setState('login')
      log(`LOGIN NOETIG – bitte auf dem Server ausfuehren: bot-login ${id}`)
      shutdown(78) // 78 = kein Neustart durch systemd
    }
  }

  function startKeepalive () {
    clearInterval(afkTimer)
    if (ANTI_AFK !== 'swing' || !client || !client.keepalive) return
    const c = client
    afkTimer = setInterval(() => {
      try { if (client === c && state === 'online') c.keepalive() } catch (e) { log('Anti-AFK fehlgeschlagen:', e.message) }
    }, 25000 + Math.floor(Math.random() * 15000))
  }

  watchAuthErrors(text => {
    if (loginDone) return
    log('Microsoft/Xbox hat die Anmeldung abgelehnt:', text.split('\n')[0])
    log('HINWEIS:', hint(text))
    if (loginMode) return shutdown(1)
    setState('login')
    log(`Anmeldung ungueltig/abgelehnt – bitte auf dem Server ausfuehren: bot-login ${id}  (Diagnose: bot-auth-check ${id} --neu)`)
    shutdown(78)
  })

  const isAuthError = r => /invalid_grant|device_code|authorization code|XSTS|xbl|authenticat/i.test(String(r))
  let authWipes = 0

  function drop (c, reason, immediate = false) {
    if (!c || client !== c || dead) return
    dead = true
    log('Getrennt:', reason)
    note('Getrennt: ' + reason)
    clearTimeout(joinTimer)
    clearTimeout(relogTimer)
    clearInterval(afkTimer)
    try { c.close() } catch (e) { /* schon zu */ }
    client = null
    if (stopping) return
    if (isAuthError(reason) && !loginDone) {
      if (loginMode && authWipes < 2) {
        authWipes++
        log('Gespeicherte Anmeldedaten sind defekt – loesche sie und frage einen neuen Code an ...')
        try { fs.rmSync(PROFILES, { recursive: true, force: true }); fs.mkdirSync(PROFILES, { recursive: true }) } catch (e) { /* egal */ }
        return scheduleReconnect(reason, true)
      }
      if (!loginMode) {
        setState('login')
        log(`Anmeldung ungueltig/abgelaufen – bitte auf dem Server ausfuehren: bot-login ${id}`)
        return shutdown(78)
      }
    }
    if (onlineSince && Date.now() - onlineSince >= STABLE_MS) attempt = 0
    onlineSince = 0
    scheduleReconnect(reason, immediate)
  }

  function scheduleReconnect (reason, immediate = false) {
    setState('connecting')
    if (loginMode && !loginDone && attempt >= 3) { log('Login nicht moeglich (Server nicht erreichbar?).'); return shutdown(1) }
    const base = Math.min(BACKOFF_BASE_MS * 2 ** attempt, BACKOFF_MAX_MS)
    const delay = immediate ? 3000 : Math.round(base * (0.8 + Math.random() * 0.4))
    attempt++
    log(`Neuer Versuch in ${Math.round(delay / 1000)} s (Versuch ${attempt}).`)
    note(`Neuer Versuch in ${Math.round(delay / 1000)} s (Versuch ${attempt})`)
    reconnectTimer = setTimeout(connect, delay)
  }

  setInterval(() => {
    if (!client || dead) return
    if (state === 'connecting' && !loginMode && Date.now() - connectStart > CONNECT_MS) {
      drop(client, `Verbindungsaufbau dauert laenger als ${Math.round(CONNECT_MS / 1000)} s${lastDiag ? ` (zuletzt: ${lastDiag})` : ''}`)
    } else if (state === 'online' && Date.now() - lastPacket > SILENCE_MS) {
      drop(client, `keine Daten seit ${Math.round(SILENCE_MS / 1000)} s`)
    }
  }, 10000)

  function shutdown (code) {
    if (stopping) return
    stopping = true
    clearInterval(heartbeat)
    clearTimeout(reconnectTimer)
    clearTimeout(relogTimer)
    clearInterval(afkTimer)
    try { if (client) client.close('Bot beendet') } catch (e) { /* egal */ }
    setTimeout(() => process.exit(code), 500)
  }
  process.on('SIGTERM', () => shutdown(0))
  process.on('SIGINT', () => shutdown(0))
  process.on('SIGHUP', () => shutdown(0))
  process.on('uncaughtException', e => { log('Unerwarteter Fehler:', (e && e.stack) || e); if (client) drop(client, 'Ausnahme') })
  process.on('unhandledRejection', e => { log('Unbehandelte Ablehnung:', (e && e.message) || e); if (client) drop(client, 'Ablehnung') })

  connect()
}

module.exports = { run }
EOF_CORE_JS
cat > "$DIR/java.js" <<'EOF_JAVA_JS'
'use strict'
const mineflayer = require('mineflayer')
const { preset } = require('./authopts')

// Java-Adapter (mineflayer): stehen bleiben, Chat lesen und schreiben
exports.connect = function connect (ctx) {
  const opts = {
    host: ctx.host,
    port: ctx.port,
    username: ctx.id,
    auth: ctx.offline ? 'offline' : 'microsoft',
    profilesFolder: ctx.profiles,
    onMsaCode: ctx.onMsaCode,
    ...preset(),
    checkTimeoutInterval: 60000,
    hideErrors: true
  }
  if (ctx.version) opts.version = ctx.version
  const bot = mineflayer.createBot(opts)
  let ended = false

  // Diagnose: Zustandswechsel und erste Pakete jeder Art melden, damit man sieht, wo ein Aufbau haengt
  const seen = new Set()
  bot._client.on('connect', () => ctx.diag && ctx.diag('TCP-Verbindung steht'))
  bot._client.on('state', (n, o) => ctx.diag && ctx.diag(`Zustand ${o} -> ${n}`))
  bot._client.on('packet', (data, meta) => {
    const k = `${meta.state}:${meta.name}`
    if (!seen.has(k) && seen.size < 40 && ctx.diag) { seen.add(k); ctx.diag('Paket ' + k) }
  })
  bot.once('inject_allowed', () => ctx.diag && ctx.diag('Erkannte Version: ' + bot.version))

  bot._client.on('packet', () => ctx.packet())
  bot._client.on('session', () => ctx.authenticated && ctx.authenticated())
  bot._client.on('login', () => ctx.join())
  bot.once('spawn', () => ctx.spawn())
  bot.on('messagestr', (msg, position, json) => {
    if (!msg || !msg.trim()) return
    const m = /^<([^>]{1,32})> (.*)$/s.exec(msg)
    ctx.chat(m ? { kind: 'chat', from: m[1], msg: m[2] } : { kind: position === 'game_info' ? 'system' : 'chat', from: '', msg })
  })
  bot.on('kicked', reason => {
    let text = reason
    try { text = typeof reason === 'string' ? reason : JSON.stringify(reason) } catch (e) { /* roh lassen */ }
    ctx.kick(text)
  })
  bot.on('error', e => ctx.closed('Fehler: ' + (e && e.message ? e.message : e)))
  bot.on('end', reason => { ended = true; ctx.closed('Verbindung beendet' + (reason ? `: ${reason}` : '')) })

  return {
    close: () => { if (!ended) { try { bot.end('Bot beendet') } catch (e) { /* schon zu */ } } },
    say: text => bot.chat(text),
    keepalive: () => bot.swingArm('right')
  }
}
EOF_JAVA_JS
cat > "$DIR/auth-check.js" <<'EOF_AUTH_CHECK_JS'
'use strict'
// Diagnose: findet heraus, bei welchem Schritt die Microsoft-/Xbox-Anmeldung eines Kontos scheitert.
//   node auth-check.js <j1..j5|b1..b5>
const fs = require('fs')
const path = require('path')
const { Authflow } = require('prismarine-auth')
const { hint, watchAuthErrors } = require('./authhint')
const { preset } = require('./authopts')

const id = process.argv[2]
if (!/^[jb][1-9]\d*$/.test(id || '')) {
  console.error('Aufruf: node auth-check.js <j1..j5 | b1..b5>')
  process.exit(2)
}
const isJava = id[0] === 'j'
const dir = path.join(process.env.BOT_DIR || __dirname, 'profiles', id)
fs.mkdirSync(dir, { recursive: true })

const errors = []
const authName = process.env.BOT_AUTH || 'switch'
const flow = new Authflow(id, dir, preset(authName), data => {
  console.log('\n==================== MICROSOFT-LOGIN ====================')
  console.log(` 1. Im Browser oeffnen: ${data.verification_uri}`)
  console.log(` 2. Code eingeben:      ${data.user_code}`)
  console.log(' 3. Mit dem Konto anmelden, das zu diesem Bot gehoert.')
  console.log('==========================================================\n')
})

function spy (obj, name, label) {
  const orig = obj[name].bind(obj)
  obj[name] = async (...a) => {
    try {
      const r = await orig(...a)
      console.log(`  ok      ${label}`)
      return r
    } catch (e) {
      const msg = String(e && e.message || e).split('\n')[0]
      if (!errors.length) console.log(`  FEHLER  ${label}: ${msg}`)
      errors.push({ label, msg, full: String(e && e.message || e) })
      throw e
    }
  }
}
spy(flow.msa, 'authDeviceCode', 'Microsoft-Anmeldung')
spy(flow.xbl, 'getUserToken', 'Xbox-Benutzer-Token')
spy(flow.xbl, 'getDeviceToken', 'Xbox-Geraete-Token')
spy(flow.xbl, 'getXSTSToken', 'Xbox-Sicherheitstoken (XSTS)')
if (isJava) {
  spy(flow.mca, 'getAccessToken', 'Minecraft-Java-Token')
  spy(flow.mca, 'fetchProfile', 'Minecraft-Java-Profil')
}

watchAuthErrors(text => {
  console.log(`\nURSACHE (erster Fehler, Schritt "Microsoft-Anmeldung"):\n  ${text.split('\n').join('\n  ')}`)
  console.log(`\nHINWEIS: ${hint(text)}`)
  process.exit(1)
})

console.log(`Pruefe Konto fuer Bot ${id} (${isJava ? 'Java' : 'Bedrock'}), Anmeldeweg: ${authName} ...`)
;(async () => {
  try {
    if (isJava) {
      const r = await flow.getMinecraftJavaToken({ fetchProfile: true })
      if (!r.profile || r.profile.error) throw new Error('Kein Minecraft-Java-Profil – besitzt das Konto Minecraft Java? ' + JSON.stringify(r.profile || {}))
      console.log(`\nERFOLG: Anmeldung ok, Spielername: ${r.profile.name}`)
      if (authName !== 'switch') console.log(`Diesen Weg dauerhaft nutzen:  bot-login ${id} ${authName}`)
    } else {
      await flow.getXboxToken('https://multiplayer.minecraft.net/')
      console.log('\nERFOLG: Xbox-Anmeldung fuer Bedrock ist ok.')
    }
    process.exit(0)
  } catch (e) {
    const first = errors[0] || { label: 'unbekannt', full: String(e && e.message || e) }
    console.log(`\nURSACHE (erster Fehler, Schritt "${first.label}"):\n  ${first.full.split('\n').join('\n  ')}`)
    console.log(`\nHINWEIS: ${hint(first.full)}`)
    process.exit(1)
  }
})()
EOF_AUTH_CHECK_JS
cat > "$DIR/authhint.js" <<'EOF_AUTHHINT_JS'
'use strict'
// Erkennt Anmeldefehler von prismarine-auth (die Bibliothek schreibt sie nur per console.debug und
// fragt dann bis zu 15 Minuten weiter nach) und uebersetzt sie in einen verstaendlichen Hinweis.

function hint (text) {
  const t = String(text).toLowerCase()
  if (t.includes('user could not be authenticated') || t.includes('user interaction is required') || t.includes('grant the client application')) {
    return 'Microsoft hat die Anmeldung dieses Kontos abgelehnt. Haeufige Gruende: (1) Kinder-/Jugendkonto ohne Freigabe in der Microsoft-Familiengruppe, ' +
      '(2) das Konto verlangt eine Sicherheitspruefung (Telefon/E-Mail bestaetigen), (3) beim Anmelden wurde die Frage "Zugriff erlauben?" nicht mit JA bestaetigt, ' +
      '(4) es ist ein Arbeits-/Schulkonto statt eines privaten Microsoft-Kontos. Bitte in einem NEUEN Browserfenster (privat) auf https://account.microsoft.com mit diesem Konto ' +
      'anmelden, alle Aufforderungen erledigen, dann auf https://www.minecraft.net/login und https://www.xbox.com anmelden und danach "bot-auth-check <bot> --neu" wiederholen. Hilft das nicht: anderen Anmeldeweg testen: "bot-auth-check <bot> --neu --auth java" (oder android / ios).'
  }
  if (t.includes('authorization_declined') || t.includes('declined')) {
    return 'Die Anmeldung wurde im Browser abgelehnt/abgebrochen. Beim Anmelden JA/Zulassen waehlen.'
  }
  if (t.includes('expired_token') || t.includes('timed out') || t.includes('expired')) {
    return 'Der Code ist abgelaufen. Neu starten und den Code sofort im Browser eingeben.'
  }
  if (t.includes('2148916233') || t.includes('does not have an xbox')) {
    return 'Das Konto hat KEIN Xbox-Profil. Auf https://www.xbox.com anmelden und einen Gamertag anlegen, danach neu versuchen.'
  }
  if (t.includes('2148916238') || t.includes('under 18') || t.includes('child')) {
    return 'Kinder-Konto: Es muss in einer Microsoft-Familiengruppe von einem Erwachsenen freigegeben werden (account.microsoft.com/family).'
  }
  if (t.includes('2148916235') || t.includes('banned') || t.includes('country')) {
    return 'Xbox Live ist fuer die Region dieses Kontos gesperrt oder das Konto ist gesperrt.'
  }
  if (t.includes('2148916236') || t.includes('2148916237') || t.includes('adult')) {
    return 'Das Konto braucht eine Alters-/Erwachsenen-Verifizierung bei Xbox.'
  }
  if (t.includes('not found') || t.includes('own minecraft') || t.includes('profile')) {
    return 'Das Konto besitzt Minecraft: Java Edition nicht (oder hat noch keinen Profilnamen). Unter minecraft.net/profile pruefen.'
  }
  if (t.includes('device_code') && t.includes('already been used')) {
    return 'Der Geraete-Code wurde bereits verbraucht (Folgefehler eines vorherigen Fehlers).'
  }
  return 'Unbekannter Anmeldefehler – den Text oben bitte weitergeben.'
}

const AUTH_RE = /Failed to acquire authorization code|invalid_grant|Authentication failed|Xbox Live authentication failed/i

// Ruft onError genau EINMAL beim ersten Anmeldefehler auf, alles andere geht normal an console.debug.
function watchAuthErrors (onError) {
  const original = console.debug.bind(console)
  let fired = false
  console.debug = (...args) => {
    const text = args.map(a => (a && a.message) ? a.message : String(a)).join(' ')
    if (AUTH_RE.test(text)) {
      if (!fired) {
        fired = true
        try { onError(text) } catch (e) { /* egal */ }
      }
      return
    }
    original(...args)
  }
}

module.exports = { hint, watchAuthErrors }
EOF_AUTHHINT_JS
cat > "$DIR/authopts.js" <<'EOF_AUTHOPTS_JS'
'use strict'
// Anmeldewege: manche Konten lehnt Microsoft bei einem Weg ab und akzeptiert sie bei einem anderen
// (jeder Weg tritt gegenueber Microsoft als andere "App" auf). Auswahl per BOT_AUTH=<name>.
const { Titles } = require('prismarine-auth')

const PRESETS = {
  switch: { authTitle: Titles.MinecraftNintendoSwitch, deviceType: 'Nintendo', flow: 'live' }, // Standard
  java: { authTitle: Titles.MinecraftJava, deviceType: 'Win32', flow: 'sisu' },
  android: { authTitle: Titles.MinecraftAndroid, deviceType: 'Android', flow: 'live' },
  ios: { authTitle: Titles.MinecraftIOS, deviceType: 'iOS', flow: 'live' },
  xboxapp: { authTitle: Titles.XboxAppIOS, deviceType: 'iOS', flow: 'live' }
}

function preset (name) {
  const key = (name || process.env.BOT_AUTH || 'switch').toLowerCase()
  if (!PRESETS[key]) throw new Error(`Unbekannter Anmeldeweg "${key}" (moeglich: ${Object.keys(PRESETS).join(', ')})`)
  return { ...PRESETS[key] }
}

module.exports = { preset, PRESETS }
EOF_AUTHOPTS_JS
cat > "$DIR/bedrock.js" <<'EOF_BEDROCK_JS'
'use strict'
const bedrock = require('bedrock-protocol')
const { preset } = require('./authopts')

// Bedrock-Adapter (bedrock-protocol)
exports.connect = function connect (ctx) {
  const opts = {
    host: ctx.host,
    port: ctx.port,
    username: ctx.id,
    offline: ctx.offline,
    profilesFolder: ctx.profiles,
    raknetBackend: process.env.BOT_RAKNET || 'raknet-native',
    connectTimeout: 20000,
    onMsaCode: ctx.onMsaCode,
    ...preset()
  }
  if (ctx.version) opts.version = ctx.version
  const c = bedrock.createClient(opts)

  c.on('packet', () => ctx.packet())
  c.on('session', () => ctx.authenticated && ctx.authenticated())
  c.on('join', () => ctx.join())
  c.on('spawn', () => ctx.spawn())
  c.on('kick', p => ctx.kick(p && (p.message || p.reason)))
  c.on('error', e => ctx.closed('Fehler: ' + (e && e.message ? e.message : e)))
  c.on('close', () => ctx.closed('Verbindung geschlossen'))
  c.on('text', p => {
    try {
      let msg = String(p.message || '')
      if (Array.isArray(p.parameters) && p.parameters.length) msg = `${msg} ${p.parameters.join(' ')}`.trim()
      if (!msg) return
      ctx.chat({ kind: p.type === 'chat' ? 'chat' : 'system', from: p.type === 'chat' ? p.source_name : '', msg })
    } catch (e) { /* unbekanntes Textpaket */ }
  })

  return {
    close: () => { try { c.disconnect('Bot beendet') } catch (e) { c.close() } },
    say: text => {
      if (text.startsWith('/')) {
        c.queue('command_request', {
          command: text,
          origin: { type: 'player', uuid: '', request_id: '', player_entity_id: '' },
          internal: false,
          version: '1'
        })
      } else {
        c.queue('text', {
          type: 'chat',
          needs_translation: false,
          source_name: c.username || ctx.id,
          xuid: '',
          platform_chat_id: '',
          filtered_message: '',
          message: text
        })
      }
    },
    keepalive: () => c.queue('animate', { action_id: 'swing_arm', runtime_entity_id: c.entityId })
  }
}
EOF_BEDROCK_JS
cat > "$DIR/fix-prebuild.js" <<'EOF_FIX_PREBUILD_JS'
// raknet-native sucht seinen Vorab-Build nach der Kernel-Hauptversion (linux-5-x64),
// auf Ubuntu 24.04 (Kernel 6.x) existiert dieser Ordner aber nicht. Ordner kopieren.
const fs = require('fs')
const os = require('os')
const path = require('path')
const dir = path.join(__dirname, 'node_modules', 'raknet-native', 'prebuilds')
if (!fs.existsSync(dir)) process.exit(0)
const want = `${process.platform}-${os.release().split('.', 1)}-${process.arch}`
if (fs.existsSync(path.join(dir, want))) process.exit(0)
const have = fs.readdirSync(dir).find(d => d.startsWith(`${process.platform}-`) && d.endsWith(`-${process.arch}`))
if (have) {
  fs.cpSync(path.join(dir, have), path.join(dir, want), { recursive: true })
  console.log(`raknet-native: Prebuild ${have} -> ${want} kopiert`)
}
EOF_FIX_PREBUILD_JS
cat > "$DIR/package.json" <<'EOF_PACKAGE_JSON'
{
  "name": "chat-bots",
  "version": "1.0.0",
  "description": "Java- und Bedrock-Chat-Bots mit Auto-Relog",
  "main": "bot.js",
  "private": true,
  "scripts": {
    "postinstall": "node fix-prebuild.js"
  },
  "license": "UNLICENSED",
  "dependencies": {
    "bedrock-protocol": "3.59.0",
    "mineflayer": "4.39.0"
  }
}
EOF_PACKAGE_JSON
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
StartLimitIntervalSec=0

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
for svc in ${RUNNING_BOTS:-}; do uctl start "$svc" && echo "    Bot $svc wieder gestartet"; done
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
