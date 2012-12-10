//import processing.opengl.*;

// add in moviemaker

//Declare Globals
int rSn; // randomSeed number. put into var so can be saved in file name. defaults to 47
float PHI = 0.618033989;
PFont font;

ArrayList<Tweet> tweets = new ArrayList();
String[] keywords;
String[] accts;

Calendar oldestTweetM, newestTweetM;

boolean recording = true;

void setup() {
  background(255);
  size(1920, 1080, P3D);
  // size(1900, 1060, OPENGL);
  // size(1200, 700, OPENGL);
  // size(1200, 700, P3D);
  rSn = 47; // 18, 29, 76
  randomSeed(rSn);
  font = createFont("Helvetica", 24);  //requires a font file in the data folder
  textFont(font);
  // smooth(8);
  noStroke();

  keywords = loadStrings("data/keywords.csv");
  accts =    loadStrings("data/accts.csv");

    loadTweets("tweets.csv");
  //loadTweets("tweetsSmall.csv");
  //loadTweets("tweetsTiny.csv");
    newestTweetM = newestTweet(tweets);
  println("newest Time: " + newestTweetM.getTime());
  oldestTweetM = oldestTweet(tweets);
  println("oldest Time: " + oldestTweetM.getTime());

    float secondsInADay = 1.0*24*60*60*1000;
  for (Tweet ctw : tweets){
    // float crat = ctw.created_at.getTimeInMillis();
    ctw.targLoc.x = map(ctw.created_at.getTimeInMillis(), newestTweetM.getTimeInMillis(), oldestTweetM.getTimeInMillis(), 0.0, float(width)-250);
    float secOffset = ctw.created_at.getTimeInMillis() % secondsInADay;
    ctw.targLoc.y = map( secOffset, 0.0, secondsInADay, 0.0, float(height));
    // ctw.targLoc.y =  random(height);
    ctw.targLoc.z = 0;

    //ctw.loc.x = ctw.targLoc.x;
    //ctw.loc.y = ctw.targLoc.y;
    //ctw.loc.z = ctw.targLoc.z;

    // println(secOffset/1000/60/60 + " : " + ctw.targLoc + " : " + ctw.created_at.getTime());
  }
  // initWords();
  // noLoop();
}

void draw() {
 background(0);
 renderChart();
 if(recording) screenCapMov();
}

void loadTweets(String _fn) {
  int rowCount = 0;
  String[] data = loadStrings(_fn);

  for (int i = 1; i<data.length; i++){
    String[] pieces = split(data[i], TAB);

    Tweet tw = new Tweet();
    // tw.loc = new PVector(random(50,width-100), random(100, height-100), random(100, 1000));
    // tw.targLoc = new PVector(50+random(width-100), 50+random(height-100), 0);
    tw.sz = 15.0;
    tw.clr = color(255, 255, 255,1);

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

    tw.loc.x = random(width);
    tw.loc.y = random(height);
    tw.loc.z = 0;



    tweets.add(tw);
    rowCount++;
  }

  println("rowCount: " + rowCount);
}



Calendar oldestTweet(ArrayList<Tweet> tw){
  Calendar oldestCal = Calendar.getInstance();
  oldestCal.setTimeInMillis(-Long.MAX_VALUE); // looking for a future date so init to the past
  for(Tweet ctw : tw){
     if(ctw.created_at.after(oldestCal)){
       oldestCal = ctw.created_at;
     }
  }
  return oldestCal;
}


Calendar newestTweet(ArrayList<Tweet> tw){
  Calendar newestCal = Calendar.getInstance();
  newestCal.setTimeInMillis(Long.MAX_VALUE); // looking for a past date so init to the future
  for(Tweet ctw : tw){
     if(ctw.created_at.before(newestCal)){
       newestCal = ctw.created_at;
     }
  }
  return newestCal;
}


void renderChart() {
 for(Tweet tw : tweets){
  tw.update();
  tw.render();
}
  // draw axis
  // draw data
  // draw titles
}

Calendar getCal(String ds){ // ds = dateString
  // 0123456789012345678
  // 2012-11-23 00:00:09
  // println("ds = " + ds);
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




























void keyPressed() {
  if (key == 'S') screenCap();
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


