import processing.opengl.*;

//Declare Globals
int rSn; // randomSeed number. put into var so can be saved in file name. defaults to 47
float PHI = 0.618033989;
PFont font;

ArrayList<Tweet> tweets = new ArrayList();
String[] keywords;
String[] accts;

long oldestTweetM, newestTweetM;






void setup() {
  background(255);
  // size(1900, 1060, OPENGL);
  size(1200, 700, OPENGL);
  // size(1200, 700, P3D);
  rSn = 47; // 18, 29, 76
  randomSeed(rSn);
  font = createFont("Helvetica", 24);  //requires a font file in the data folder
  textFont(font);
  // smooth(8);
  noStroke();

  keywords = loadStrings("data/keywords.csv");
  accts =    loadStrings("data/accts.csv");

  // loadTweets("tweets.csv");
  loadTweets("tweetsSmall.csv");
  
newestTweetM = newestTweet(tweets);
oldestTweetM = oldestTweet(tweets);
  


  // initWords();


  // noLoop();
}

void draw() {
 background(255);
 renderChart();
}

void loadTweets(String _fn) {
  int rowCount = 0;
  String[] data = loadStrings(_fn);

  for (int i = 1; i<data.length; i++){
    String[] pieces = split(data[i], TAB);

    Tweet tw = new Tweet();
    // tw.loc = new PVector(random(50,width-100), random(100, height-100), random(100, 1000));
    // tw.targLoc = new PVector(50+random(width-100), 50+random(height-100), 0);
    tw.sz = 5.0;
    tw.clr = color(random(100,255));

    // tweet_id tweet_text  created_at  user_id screen_name name  profile_image_url
    tw.tweet_id =           int(pieces[0]);
    tw.tweet_text =         pieces[1];
    tw.created_at =         getCal(pieces[2]);
    tw.timeInMillis =       tw.created_at.getTimeInMillis();
    tw.user_id =            int(pieces[3]);
    tw.screen_name =        pieces[4];
    tw.name =               pieces[5];
    tw.profile_image_url =  pieces[6];

    tw.loc = new PVector();
    tw.targLoc = new PVector();

    tw.loc.x = random(width);
    tw.loc.y = random(height);
    tw.loc.z = 0;

    tw.targLoc.x = map(tw.created_at, 0, width, oldestTweetM, newestTweetM);
    tw.targLoc.y = random(height);
    tw.targLoc.z = 0;


    tweets.add(tw);
    rowCount++;
  }
  println("rowCount: " + rowCount);
}

long oldestTweet(ArrayList<Tweet> tw){
  long oldestTime = MAX_INT;

  for(Tweet ctw : tw){
    if(ctw.timeInMillis < oldestTime){
      oldestTime = ctw.timeInMillis;
    }
  }
  return oldestTime;
}

long newestTweet(ArrayList<Tweet> tw){
  long newestTime = MIN_INT;

  for(Tweet ctw : tw){
    if(ctw.timeInMillis > newestTime){
      newestTime = ctw.timeInMillis;
    }
  }
  return newestTime;
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
  int mon = int(ds.substring(5,7));
  int dy = int(ds.substring(8,10));
  int hr =  int(ds.substring(11,13));
  int minu =  int(ds.substring(14,16));
  int sec =  int(ds.substring(17,19));

  Calendar cal = Calendar.getInstance();
  cal.set(yr, mon, dy, hr, minu, sec);
  return cal;
}




























void keyPressed() {
  if (key == 'S') screenCap();
}

void screenCap() {
  // save functionality in here
  String outputDir = "out/";
  String sketchName = "tweetExplorerTimeLayout-";
  String randomSeedNum = "rS" + rSn + "-";
  String dateTime = "" + year() + month() + day() + hour() + second();
  String fileType = ".tif";
  String fileName = outputDir + sketchName + randomSeedNum + dateTime + fileType;
  save(fileName);
  println("Screen shot taken and saved to " + fileName);
}


