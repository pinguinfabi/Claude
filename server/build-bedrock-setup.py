#!/usr/bin/env python3
"""Baut server/bedrock-setup.sh aus Vorlage + bedrock-bot/{bot.js,fix-prebuild.js,package.json}."""
import json, pathlib
here = pathlib.Path(__file__).parent
tpl = (here / 'bedrock-setup.template.sh').read_text()
bot = here / 'bedrock-bot'
pkg = json.loads((bot / 'package.json').read_text())
pkg = {k: pkg[k] for k in ('name', 'version', 'description', 'main', 'private', 'scripts', 'license')} | \
      {'dependencies': {'bedrock-protocol': pkg['dependencies']['bedrock-protocol'].lstrip('^~')}}
parts = {'@@BOT_JS@@': (bot / 'bot.js').read_text(), '@@FIX_JS@@': (bot / 'fix-prebuild.js').read_text(),
         '@@PKG_JSON@@': json.dumps(pkg, indent=2) + '\n'}
for k, v in parts.items():
    for marker in ('BOT_JS_EOF', 'FIX_JS_EOF', 'PKG_JSON_EOF'):
        assert marker not in v
    tpl = tpl.replace(k, v.rstrip('\n'))
out = here / 'bedrock-setup.sh'
out.write_text(tpl)
out.chmod(0o755)
print('geschrieben:', out, len(tpl), 'Bytes')
