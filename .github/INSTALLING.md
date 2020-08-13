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
