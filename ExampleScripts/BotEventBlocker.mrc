; Bot Join/Part/Quit ignore.
;
; Small script made specifically to hide 'known' bot's J/P/Q messages.
; Press Ctrl+R > File > New > Save As... "botjpqhide.mrc"
;
; I'll leave comments in the script so you know what you can edit.
; and how to edit it.


; This alias will be used as a function/identifier.
; It checks to see if a nick is in the "known bot" list.
; You can modify the names of the bots.
; This identifier returns true or false.
; $knownbot(BotName)

alias knownbot {
  ; This variable is a list of known bots.
  ; You can add more bots to the end of it, in the format of
  ; "botname1 botname2 botname3"
  ; It's space delimited.  So to add a new bot, just click the
  ; end of the line, press space, and put the new bots name.

  var %bots = DespBot HC`s_helper

  ; Check if "$1" is in %bots. Using $istok()
  if ($istok(%bots,$1,32)) {
    ; Return $true if $1 is a known bot.
    return $true
  }

  ; if the script doesn't find a bot return $false:
  return $false
}

; Now that we have our $knownbot identifier, we can make use of it with some events.
; If you already have an mIRC theme, you will need to ALSO edit the on join/part/quit events
; of those scripts, in order to hide those specific events from happening.
on ^*:join:#:{
  if ($knownbot($nick)) {
    ; If this returns true, that means the nick is in the known bot list.
    ; All we have to do is "haltdef"
    haltdef
  }
}

on ^*:quit:{
  if ($knownbot($nick)) {
    ; Same deal as the on join script.
    haltdef
  }
}

on ^*:part:#:{
  if ($knownbot($nick)) {
    ; Same deal.....
    haltdef
  }
}

on ^*:op:#:{
  ; Use $opnick instead of $nick.  As $opnick will be the bots name.
  if ($knownbot($opnick)) {
    ; Same deal :D
    haltdef
  }
}


; And so on..  For any other events you want to block these bots from, it's more or less the same thing.
; Simple right?  Enjoy!
