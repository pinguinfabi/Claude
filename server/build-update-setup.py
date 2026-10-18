#!/usr/bin/env python3
"""Baut server/update-setup.sh aus der Vorlage und den Dateien in server/bots/."""
import json, pathlib
here = pathlib.Path(__file__).parent
tpl = (here / 'update-setup.template.sh').read_text()
bots = here / 'bots'
pkg = json.loads((bots / 'package.json').read_text())
deps = {k: v.lstrip('^~') for k, v in pkg['dependencies'].items()}
pkg = {'name': pkg['name'], 'version': pkg['version'], 'description': pkg['description'], 'main': 'bot.js',
       'private': True, 'scripts': {'postinstall': 'node fix-prebuild.js'}, 'license': pkg.get('license', 'UNLICENSED'),
       'dependencies': deps}
files = {'bot.js': (bots / 'bot.js').read_text(), 'core.js': (bots / 'core.js').read_text(),
         'java.js': (bots / 'java.js').read_text(), 'auth-check.js': (bots / 'auth-check.js').read_text(), 'bedrock.js': (bots / 'bedrock.js').read_text(),
         'fix-prebuild.js': (bots / 'fix-prebuild.js').read_text(), 'package.json': json.dumps(pkg, indent=2) + '\n'}
blocks = []
for name, text in files.items():
    marker = 'EOF_' + name.replace('.', '_').replace('-', '_').upper()
    assert marker not in text
    blocks.append(f'cat > "$DIR/{name}" <<\'{marker}\'\n{text.rstrip(chr(10))}\n{marker}')
out = here / 'update-setup.sh'
out.write_text(tpl.replace('@@FILES@@', '\n'.join(blocks)))
out.chmod(0o755)
print('geschrieben:', out, out.stat().st_size, 'Bytes')
