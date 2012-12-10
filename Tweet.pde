
class Tweet {
  PVector loc;
  PVector targLoc;

  float sz;
  color clr;

  // twitter data
  int tweet_id;
  String tweet_text;
  Calendar created_at;
  // float timeInMillis; // starting out with this as a float to avoid problems with map()
  int timeInMillis;
  int user_id;
  String screen_name;
  String name;
  String profile_image_url;

  // ArrayList<Word> words;

  void update(){
    loc.x += (targLoc.x - loc.x) * .1;
    loc.y += (targLoc.y - loc.y) * .1;
    loc.z += (targLoc.z - loc.z) * .1;

/*
    if(dist(mouseX, mouseY, loc.x,loc.y) < 50){
      //sz = 10;
      targLoc.z = 50;
      }else{
        targLoc.z = 0;
      }
      */
    }
    void render(){
      pushMatrix();
      translate(loc.x, loc.y, loc.z);
      fill(clr);
      noStroke();
      rect(0,0,sz*pow(1+PHI, 7),sz);
      ellipse(0,0,sz, sz);
      fill(255,255,255,10);
      textSize(12);
      text(tweet_text, 0, 0);
      popMatrix();

    }
  }
