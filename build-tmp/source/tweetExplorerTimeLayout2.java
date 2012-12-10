import processing.core.*; 
import processing.data.*; 
import processing.opengl.*; 

import processing.opengl.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class tweetExplorerTimeLayout2 extends PApplet {



//Declare Globals
int rSn; // randomSeed number. put into var so can be saved in file name. defaults to 47
float PHI = 0.618033989f;
PFont font;

ArrayList<Tweet> tweets = new ArrayList();
String[] keywords;
String[] accts;

long oldestTweetM, newestTweetM;






public void setup() {
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

public void draw() {
 background(255);
 renderChart();
}

public void loadTweets(String _fn) {
  int rowCount = 0;
  String[] data = loadStrings(_fn);

  for (int i = 1; i<data.length; i++){
    String[] pieces = split(data[i], TAB);

    Tweet tw = new Tweet();
    // tw.loc = new PVector(random(50,width-100), random(100, height-100), random(100, 1000));
    // tw.targLoc = new PVector(50+random(width-100), 50+random(height-100), 0);
    tw.sz = 5.0f;
    tw.clr = color(random(100,255));

    // tweet_id tweet_text  created_at  user_id screen_name name  profile_image_url
    tw.tweet_id =           PApplet.parseInt(pieces[0]);
    tw.tweet_text =         pieces[1];
    tw.created_at =         getCal(pieces[2]);
    tw.timeInMillis =       tw.created_at.getTimeInMillis();
    tw.user_id =            PApplet.parseInt(pieces[3]);
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

public long oldestTweet(ArrayList<Tweet> tw){
  long oldestTime = MAX_INT;

  for(Tweet ctw : tw){
    if(ctw.timeInMillis < oldestTime){
      oldestTime = ctw.timeInMillis;
    }
  }
  return oldestTime;
}

public long newestTweet(ArrayList<Tweet> tw){
  long newestTime = MIN_INT;

  for(Tweet ctw : tw){
    if(ctw.timeInMillis > newestTime){
      newestTime = ctw.timeInMillis;
    }
  }
  return newestTime;
}

public void renderChart() {
 for(Tweet tw : tweets){
  tw.update();
  tw.render();
}
  // draw axis
  // draw data
  // draw titles
}

public Calendar getCal(String ds){ // ds = dateString
  // 0123456789012345678
  // 2012-11-23 00:00:09
  // println("ds = " + ds);
  int yr = PApplet.parseInt(ds.substring(0,4)); 
  int mon = PApplet.parseInt(ds.substring(5,7));
  int dy = PApplet.parseInt(ds.substring(8,10));
  int hr =  PApplet.parseInt(ds.substring(11,13));
  int minu =  PApplet.parseInt(ds.substring(14,16));
  int sec =  PApplet.parseInt(ds.substring(17,19));

  Calendar cal = Calendar.getInstance();
  cal.set(yr, mon, dy, hr, minu, sec);
  return cal;
}




























public void keyPressed() {
  if (key == 'S') screenCap();
}

public void screenCap() {
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



class Tweet {
  PVector loc;
  PVector targLoc;

  float sz;
  int clr;

  // twitter data
  int tweet_id;
  String tweet_text;
  Calendar created_at;
  long timeInMillis;
  int user_id;
  String screen_name;
  String name;
  String profile_image_url;

  // ArrayList<Word> words;

  public void update(){
    loc.x += (targLoc.x - loc.x) * .05f;
    loc.y += (targLoc.y - loc.y) * .05f;
    loc.z += (targLoc.z - loc.z) * .1f;

    if(dist(mouseX, mouseY, loc.x,loc.y) < 50){
      //sz = 10;
      targLoc.z = 50;
      }else{
        targLoc.z = 0;
      }

    }
    public void render(){
      pushMatrix();
      translate(loc.x, loc.y, loc.z);
      fill(clr);
      noStroke();
      ellipse(0,0,sz, sz);
      popMatrix();

    }
  }
class Word{
  PVector loc;
  PVector targLoc;
  float sz;
  int clr;
  String wordText;

  Word(){
    loc = new PVector();
    targLoc = new PVector();
  }

  public void update(){
    loc.x += (targLoc.x - loc.x) * .15f;
    loc.y += (targLoc.y - loc.y) * .15f;
  }

  public void render(){
    pushMatrix();
    translate(loc.x, loc.y);
    fill(clr);
    noStroke();
    rect(0,0, sz, sz);
    //ellipse(0,0,sz, sz);
    if(rolloverTest()){
      fill(0);
      pushMatrix();
        translate(0,0,1);
        renderWordCard();
      popMatrix();
    }
    popMatrix();
  }

  public boolean rolloverTest(){
    boolean rolloverState = false;
    if(loc.x < mouseX && loc.x + sz > mouseX){
      if(loc.y < mouseY && loc.y + sz > mouseY){
        rolloverState = true;
      }      
    }
    return rolloverState;
  }

  public void renderWordCard(){
    fill(255);
    rect(0,sz,100,sz*2);
    fill(0);
      text(wordText, sz,sz*pow(1/PHI, 2));
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "tweetExplorerTimeLayout2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
