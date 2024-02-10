#!/usr/bin/awk -bE
# GNU Awk

# https://github.com/greencardamom/Googcacheparse

#
# Given a Google Cache URL, return the original source URL. eg.
#
#   ./googcacheparse 'http://webcache.googleusercontent.com/search?q=cache:96GwmlcLrisJ:paperspast.natlib.govt.nz/cgi-bin/paperspast%3Fa%3Dd%26d%3DMT19070515.2.22+&cd=2&hl=en&ct=clnk&gl=nz&client=firefox-a'
#   http://paperspast.natlib.govt.nz/cgi-bin/paperspast?a=d&d=MT19070515.2.22
#
# Notes:
#
#   The program is not 100% perfect because Google parameters can look like authentic parameters. YMMV. See test file results.
#   The program was developed using thousands of GC URLs found on Wikipedia and manually verified. 
#   The function was written in Nim and converted to a GNU Awk for portability. 
#   The program is self contained requiring only /usr/bin/awk to run
#

# The MIT License (MIT)
#
# Copyright (c) 2024 by User:GreenC (at en.wikipedia.org)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


BEGIN {

  IGNORECASE=1

  url = ARGV[1]
  if(length(url) < 10 || url !~ "^http") {
    print "\n  googcacheparse <url>\n"
    print "  If unable to parse, return url as given on command-line"
  }
  print googcacheParse(url)

}

#
# Given a Google Cache URL return the source URL
#
function googcacheParse(newurl,  del,res,safeurl) {

  safeurl = newurl

  # Decode everything but %20
  if(newurl ~ "%[23][abcdef]") 
    safeurl = subs("ZZZZZZ", "%20", urldecodeawk(subs("%20", "ZZZZZZ", safeurl)))

  # Find the cache: string to remove
  if(match(safeurl, "cache:[^:]*[:]*", d)) {
    if(d[0] ~ "(http|[.])") {
      if(match(safeurl, "cache:", dd)) 
        del = dd[0]
      else
        del = safeurl
    }
    else
      del = d[0]
  }
  else
    del = safeurl

  # Delete the cache string
  if(match(safeurl, "cache:[^$]*[$]*", d)) {
    d[0] = subs(del, "", d[0])
    if(d[0] !~ "^http")
      d[0] = "http://" d[0]
    res = d[0]
  } # For &u=http varities that have no cache: string
  else if(match(safeurl, "([?]|[&])u=[^$]*[$]*", d)) {
    sub("^([?]|[&])u=", "", d[0])
    if(d[0] !~ "^http")
      d[0] = "http://" d[0]
    res = d[0]
  }
  else # Unable to parse
    return newurl

  return googcacheTail(res)

}

#
# Remove Google's garbage at tail of URL
#
function googcacheTail(res,  dd,ores,sss) {

  ores = res

  if(match(res, "[/]search[?][^$]*[$]*", dd))
    res = subs(dd[0], "", res)
  if(match(res, "[+][&\"][^$]*[$]*", dd))
    res = subs(dd[0], "", res)
  if(match(res, "[+]%22[^$]*[$]*", dd))
    res = subs(dd[0], "", res)
  if(match(res, "&cd=[^$]*[$]*", dd))
    res = subs(dd[0], "", res)
  if(match(res, "&hl=[^$]*[$]*", dd))
    res = subs(dd[0], "", res)
  if(match(res, "&gws_rd=[^$]*[$]*", dd))
    res = subs(dd[0], "", res)
  if(match(res, "&aqs=[^$]*[$]*", dd))
    res = subs(dd[0], "", res)
  if(match(res, "&prev=[^$]*[$]*", dd))
    res = subs(dd[0], "", res)
  if(match(res, "&oq=[^$]*[$]*", dd))
    res = subs(dd[0], "", res)
  if(match(res, "&-find[^$]*[$]*", dd))
    res = subs(dd[0], "", res)

  if(match(res, "%20$"))
    sub("%20$", "", res)
  if(match(res, "[+]$"))
    sub("[+]$", "", res)

  if(match(res, "html[+][^$]*[$]*" , dd)) {
    res = subs(dd[0], "", res)
    res = res "html"
  } 
  else if(match(res, "htm[+][^$]*[$]*" , dd)) {
    res = subs(dd[0], "", res)
    res = res "htm"
  } 
  else if(match(res, "pdf[+][^$]*[$]*" , dd)) {
    res = subs(dd[0], "", res)
    res = res "pdf"
  }
  else if(match(res, "pdf[?][^$]*[$]*" , dd)) {
    res = subs(dd[0], "", res)
    res = res "pdf"
  }
  else if(match(res, "asp[+][^$]*[$]*" , dd)) {
    res = subs(dd[0], "", res)
    res = res "asp"
  } 
  else if(match(res, "xml[+][^$]*[$]*" , dd)) {
    res = subs(dd[0], "", res)
    res = res "xml"
  }
  else if(match(res, "doc[+][^$]*[$]*" , dd)) {
    res = subs(dd[0], "", res)
    res = res "doc"
  }
  else if(match(res, "docx[+][^$]*[$]*" , dd)) {
    res = subs(dd[0], "", res)
    res = res "docx"
  }

  if(res ~ "ct=clnk") {
    if(index(res, "+") > 0) {
      sss = substr(res, index(res, "+"))
      res = subs(sss, "", res)
    }
  }

  if(res ~ "[+]") {
    if(index(res, "+") > 0) {
      sss = substr(res, index(res, "+"))
      if(sss ~ "[+]") {
        if(countsubstring(sss, "+") > 1) {
          if(sss !~ "&" && sss !~ "[?]" && sss !~ "/") 
            res = subs(sss, "", res)
        }
      }
    }
  }

  if(res !~ "^http")
    return ores

  return res

}

# -----------------------------------------------------------
# Library functions 
#   Extracted from BotWikiAwk https://github.com/greencardamom/BotWikiAwk
#   in ~lib/library.awk
# -----------------------------------------------------------

#
# empty() - return 0 if string is 0-length
#
function empty(s) {
    if (length(s) == 0)
        return 1
    return 0
}

# 
# countsubstring() - returns number of occurances of pattern in str     
# 
#   . pattern treated as a literal string, regex char safe                 
#   . to count substring using regex use gsub ie. total += gsub("[.]","",str)
#
#   Example:     
#      print countsubstring("[do&d?run*d!run>run*", "run*") ==> 2       
#
function countsubstring(str, pat,    len, i, c) {
    c = 0
    if ( ! (len = length(pat) ) ) {
        return 0
    }              
    while (i = index(str, pat)) {
        str = substr(str, i + len)
        c++          
    }       
    return c          
}

#
# subs() - like sub() but literal non-regex
#               
#   Example:     
#      s = "*field"
#      print subs("*", "-", s)  #=> -field
#
#   Credit: adapted from lsub() by Daniel Mills https://github.com/e36freak/awk-libs
# 
function subs(pat, rep, str,    len, i) {

    if (!length(str))
        return

    # get the length of pat, in order to know how much of the string to remove
    if (!(len = length(pat)))
        return str

    # substitute str for rep
    if (i = index(str, pat))       
        str = substr(str, 1, i - 1) rep substr(str, i + len)

    return str
}


#               
# urldecodeawk - decode a urlencoded string
#                  
#  Requirement: gawk -b
#  Credit: Rosetta Stone January 2017.
#          "literal" added by GreenC 2020
# 
function urldecodeawk(str,  safe,len,L,M,R,i,literal,debug) {

    debug = 0        

    safe = str
    len = length(safe)
    for (i = 1; i <= len; i++) {
        literal = 0
        if ( substr(safe,i,1) == "%") {

                                           # Bug in data, need at least two valid chars after a %, otherwise return as literal %
                                           # awk -ilibrary 'BEGIN{print urldecodeawk("test%2")}' => "test%2"
                                           # awk -ilibrary 'BEGIN{print urldecodeawk("test%#i")}' => "test%#i"
            if(empty(substr(safe,i+1,1)) || empty(substr(safe,i+2,1)))
              literal = 1
            if(substr(safe,i+1,1) !~ /[0-9a-zA-Z]/ || substr(safe,i+2,1) !~ /[0-9a-zA-Z]/)
              literal = 1

            L = substr(safe,1,i-1)         # chars to left of "%"

            if(debug) print "L = " L

            if(!literal)
              M = substr(safe,i+1,2)       # 2 chars to right of "%"
            else
              M = ""

            if(debug) print "M = " M

            if(!literal)
              R = substr(safe,i+3)         # chars to right of "%xx"
            else {
              if(len - 1 == i)
                R = substr(safe, i + 1, 1)
              else
                R = ""
            }

            if(debug) print "R = " R

            if(!literal)
              safe = sprintf("%s%c%s",L,hex2dec(M),R)
            else
              safe = sprintf("%s", L) "%" sprintf("%s", R)
        }
    }
    return safe
}
function hex2dec(s,  num) {
    num = index("0123456789ABCDEF",toupper(substr(s,length(s)))) - 1
    sub(/.$/,"",s)
    return num + (length(s) ? 16*hex2dec(s) : 0)
}

