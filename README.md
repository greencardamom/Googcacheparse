Google Cache Parser
===================
by User:GreenC (en.wikipedia.org)

February 2024

MIT License

Info
========
This program converts a Google Cache URL to its original source URL.

For example convert this: https://webcache.googleusercontent.com/search?q=cache:sHD-ZAEu5_8J:https://issuu.com/ponsonbynews/docs/ponsonbynewsmar2015+&cd=1&hl=en&ct=clnk&gl

To this: https://issuu.com/ponsonbynews/docs/ponsonbynewsmar2015

Notes
========

1.   The program is not 100% perfect because Google parameters can look like authentic parameters. YMMV. See testcases file
2.   The program was developed using thousands of GC URLs found on Wikipedia and manually verified.
3.   The function was written in Nim and converted to a GNU Awk for portability.
4.   The program is self contained requiring only /usr/bin/awk to run

Dependencies 
========
* GNU Awk 4.1 or higher

Installation
========

1. Clone
	git clone https://github.com/greencardamom/Googcacheparse

2. chmod 750 googcacheparse.awk

3. Edit googcacheparse.awk and change the first shebang line to the location of awk on your system typically /usr/bin/awk

Running
========

./googcacheparse <url>


Testcases
========

The file testcases.txt is about 1,000 lines with " ---- " as a field break. Field 1 is the original Google Cache URL and Field 2 is the result of googcacheparse.awk
