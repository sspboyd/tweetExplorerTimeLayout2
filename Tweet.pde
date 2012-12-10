
class Tweet {
  PVector loc;
  PVector targLoc;

  float sz;
  color clr;

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

  void update(){
    loc.x += (targLoc.x - loc.x) * .05;
    loc.y += (targLoc.y - loc.y) * .05;
    loc.z += (targLoc.z - loc.z) * .1;

    if(dist(mouseX, mouseY, loc.x,loc.y) < 50){
      //sz = 10;
      targLoc.z = 50;
      }else{
        targLoc.z = 0;
      }

    }
    void render(){
      pushMatrix();
      translate(loc.x, loc.y, loc.z);
      fill(clr);
      noStroke();
      ellipse(0,0,sz, sz);
      popMatrix();

    }
  }
