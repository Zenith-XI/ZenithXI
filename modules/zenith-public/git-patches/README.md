# Patches are applied via dbtool (a. Apply Patches)

To build a new file, it must be added sequentially to the end.

Furthermore, you must create a temporary stage or commit of the changes from all previous files:

- run dbtool to apply patches, stage them
- make the changes you want to make
- run `git diff > .\modules\zenith-public\git-patches\<blah>.patch` and you'll get a clean patch file that can apply on top of all the rest
- `<blah>` needs to be a descriptive name for the diffs as well as the next formatted number so that dictionary sort lists it last when running the full dbtool patches
- Finally, ensure the encoding on the new `.patch` file is UTF-8
  - simple way to do this is opening in notepad++ and going to the Encoding toolbar menu and picking UTF-8
  - while in npp, go to `edit > EOL Conversion > UNIX format`

# automated creation of LSB PR patch files

cd to the git-patches directory (this one), and run `python pull-pr.py <prNum>` if the file already exists for this PR, or `python pull-pr.py <prNum> <shortDescriptionWithoutSpaces>`

Example:

```
PS C:\VSCode\zenith\modules\zenith-public\git-patches> python pull-pr.py 5272 avatarAssist
Saved file 000-PR5272-avatarAssist.patch
PS C:\VSCode\zenith\modules\zenith-public\git-patches> python pull-pr.py 5283
Saved file 000-PR5283-wsCritVaries.patch
PS C:\VSCode\zenith\modules\zenith-public\git-patches>
```
