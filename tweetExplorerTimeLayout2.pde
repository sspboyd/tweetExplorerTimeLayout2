import java.util.Calendar;

// Bugs to be checked:
// I think the cause of the screwy layout is that the time offset is pushing the first tweets back to the day before.
// eg. the tweets on April 1, 00:00:01 are showing up as March 31st, 11pm 
// solution might be to strip out any tweets that are earlier than the 'oldestTweetM' date?


//Declare Globals
int rSn; // randomSeed number. put into var so can be saved in file name. defaults to 47
final float PHI = 0.618033989;
final int mspd = 24 * 60 * 60 * 1000; // milliseconds per day, 86400000 
// final int minsPerDay = 24 * 60; // 1440 // not being used
// final int hrsPerDay = 24; // not being used
boolean firstDraw = false;
PFont font, fontTitle;

ArrayList<Tweet> tweets = new ArrayList();
String[] keywords;
String[] accts;

Calendar oldestTweetM; // this is the beginning of the day for the oldest (first) tweet 
Calendar newestTweetM; // this is the end of the day for the newest (last) tweet

boolean recording = false;
float maxTweetLen;

float plotX1, plotX2, plotY1, plotY2; // defines area for chart
float margin, plotPadding;


void setup() {
  size(1920, 1080);
  background(0);
  
  rSn = 47; // 18, 29, 76
  randomSeed(rSn);

  font = createFont("Helvetica", 2);  //does not require a font file in the data folder
  fontTitle = createFont("Helvetica", 18);  //does not require a font file in the data folder
  // fontTitle = loadFont("HelveticaNeue-Light-48.vlw");  //does not require a font file in the data folder

  textFont(font);
  textSize(2);
  String sampleTweetLength = "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. @#. ";
  maxTweetLen = textWidth(sampleTweetLength);

  margin = width * pow(PHI, 7);
  plotPadding = margin * PHI;

  println("margin: " + margin);
  println("plotPadding: " + plotPadding);
  plotX1 = margin + plotPadding;
  plotX2 = width - margin - plotPadding;
  plotY1 = (margin * 2) + plotPadding;
  plotY2 = height - margin - plotPadding;
  

  // loadTweets("tweetsLarge.csv");
  loadTweets("tweetsCBCApr13.csv");
  // loadTweets("tweetsSmall.csv");
  // loadTweets("tweetsTiny.csv");

  newestTweetM = endTweet(tweets); // most recent tweet (?)
  println("newest Time: " + newestTweetM.getTime());
  oldestTweetM = startTweet(tweets); // 'least' recent tweet
  println("oldest Time: " + oldestTweetM.getTime());

  // Set the x, y, z locations for all the tweets.
  for (Tweet ctw : tweets){
    float crat = ctw.created_at.getTimeInMillis()-(1000*60*60*5); // (convenience)
    ctw.targLoc.x = map(crat, oldestTweetM.getTimeInMillis(), newestTweetM.getTimeInMillis(), plotX1, plotX2-maxTweetLen);
    float secOffset = crat % float(mspd);
    ctw.targLoc.y = map(secOffset, float(mspd), 0, plotY2, plotY1);
    // ctw.targLoc.z = 0;

    ctw.loc.x = ctw.targLoc.x;
    ctw.loc.y = ctw.targLoc.y;
    // ctw.loc.z = ctw.targLoc.z;
  }

  // initWords();
  noLoop();
  println("setup done: " + nf(millis() / 1000.0, 1, 2));
}

void draw() {
 background(0);
 renderChart();
 chrome();
// println("render done: " + nf(millis() / 1000.0, 1, 2));

 if(recording) screenCapMov();
  if(!firstDraw){
    firstDraw = true;
    println("First render: " + nf(millis() / 1000.0, 1, 2));
  }
}
 


void loadTweets(String _fn) {
  int rowCount = 0;
  String[] data = loadStrings(_fn);

  for (int i = 1; i<data.length; i++){
    // println("Processing Line #"+i);
    String[] pieces = split(data[i], TAB);

    Tweet tw = new Tweet();
    tw.sz = width * pow(PHI, 10);
    tw.clr = color(255, 255, 255, 6); // white
    // tw.clr = color(0, 0, 0,2); // black

    // tweet_id tweet_text  created_at  user_id screen_name name  profile_image_url
    tw.tweet_id =           int(pieces[0]);
    tw.tweet_text =         pieces[1];
    tw.created_at =         getCal(pieces[2]);
    tw.user_id =            int(pieces[3]);
    tw.screen_name =        pieces[4];
    tw.name =               pieces[5];
    tw.profile_image_url =  pieces[6];

    tw.loc = new PVector();
    tw.targLoc = new PVector();

    tweets.add(tw);
    rowCount++;
  }
  println("rowCount: " + rowCount);
}


/* 
This method grabs the earliest/oldest tweet publish date and then
returns a Calendar object set to be the start of that day. 
EG. if the last (end) pub date is Feb 11 at 17:08, the returned Calendar is
Feb 11 23:59:59
*/
Calendar endTweet(ArrayList<Tweet> tw){
  Calendar endCal = Calendar.getInstance();
  endCal.setTimeInMillis(-Long.MAX_VALUE); // looking for a future date so init to the past
  for(Tweet ctw : tw){
    if(ctw.created_at.after(endCal)){
      endCal = ctw.created_at;
    }
  }
  Calendar endOfDay = Calendar.getInstance();
  endOfDay.set(endCal.get(Calendar.YEAR), endCal.get(Calendar.MONTH), endCal.get(Calendar.DAY_OF_MONTH), 23, 59,59);
  endCal = endOfDay; 
  return endCal;
}


/* 
This method grabs the first tweet publish date and then
returns a Calendar object set to be the start of that day. 
EG. if the first pub date is Feb 11 at 17:08, the returned Calendar is
Feb 11 00:00
*/
Calendar startTweet(ArrayList<Tweet> tw){
  Calendar startCal = Calendar.getInstance();
  startCal.setTimeInMillis(Long.MAX_VALUE); // looking for a past date so init to the future
  for(Tweet ctw : tw){
    if(ctw.created_at.before(startCal)){
      startCal = ctw.created_at;
    }
  }
  Calendar startOfDay = Calendar.getInstance();
  startOfDay.set(startCal.get(Calendar.YEAR), startCal.get(Calendar.MONTH), startCal.get(Calendar.DAY_OF_MONTH), 0,0,0);
  startCal = startOfDay;
  return startCal;
}


void renderChart() {
  for(Tweet tw : tweets){
    // tw.update();
    tw.render();
  }

  /*
  stroke(255,255,255,100);
  noFill();
  rectMode(CORNERS);
  rect(plotX1, plotY1, plotX2, plotY2);
  */
  // draw axis
  // draw data
  // draw titles
}

Calendar getCal(String ds){ // ds = dateString
  // 0123456789012345678 // figuring out character location of the date string info
  // 2012-11-23 00:00:09
  int yr = int(ds.substring(0,4)); 
  int mon = int(ds.substring(5,7))-1;
  int dy = int(ds.substring(8,10));
  int hr =  int(ds.substring(11,13));
  int minu =  int(ds.substring(14,16));
  int sec =  int(ds.substring(17,19));

  Calendar cal;
  cal = Calendar.getInstance();
  cal.set(yr, mon, dy, hr, minu, sec);
  return cal;
}

///////////////////////////////////////////////////////////////////////////////
//  UI / UTILITY FUNCTIONS
///////////////////////////////////////////////////////////////////////////////

void chrome(){
  textFont(fontTitle);
  textSize(18);
  fill(255, 150);
  text("245420 mentions of \"CBC\" on Twitter, April 2013", margin + plotPadding, margin * 2);

  noFill();
  stroke(255, 150);
  rect(margin, margin, width - (margin * 2), height - (margin * 2));
}

///////////////////////////////////////////////////////////////////////////////
//  UI / UTILITY FUNCTIONS
///////////////////////////////////////////////////////////////////////////////

void keyPressed() {
  if(key == 'S') screenCap();
  if(key == 'm'){
    if(recording){
      recording = false;
    }else{
      recording = true;
    }
  }
}

void screenCap() {
  // save functionality in here
  String outputDir = "out/";
  String sketchName = "tweetExplorerTimeLayout-";
  String randomSeedNum = "rS" + rSn + "-";
  String dateTime = "" + year() + month() + day() + hour() + minute() + second();
  String fileType = ".tif";
  String fileName = outputDir + sketchName + randomSeedNum + dateTime + fileType;
  save(fileName);
  println("Screen shot taken and saved to " + fileName);
}

void screenCapMov() {
  // save functionality in here
  String outputDir = "out/movImgCaps/";
  String sketchName = "tweetExplorerTimeLayout-";
  String randomSeedNum = "rS" + rSn + "-";
  String dateTime = "" + year() + month() + day();
  String fileType = ".tif";
  String fileName = outputDir + sketchName + randomSeedNum + dateTime;
  saveFrame(fileName+"-#####"+fileType);
  // println("Screen shot taken and saved to " + fileName);
}