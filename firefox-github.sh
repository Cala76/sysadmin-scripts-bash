#!/bin/bash

# Author: Lic. Guillermo Galeano Fernández
# Date: 2024-02-03_095400
# License: GPL v3.
# Objective: Star firefox with a predefined profile,
# (and to be added if not exist).
# This profile is not going to be listed as option 
# when started Firefox with --profileManager switch.

# Tested with:
# $ dpkg -l | grep -E '\ bash\ \ |base\-files' 
# ii  base-files                            12.4+deb12u4                        amd64        Debian base system miscellaneous files
# ii  bash                                  5.2.15-2+b2                         amd64        GNU Bourne Again SHell

# Without / at the end!
DIR_PROFILES="/home/calabaza/firefox-profiles"
PROFILE="github"
INITIAL_WEB_SITE="https://github.com/login"

firefox -P $PROFILE --profile $DIR_PROFILES/$PROFILE --no-remote $INITIAL_WEB_SITE

# Use this line when the profile was created with --ProfileManager
# (and the directory is not necessary to be indicated:
#firefox -P $PROFILE $INITIAL_WEB_SITE
