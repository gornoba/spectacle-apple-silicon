#!/usr/bin/env python3
"""Back up the installed app and private settings without stopping or replacing it."""
from datetime import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

root = Path(__file__).resolve().parent.parent
backup = root / 'build/backups' / datetime.now().strftime('%Y%m%d-%H%M%S')
backup.mkdir(parents=True, mode=0o700)
os.chmod(backup, 0o700)
locations = {
    'Spectacle.app': Path('/Applications/Spectacle.app'),
    'Application Support': Path.home() / 'Library/Application Support/Spectacle',
    'Preferences.plist': Path.home() / 'Library/Preferences/com.divisiblebyzero.Spectacle.plist',
}
manifest = {'created_local': datetime.now().isoformat(), 'settings_sha256': {}, 'locations': {}}
for name, path in locations.items():
    if path.exists():
        subprocess.run(['ditto', str(path), str(backup / name)], check=True)
        manifest['locations'][name] = str(path)
        if path.is_file():
            manifest['settings_sha256'][str(path)] = hashlib.sha256(path.read_bytes()).hexdigest()
shortcuts = locations['Application Support'] / 'Shortcuts.json'
if shortcuts.exists():
    manifest['settings_sha256'][str(shortcuts)] = hashlib.sha256(shortcuts.read_bytes()).hexdigest()
result = subprocess.run(['sfltool', 'dumpbtm'], capture_output=True, text=True, check=True)
manifest['login_records'] = []
for block in re.split(r'\n #\d+:\n', result.stdout):
    if re.search(r'Bundle Identifier:\s*com\.divisiblebyzero\.Spectacle\s*$', block, re.M):
        fields = {}
        for line in block.splitlines():
            if any(line.strip().startswith(key) for key in ['Name:', 'Type:', 'Disposition:', 'URL:', 'Bundle Identifier:']):
                key, value = line.strip().split(':', 1)
                fields[key] = value.strip()
        manifest['login_records'].append(fields)
manifest['processes'] = [line.strip() for line in subprocess.check_output(['ps', '-axo', 'pid=,comm='], text=True).splitlines() if '/Applications/Spectacle.app/' in line]
manifest_path = backup / 'manifest.json'
manifest_path.write_text(json.dumps(manifest, indent=2))
os.chmod(manifest_path, 0o600)
print(json.dumps({'backup': str(backup), 'copied_items': list(manifest['locations']), 'login_records': len(manifest['login_records'])}))
