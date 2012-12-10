import processing.opengl.*;

//Declare Globals
int rSn; // randomSeed number. put into var so can be saved in file name. defaults to 47
float PHI = 0.618033989;
PFont font;

ArrayList<Tweet> tweets = new ArrayList();
String[] keywords;
String[] accts;


int wordCount;
int wordWidth;
float wordSize;
float yRange;


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
  
  wordCount = 0;
  wordWidth = 15;
  wordSize = wordWidth - 1;


  initWords();
  yRange = ((wordCount * wordWidth) / width) * wordWidth - height; 
  println("wordCount: "+wordCount);
  println("yRange: "+yRange+height);


  // noLoop();
}

void draw() {
 background(255);
 // translate(0, map(mouseY, 0, height, 0, -yRange));
 for(Tweet tw : tweets){
  for(Word w : tw.words){
    w.update();
    w.render();
  }
}

/* 
PVector mLocation = new PVector(mouseX, mouseY);
Word cw = findNearest(mLocation);
fill(0);
text(cw.wordText, cw.loc.x,cw.loc.y+wordWidth);
text(mLocation.x + ", " + mLocation.y, 100,100);
*/

  // renderChart();
}

void loadTweets(String _fn) {
  int rowCount = 0;
  String[] data = loadStrings(_fn);
  ArrayList<Word> words = new ArrayList();

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
    tw.user_id =            int(pieces[3]);
    tw.screen_name =        pieces[4];
    tw.name =               pieces[5];
    tw.profile_image_url =  pieces[6];
    tw.words = getWords(tw.tweet_text);

    tweets.add(tw);
    rowCount++;
  }
  println("rowCount: " + rowCount);
  
}

void initWords(){
  for(Tweet tw : tweets){
    for(Word w : tw.words){
      w.loc.x = random(width/2)+(width/4);
      w.loc.y = random(height/2)+(height/2);
      w.targLoc.x = ((wordCount * wordWidth) % width);
      w.targLoc.y = ((wordCount * wordWidth) / width) * wordWidth;
      wordCount++;
    }
    wordCount=wordCount+2;
  }
}

Word findNearest(PVector mLoc){ // mouse Location
  Word cw = new Word(); // var to hold the closest word and eventually return at end
  float minDist = MAX_INT; // int to a very large value
  for(Tweet tw : tweets){
    for(Word w : tw.words){
      float currDist = dist(mLoc.x, mLoc.y, w.loc.x, w.loc.y);
      if(currDist < minDist){
        minDist = currDist;
        cw = w;
      }
    }
  }
  return cw;
}


ArrayList<Word> getWords(String tw_txt){
  String[] words = split(tw_txt, " ");
  ArrayList<Word> wrds = new ArrayList();

  for(String w : words){
    Word currWord = new Word();
    currWord.wordText = w;
    currWord.sz = 14;
    currWord.clr = setWordClr(w);
    wrds.add(currWord);
  }
  return wrds;
}

color setWordClr(String word){
  color wordClr = color(222,222,222); // default clr;

  if(word.indexOf("#") == 0){
    wordClr = color(0,0,150);
  }

  if(word.indexOf("@") == 0){
    wordClr = color(0,75,150);
  }

  for(String k : keywords){
    if(word.equals(k)){
      wordClr = color(0,0,100);
    }
  }

  if(word.equals("cbc") || word.equals("CBC") || word.equals("#CBC") || word.equals("#cbc")){
    wordClr = color(255,0,0);
  }

  for(String a : accts){
    if(word.equals(a)){
      wordClr = color(0,0,255);
    }
  }
  return wordClr;
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
  String sketchName = "tweetExplorerTextLayout-";
  String randomSeedNum = "rS" + rSn + "-";
  String dateTime = "" + year() + month() + day() + hour() + second();
  String fileType = ".tif";
  String fileName = outputDir + sketchName + randomSeedNum + dateTime + fileType;
  save(fileName);
  println("Screen shot taken and saved to " + fileName);
}





// Notes
    /*
    convert the created_at cal to a date
    map the value of the date to a range between 0 and TWO_PI*days
    2 days = TWO_PI * 2
    The input range should be the min epoch date to the max epoch date (24hrs?)
    just get the the time day? midnight = 0, 23:59 = 86400 seconds?
    time of day would mean that it wouldn't work for an extruded side view of multiple days
    */

