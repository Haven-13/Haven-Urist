# Astro Haven 13 [![Build Status](https://travis-ci.com/AstroHaven-13/Haven-Urist.svg?branch=master)](https://travis-ci.com/AstroHaven-13/Haven-Urist)

AH13's Urist McStation's BS12 branch. 

[Website](http://astrohaven-13.github.io/) - [Github](https://github.com/AstroHaven-13/Haven-Urist) -  [Original Code](http://github.com/UristMcStation/UristMcStation/) - [IRC](http://baystation12.net/forums/viewtopic.php?f=12&t=5088)

---

### LICENSE

Licenses used in this repo, applicable for the entire repo *and* distribution:
* [GNU Affero General Public License v3](http://www.gnu.org/licenses/agpl-3.0.html) - Primary
* [GNU General Public License v3](https://www.gnu.org/licenses/gpl-3.0.html)

Submodule licenses, for double licensing:
* [MIT License](https://tldrlegal.com/l/mit) for tgui subproject

For assets and other works:
* [Creative Commons 3.0 BY-SA license](http://creativecommons.org/licenses/by-sa/3.0/)
* [SIL Open Font License](https://www.tldrlegal.com/l/ofl) for Font Awesome fonts

Other exceptions may exist

#### In detail
The code for Baystation12 is licensed under the [GNU Affero General Public License v3](http://www.gnu.org/licenses/agpl.html), which can be found in full in LICENSE-AGPL3.txt. See Urist McStation's [readme](https://github.com/UristMcStation/UristMcStation/blob/master/README.md) for more licensing information related to using the Baystation12 code modified by Urist and Haven.

tgui clientside is licensed as a subproject under the MIT license.
Font Awesome font files, used by tgui, are licensed under the SIL Open Font License v1.1
tgui assets are licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

See tgui/LICENSE.md for the MIT license.
See tgui/assets/fonts/SIL-OFL-1.1-LICENSE.md for the SIL Open Font License.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](http://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.

### GETTING THE CODE

In a terminal, run this to start cloning this entire codebase with its history.
    
    git clone https://github.com/AstroHaven-13/Haven-Urist.git
    
Or if you want to shorten your download time. By fetching the lastest revision and only the master branch, otherwise add `--branch` and then the name of the branch you wish to clone.
    
    git clone --depth 1 https://github.com/AstroHaven-13/Haven-Urist.git
    
The caveat is tools used to trace back in git's revision history can not be used. The history has to be fetched first using `git fetch --unshallow`.

---

### INSTALLATION

First-time installation should be fairly straightforward.  First, you'll need BYOND installed.  You can get it from [here](http://www.byond.com/).

This is a sourcecode-only release, so the next step is to compile the server files.  Open baystation12.dme by double-clicking it, open the Build menu, and click compile.  This'll take a little while, and if everything's done right you'll get a message like this:

    saving baystation12.dmb (DEBUG mode)
    
    baystation12.dmb - 0 errors, 0 warnings

Once that's done, open up the config folder.  You'll want to edit config.txt to set the probabilities for different gamemodes in Secret and to set your server location so that all your players don't get disconnected at the end of each round.  It's recommended you don't turn on the gamemodes with probability 0, as they have various issues and aren't currently being tested, so they may have unknown and bizarre bugs.

You'll also want to edit admins.txt to remove the default admins and add your own.  "Game Master" is the highest level of access, and the other recommended admin levels for now are "Game Admin" and "Moderator".  The format is:

    byondkey - Rank

where the BYOND key must be in lowercase and the admin rank must be properly capitalised.  There are a bunch more admin ranks, but these two should be enough for most servers, assuming you have trustworthy admins.

Finally, to start the server, run Dream Daemon and enter the path to your compiled `baystation12.dmb` file.  Make sure to set the port to the one you  specified in the config.txt, and set the Security box to 'Trusted'.  Then press GO and the server should start up and be ready to join.

---

### UPDATING

To update an existing installation, first back up your /config and /data folders
as these store your server configuration, player preferences and banlist.

Run in a terminal of your choice:

    git pull

Then restore your /config and /data

---

### Configuration

For a basic setup, simply copy every file from config/example to config.

---

### SQL Setup

The SQL backend for the library/stats and bans requires a MySQL server.  Your server details go in config/dbconfig.txt.

For initial setup and migrations refer to sql/README.md
