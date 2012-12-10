class Word{
  PVector loc;
  PVector targLoc;
  float sz;
  color clr;
  String wordText;

  Word(){
    loc = new PVector();
    targLoc = new PVector();
  }

  void update(){
    loc.x += (targLoc.x - loc.x) * .15;
    loc.y += (targLoc.y - loc.y) * .15;
  }

  void render(){
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

  boolean rolloverTest(){
    boolean rolloverState = false;
    if(loc.x < mouseX && loc.x + sz > mouseX){
      if(loc.y < mouseY && loc.y + sz > mouseY){
        rolloverState = true;
      }      
    }
    return rolloverState;
  }

  void renderWordCard(){
    fill(255);
    rect(0,sz,100,sz*2);
    fill(0);
      text(wordText, sz,sz*pow(1/PHI, 2));
  }
}

