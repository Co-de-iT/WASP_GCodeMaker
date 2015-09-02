
// this aligns the drawing plane with the current camera view
// put in between a pushMatrix() and popMatrix()
// to draw something at a specific point, call a translate(x,y,z)
// before this function

void alignToView(PeasyCam cam) {

  float[] cRot = cam.getRotations();
  rotateX(cRot[0]);
  rotateY(cRot[1]);
  rotateZ(cRot[2]);
}


void saveImg() {
  saveFrame(outPath+"/imgs/"+this.getClass().getName()+"_#####.png");
  println("screenshot saved");
}

// creates a vector shape
PShape vect(float len) {
  PShape v= createShape(GROUP);
  pushStyle();
  noFill();
  PShape l = createShape();
  PShape tip = createShape();

  l.beginShape();
  l.vertex(0, 0);
  l.vertex(len, 0);
  l.vertex(len, 0);
  l.endShape();

  tip.beginShape();
  tip.vertex(len-7, 5);
  tip.vertex(len, 0);
  tip.vertex(len-7, -5);
  tip.endShape();

  v.addChild(l);
  v.addChild(tip);

  popStyle();
  return v;
}


// creates a gradient with more than 2 colors

color lerpGradient(color[] colors, float amt) {
  color c = color(0);
  float stepSize = 100.0/(colors.length-1);
  float loc = (amt*100.0);
  for (int i=0; i< colors.length-1; i++) {
    if (loc < stepSize*(i+1)) {
      float am = (loc % stepSize)/stepSize;
      c = lerpColor(colors[i], colors[i+1], am);
      break;
    }
  }
  return c;
}


// calculates the distance squared (faster than distance since it doesn't perform square root operations)

float distanceSq(float x1, float y1, float x2, float y2) {

  return(pow(x2-x1, 2)+pow(y2-y1, 2));
}

// checks if mouse is within a threshold from a target

boolean mouseOver(PVector loc, float thres) {

  return distanceSq(loc.x, loc.y, mouseX, mouseY) < thres*thres;
}

// finds the director angle (angle with direction referred to x axis as angle 0, sign is CCW + | CW -)
// returns the angle of p2 relative to p1
float dirAng(PVector p1, PVector p2) {
  float angD = 0;
  p1.normalize();
  p2.normalize();
  float aD = atan2(p1.y, p1.x);

  p2.rotate(-aD);

  angD = atan2(p2.y, p2.x);
  return angD;
}
