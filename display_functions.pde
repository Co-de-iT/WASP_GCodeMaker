/*
void dispVecs(PVector[] pts, PVector[] vecs) {
  pushStyle();

  for (int i=0; i< vecs.length; i++) {
    strokeWeight(1);
    float c = map(i, 0, vecs.length, 0, 255);
    stroke(c, 0, 0);
    PVector p1 = PVector.add(pts[i+1], vecs[i]);
    line (pts[i+1].x, pts[i+1].y, pts[i+1].z, p1.x, p1.y, p1.z);
    strokeWeight(4);
    point(pts[i].x, pts[i].y, pts[i].z);
  }
  point(pts[pts.length-1].x, pts[pts.length-1].y, pts[pts.length-1].z);
  popStyle();
}
*/

void dispVecs(PVector[][][] pts, PVector[][][] vecs) {
  pushStyle();
  color c;
  for (int i=0; i< vecs.length; i++) {
    c = lerpGradient(grad, i/(float) vecs.length);
    stroke(c);
    for (int j=0; j< vecs[i].length; j++) {
      for (int k=0; k< vecs[i][j].length; k++) {
        PVector p1 = PVector.add(pts[i][j][k+1], vecs[i][j][k]);
        strokeWeight(1);
        line (pts[i][j][k+1].x, pts[i][j][k+1].y, pts[i][j][k+1].z, p1.x, p1.y, p1.z);
        strokeWeight(4);
        point(pts[i][j][k].x, pts[i][j][k].y, pts[i][j][k].z);
      }
      strokeWeight(1);
      line (pts[i][j][pts[i][j].length-1].x, pts[i][j][pts[i][j].length-1].y, pts[i][j][pts[i][j].length-1].z, pts[i][j][0].x, pts[i][j][0].y, pts[i][j][0].z);
      strokeWeight(4);
      point(pts[i][j][pts[i][j].length-1].x, pts[i][j][pts[i][j].length-1].y, pts[i][j][pts[i][j].length-1].z);
    }
  }

  popStyle();
}
/*
void dispInd(PVector[] pts) {
  pushStyle();
  blendMode(DARKEST);
  fill(0);
  noStroke();
  for (int i=0; i< pts.length; i++) {
    pushMatrix();
    translate(pts[i].x, pts[i].y, pts[i].z+5);
    text(str(i), 0, 0);
    popMatrix();
  }

  popStyle();
}


void dispCurrInd(PVector[] pts, int i) {
  pushStyle();
  blendMode(DARKEST);
  fill(0);
  noStroke();

  pushMatrix();
  translate(pts[i].x, pts[i].y, pts[i].z+5);
  text(str(i), 0, 0);
  popMatrix();

  popStyle();
}

void dispAng(PVector[] pts, float[] ang, boolean deg) {
  pushStyle();
  blendMode(DARKEST);
  fill(0);
  noStroke();
  for (int i=1; i< pts.length-1; i++) {
    pushMatrix();
    translate(pts[i].x, pts[i].y, pts[i].z+5);
    String a = nf(deg?degrees(ang[i-1]):ang[i-1], 0, 2);
    fill(ang[i-1]<0?color(255, 0, 0):color(0));
    text(a, 0, 0);
    noFill();
    popMatrix();
  }

  popStyle();
}

void dispCurrAng(PVector p, float ang, boolean deg) {
  pushStyle();

  fill(0);
  noStroke();
  pushMatrix();
  translate(p.x, p.y, p.z);
  String a = nf(deg?degrees(ang):ang, 0, 2);
  noFill();
  stroke(0, 120);
  strokeWeight(.5);
  line(1, -1, 10, -10);
  blendMode(DARKEST);
  fill(ang<0?color(255, 0, 0):color(0));
  text(a, 10, -10);

  popMatrix();
  popStyle();
}

void dispCirc(PVector p, float diam) {
  pushStyle();
  blendMode(ADD);
  fill(hh, 180);
  noStroke();
  pushMatrix();
  translate(p.x, p.y, p.z);
  ellipse(0, 0, diam, diam);
  popMatrix();
  popStyle();
}

void dispBendLine(PVector p, PVector v) {
  pushStyle();
  fill(80);
  strokeWeight(.5);
  PVector p1 = PVector.add(p, v);
  line(p.x, p.y, p.z, p1.x, p1.y, p1.z);
  popStyle();
}
*/

void checkOverlap(PVector[] polyline) {
  PVector p;
  for (int i=0; i<polyline.length; i++) {
    p = new PVector(screenX(polyline[i].x, polyline[i].y, polyline[i].z), screenY(polyline[i].x, polyline[i].y, polyline[i].z));
    if (mouseOver(p, 10)) {
      pushStyle();
      fill(255, 80);
      noStroke();
      ellipse(polyline[i].x, polyline[i].y, 10, 10);
      popStyle();
    }
  }
}
