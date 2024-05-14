# Advanced command Git and GitHub virual training

* High-reliability collaborative software development is built on version control, review culture, and CI
* TL;DR
  * Use GitHub for source code
  * Use PR for every change and get it reviewed
  * Use GitHub actions to run tests and lint code
  * **Maintain a linear history on the main branch**
* Topics
  * Optmising your auth and config setup
  * Code review
  * Linear history
  * Fixing conflicts
* Auth
  * HTTPS
  * SSH
  * GitHub CLI (gh)
* https://jvns.ca/blog/2024/02/16/popular-git-config-options/
* Possible best practice: name branches `athowes-branch-name`
* Don't force push between reviews
* Two options
  * Merge commits
    * Multiple timelines
    * Merge commits where timelines converge
    * No history rewriting
  * Linear history
    * Single timeline
    * No merge commits; every commit is a change
    * Requires history rewriting
* Always do fast forward merge when pulling to main (TODO: understand better why this is)
* If there are no conflicts, just use squash and merge on GitHub, no need to use command line
