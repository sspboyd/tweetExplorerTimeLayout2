class Tweet {
  PVector loc;
  PVector targLoc;

  float sz;
  color clr;

  // twitter data
  int tweet_id;
  String tweet_text;
  Calendar created_at;
  int timeInMillis;
  int user_id;
  String screen_name;
  String name;
  String profile_image_url;

  // ArrayList<Word> words;

  void update(){
    loc.x += (targLoc.x - loc.x) * PHI;
    loc.y += (targLoc.y - loc.y) * PHI;
    // loc.z += (targLoc.z - loc.z) * PHI;
  }

  void render(){
    pushMatrix();
      // translate(loc.x, loc.y, loc.z);
      translate(loc.x, loc.y);
      fill(clr);
      noStroke();
      /*
      if(dist(mouseX, mouseY, loc.x, loc.y) < 2){
        fill(255,0,0,200);
        println("red!");
      }else{
        fill(clr);
      }
      */
      text(tweet_text, 0, 0);
    popMatrix();
    }
  }
