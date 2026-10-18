'use strict'
// Aufruf:  node bot.js <id> [--login]      id = j1..jN (Java) oder b1..bN (Bedrock)
const id = process.argv[2] || process.env.BOT_ID
const type = /^j[1-9]\d*$/.test(id || '') ? 'java' : /^b[1-9]\d*$/.test(id || '') ? 'bedrock' : null
if (!type) {
  console.error('Aufruf: node bot.js <j1..jN | b1..bN> [--login]')
  process.exit(2)
}
require('./core').run({ id, type, adapter: require(type === 'java' ? './java' : './bedrock') })
