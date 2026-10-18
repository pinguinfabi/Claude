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
