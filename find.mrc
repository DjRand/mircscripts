;
; Script Name:     Find (v1.0)
; Created by:      Rand (Rizon)
;
; Useage:          This wasn't really made to be released as a script,
;                  it was something I decided to make so that I could filter
;                  text from channels to @windows with relative ease.
;
;                  This will open the window for you as well, so you don't have
;                  to perform a /window command before using this. The idea
;                  for this script basically came from /lastlog in many console
;                  clients.
;
;                  The switches:
;                  -in <chan or window>, -out <window>, -regex, -x
;                      -in is the "read from" window or channel.
;                      -out is the "output to" window.
;                      -regex, switch indicates you are using: /regex/
;                      -x, switch indicates you want to match all lines but those
;                                 containing this.
;                  
;
; Commands:        /find JohnDoe,
;                     This will search your active window for text "JohnDoe"
;                     (it actually looks for *JohnDoe* as it's a wildcard),
;                     opens @find and outputs the results into @find.
;                     If @find was already open, it will hide and clear the window.
;
;                  /find -in #chan1 -out @mywin http:,
;                     This will search #chan1 and output the results to @mywin.
;
;                  /find -regex /<nick>|\* nick/i
;                     This uses regular expressions and searches the active window
;                     and outputs the results to @find.
;
;                  /find -x blah
;                     This matches all lines except those that contain: blah, in it.
;
;
; Extra Stuff:     /ofind, this is just a simple alias to perform "only" matches
;                     and works only with regular expressions. Note that this
;                     command is extremely limited, and to use it, you will need to
;                     put () around a regex, to have it displayed. Please note that
;                     this is not very optimal. I'm just leaving this command in
;                     for the hell of it.
;
;                  For instance, if you wanted to find all the HTTP links in your
;                  active channel, you would type:
;
;                  /ofind /(http:\S+)/ig
;
;
; Notes:           Please note that because of the way I scripted this, /find has
;                  no way of knowing if you're seaching for "-in blah" in your buffer.
;                  So if you really need to search for one of these, use: "-in #window"
;                  then you can specify "-in something" as your match text.
;                  
;                  There are ways to get around this, but implementing them would mean
;                  that the syntax for searching would need to be changed. Such as
;                  using " around the search params. I may add this at a later time,
;                  but as it stands, I don't really see a need to do so at the moment.
;

alias find {
  var %in = $active,%switch = -wwbzp
  if (-out !isin $1-) { tokenize 32 -out @find $1- }
  if ($regex($1-,/-in (\S+)/i)) {
    var %in = $regml(1)
    tokenize 32 $regsubex($1-,/-in (\S+)/i,)
  }
  if ($regex($1-,/-out (\S+)/i)) { 
    var %out = $regml(1)
    if (#* iswm %out) { echo -ag *** Error: You can not specify a channel as the out window. | return }
    tokenize 32 $regsubex($1-,/-out (\S+)/i,)
    if (@* iswm %out) { window -aez %out }
  }
  if ($regex($1-,/-x/i)) { 
    var %switch = %switch $+ x
    tokenize 32 $regsubex($1-,/-x/i,)
  }

  if ($regex($1-,/-noclear/i)) {
    tokenize 32 $regsubex($1-,/-noclear/i,)
    var %noclear = 1
  }

  if ($regex($1-,/-regex/i)) {
    var %switch = %switch $+ g
    tokenize 32 $regsubex($1-,/-regex/i,)
  }
  else { tokenize 32 $+(*,$1-,*) }

  if (@* iswm %out && !%noclear) { var %switch = %switch $+ c }
  filter %switch %in %out $1-
}
alias findall {
  var %i = 1
  while ($chan(%i)) {
    var %chan = $v1
    find -in %chan -out @findall -noclear $1-
    echo 4 @findall $str(-,5) ( %chan ) $str(-,5)

    inc %i
  }
}
alias ofind {
  var %in = $active , %out = @ofind
  set -u %regex $1-
  window -he %out | clear %out
  filter -wkgb $active _ofind %regex
  window -aw3 %out
}
alias -l _ofind { noop $regex($1,%regex) | var %i = 1 | while ($regml(%i)) { aline @ofind $regml(%i) | inc %i } }
