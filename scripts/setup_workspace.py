#!/usr/bin/env python3
"""Copy the blank workspace to a new destination. Python 3.9+. No global changes or network."""
import argparse,shutil
from pathlib import Path

def setup_workspace(source,destination):
 source=Path(source)
 if source.is_symlink() or not source.is_dir() or not (source/'AGENTS.md').is_file():raise ValueError('Source is not a blank workspace template.')
 if any(p.is_symlink() for p in source.rglob('*')):raise ValueError('Source contains a symlink. Inspect it before copying.')
 source=source.resolve();destination=Path(destination).expanduser().absolute()
 if destination.exists() or destination.is_symlink():raise ValueError('Destination already exists. Choose a new directory; nothing was replaced.')
 if destination.resolve().is_relative_to(source):raise ValueError('Destination cannot be inside the workspace template.')
 destination=destination.parent.resolve()/destination.name
 destination.parent.mkdir(parents=True,exist_ok=True)
 # copytree creates the destination exclusively; it never merges with existing files.
 shutil.copytree(source,destination,ignore=shutil.ignore_patterns('__pycache__','*.pyc','.DS_Store'))
 return destination

def main():
 parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--destination',required=True,type=Path);args=parser.parse_args()
 try:destination=setup_workspace(Path(__file__).resolve().parents[1]/'os',args.destination)
 except (ValueError,OSError) as error:parser.exit(2,str(error)+'\n')
 print('Created workspace: '+str(destination));print('Open it in your file-capable agent and read AGENTS.md. No global configuration, Git, or remote was changed.')
if __name__=='__main__':main()
