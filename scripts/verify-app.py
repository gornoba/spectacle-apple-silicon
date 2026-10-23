#!/usr/bin/env python3
"""Check the local arm64 app or ZIP without executing it or changing system state."""
import argparse
import json
import os
from pathlib import Path
import plistlib
import subprocess
import tempfile
import zipfile


def run(*args):
    return subprocess.check_output(args, text=True, stderr=subprocess.STDOUT).strip()


def verify(app):
    info = plistlib.loads((app / 'Contents/Info.plist').read_bytes())
    assert info['CFBundleIdentifier'] == 'com.divisiblebyzero.Spectacle', 'Bundle ID changed'
    assert info['CFBundleShortVersionString'] == '1.0', 'Unexpected version'
    assert info['CFBundleVersion'] == '1', 'Unexpected build number'
    assert info['LSMinimumSystemVersion'] == '13.0', 'Unexpected minimum macOS'
    assert not any(k.startswith('SU') for k in info), 'Updater configuration remains'
    license_path = app / 'Contents/Resources/LICENSE.md'
    source_license = Path(__file__).resolve().parent.parent / 'LICENSE.md'
    assert license_path.read_bytes() == source_license.read_bytes(), 'Original MIT license missing or altered'
    binaries = []
    for root, dirs, files in os.walk(app):
        for filename in files:
            path = Path(root) / filename
            assert not path.is_symlink(), f'Unexpected symlink: {path}'
            data = path.read_bytes()
            assert not any(token in data for token in (b'SUUpdater', b'spectacleapp.com/updates')), f'Updater reference: {path}'
            assert 'Sparkle' not in str(path.relative_to(app)), f'Updater file: {path}'
            if 'Mach-O' in run('file', '-b', str(path)):
                assert run('lipo', '-archs', str(path)).split() == ['arm64'], f'Non-arm64 binary: {path}'
                for line in run('otool', '-L', str(path)).splitlines()[1:]:
                    dependency = line.strip().split(' (', 1)[0]
                    assert dependency.startswith(('/System/Library/', '/usr/lib/')), f'Bundled dependency: {dependency}'
                assert 'minos 13.0' in run('xcrun', 'vtool', '-show-build', str(path)), 'Binary deployment target mismatch'
                binaries.append(str(path.relative_to(app)))
    assert binaries == ['Contents/MacOS/Spectacle'], f'Unexpected binaries: {binaries}'
    assert not list(app.rglob('*.xctest')), 'Tests must not be packaged'
    run('codesign', '--verify', '--deep', '--strict', str(app))
    return {'version': '1.0 (1)', 'minimum_macos': '13.0', 'architectures': ['arm64'], 'binaries': binaries, 'signature_valid': True}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('artifact', type=Path)
    args = parser.parse_args()
    artifact = args.artifact.resolve()
    if artifact.suffix == '.zip':
        with zipfile.ZipFile(artifact) as archive:
            for name in archive.namelist():
                assert name.startswith('Spectacle.app/') and '..' not in Path(name).parts, f'Unexpected ZIP entry: {name}'
        with tempfile.TemporaryDirectory(prefix='spectacle-zip-check-') as directory:
            run('ditto', '-x', '-k', str(artifact), directory)
            report = verify(Path(directory) / 'Spectacle.app')
            assert os.access(Path(directory) / 'Spectacle.app/Contents/MacOS/Spectacle', os.X_OK), 'ZIP lost executable permission'
    else:
        report = verify(artifact)
    print(json.dumps({'artifact': str(artifact), **report}, indent=2))


if __name__ == '__main__':
    main()
