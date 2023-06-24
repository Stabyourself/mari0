#!/usr/bin/env python

'''
Extracts game metadata from main.lua and makelove.toml
and writes it out for use by GitHub Actions.

Authored by @qixils
'''

import os
from pathlib import Path
import re
import sys

game_path: Path = Path(__file__).parent.parent.resolve()
main_path: Path = game_path / 'main.lua'
conf_path: Path = game_path / 'conf.lua'
toml_path: Path = game_path / 'makelove.toml'
metadata: dict[str, str] = {}

with open(main_path, 'r') as main_file:
    main = main_file.read()
    metadata['title'] = re.search(r'love\.window\.setTitle\(\s*"(.+)"\s*\)', main).group(1)
    metadata['version'] = re.search(r'^\s*versionstring\s*=\s*"version (.+)"$', main, re.MULTILINE).group(1)

with open(conf_path, 'r') as conf_file:
    conf = conf_file.read()
    metadata['love-version'] = re.search(r'^\s*t\.version\s*=\s*"(.+)"$', conf, re.MULTILINE).group(1)

with open(toml_path, 'r') as toml_file:
    toml = toml_file.read()
    metadata['id'] = re.search(r'^name\s*=\s*"(.+)"', toml).group(1)
    # ensure title is the same as the one in main.lua
    if (_win_title := re.search(r'^ProductName\s*=\s*"(.+)"$', toml, re.MULTILINE)) is None:
        print('::warning file=makelove.toml::Windows product name could not be found')
    if metadata['title'] != _win_title.group(1):
        print('::warning file=makelove.toml::Windows product name does not match game title in main.lua')
    if (_linux_title := re.search(r'\[linux.desktop_file_metadata\]\n+Name\s*=\s*"(.+)"', toml, re.MULTILINE)) is None:
        print('::warning file=makelove.toml::Linux desktop file name could not be found')
    if metadata['title'] != _linux_title.group(1):
        print('::warning file=makelove.toml::Linux desktop file name does not match game title in main.lua')
    if (_mac_title := re.search(r'^CFBundle(?:Display)?Name\s*=\s*"(.+)"$', toml, re.MULTILINE)) is None:
        print('::warning file=makelove.toml::macOS bundle display name could not be found')
    if metadata['title'] != _mac_title.group(1):
        print('::warning file=makelove.toml::macOS bundle display name does not match game title in main.lua')

if len(sys.argv) > 1:
    if (version := re.sub(r'^refs/tags/v?', '', sys.argv[1], count=1)) != sys.argv[1]:
        metadata['version'] = version

with open(os.environ['GITHUB_OUTPUT'], 'a') as env_file:
    for key, value in metadata.items():
        env_file.write(f'{key}={value}\n')
