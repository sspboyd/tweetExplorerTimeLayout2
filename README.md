README
======
Dec 13, 2012

This project is a first cut at looking at traffic on Twitter around specific keywords. I happen to work at the CBC so using "CBC" as the keyword became a convenient subject to start with. 

The tweets are pulled in from a filtered Twitter Stream (not search). I am using 140dev's very nice (and easy) PHP/MYSQL code which is chugging away on a shared Dreamhost server. It is not a 'professional' grade system, I have to kick the process every once in while to restart when it mysteriously quits. This means there are gaps in the data but they are few and far between. For my purposes of testing out ways of looking at the data, the system works well.

Interacting with the sketch
===========================
There's not much to do in the way of interaction at this point. It is easy to add highlighting by mouse over, however with ~180K objects it is running slowly on my computer (macbook air).

- press 'S' to save a screen cap.

The sketch currently runs under Processing v2.0b7. Processing is available from Processing.org

The sketch uses standard Processing and Java specific methods for Calendar. This means it can't be automatically ported to Processing.js without re-coding the Java Calendar object functions into the corresponding Javascript functions.


Stephen Boyd
@sspboyd