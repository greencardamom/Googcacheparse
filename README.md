Google Cache Parser
===================
by User:GreenC (en.wikipedia.org)

February 2024

MIT License

Info
========
This program converts a Google Cache URL to its original source URL.

For example convert: https://webcache.googleusercontent.com/search?q=cache:cRnEZl-vyEkJ:https://www.allsaints-online.co.uk/+&cd=3&hl=en&ct=clnk&gl=uk

To: https://www.allsaints-online.co.uk/ 

It works by removing Google Cache URL data from the start and end of the URL.

Notes
========

1.   The program is not 100% perfect because Google parameters can look like authentic parameters. YMMV but accuracy is high. See the testcases file
2.   The program was developed with thousands of GC URLs found on Wikipedia and manually verified.
3.   The function was written in Nim and converted to GNU awk for portability.
4.   The program is self contained requiring only awk to run

Dependencies 
========
* GNU awk 4.1 or higher

Installation
========

1. git clone https://github.com/greencardamom/Googcacheparse

2. chmod 750 googcacheparse.awk

3. Edit googcacheparse.awk and change the first shebang line to the location of awk on your system typically /usr/bin/awk

Running
========

./googcacheparse url


Testcases
========

The file testcases.txt is about 3,300 lines with " ---- " as the field break. Field 1 is the original Google Cache URL, and Field 2 is the result of googcacheparse.awk
