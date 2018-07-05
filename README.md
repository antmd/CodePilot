What is Code Pilot?
===================

This version of Code Pilot is compatible with Xcode 9, and introduces a 'Recent Files' switcher (Ctrl-Tab).

Xcode 9 requires re-signing before you can install. See this page for the XVim plugin: https://github.com/XVimProject/XVim2/blob/master/SIGNING_Xcode.md

Read the [full story](http://macoscope.com/blog/the-story-of-code-pilot/) of Code Pilot. Here's the GitHub repo. for the un-maintained version: https://github.com/macoscope/CodePilot

This is a work-in-progress: the symbol functionality is not complete, but the approach used in the code is correct. I just do not have time to complete the work, so any pull-requests will be gratefully received.

How to use Code Pilot?
======================

Resign Xcode (at your own risk -- signing of Xcode is supposed to stop malicious versions of Xcode doing nasty things), build the CodePilot plugin, then re-start Xcode.


The Switcher
============

Pressing Ctrl-Tab brings up the recent-files switcher. As soon as Ctrl is released, the switcher is dismissed. If you have selected a different file in the switcher, that file will be displayed.

The keys supported in the switcher (Ctrl must be held down):

tab - select next file in the list
shift-tab - select the previous file in the list
w - open the selected file in full-size window mode
v/s - open the selected file in a split
esc - close the switcher without changing file-focus

License
=======

Copyright 2014 Macoscope Sp. z o.o.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
