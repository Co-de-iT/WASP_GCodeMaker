//
// _______________________ GENERAL
//

void initFromFile(String[][] curve, float[] mVol) {

  curve = readDXF(dataPath + fileName); // correct this section (file choice must be in the draw section)
  // polyLine = extractPolyLine(curve); // single polyline
  polyLines = extractPolyLines(curve); // polylines by layer
  bounds = getBounds(polyLines); // get boundaries
  centerPolylines(polyLines, bounds, mVol);
  // vecs = createVectors(polyLine); // single polyline vectors
  vectors = createVectors(polyLines); // vectors for layered polylines
  // angles = createAngles(vecs);


  // makes a copy in pOrig
  pOrig = new PVector[polyLines.length][][];
  for (int i=0; i< polyLines.length; i++) {
    pOrig[i] = new PVector[polyLines[i].length][];
    for (int j=0; j< polyLines[i].length; j++) {
      pOrig[i][j] = new PVector[polyLines[i][j].length];
      for (int k=0; k< polyLines[i][j].length; k++) {
        pOrig[i][j][k] = polyLines[i][j][k].get();
      }
    }
  }
}

//
// _______________________ SHAPES
//

PShape makeShape(PVector[] polyline) {
  PShape p;
  stroke(0);
  strokeWeight(1);
  noFill();

  p=createShape();

  p.beginShape();

  for (int i=0; i< polyLine.length; i++) {
    p.vertex(polyLine[i].x, polyLine[i].y, polyLine[i].z);
  }
  p.endShape();

  return p;
}

PShape[] makeShapes(PVector[][][] polylines) {
  PShape[] shapes = new PShape[nPolyLines];

  int ind = 0;
  stroke(0);
  strokeWeight(1);
  noFill();


  for (int i=0; i< polyLines.length; i++) {
    for (int j=0; j< polyLines[i].length; j++) {
      shapes[ind] = createShape();
      shapes[ind].beginShape();
      shapes[ind].stroke(lerpGradient(grad,ind/(float)nPolyLines));
      shapes[ind].strokeWeight(1);
      for (int k=0; k< polylines[i][j].length; k++) {
        shapes[ind].vertex(polyLines[i][j][k].x, polyLines[i][j][k].y, polyLines[i][j][k].z);
      }
      shapes[ind].endShape();
      ind++;
    }
  }

  return shapes;
}

//
// _______________________ VECTORS
//


PVector[] createVectors(PVector[] pts) {
  // vectors are 1 less than points

    PVector[] vecs = new PVector[pts.length-1];

  for (int i=0; i<pts.length-1; i++) {
    vecs[i] = PVector.sub(pts[i], pts[i+1]);
  }

  return vecs;
}

PVector[][][] createVectors(PVector[][][] pts) {
  // vectors are 1 less than points

    PVector[][][] vecs = new PVector[pts.length][][];

  for (int i=0; i<pts.length; i++) {
    vecs[i]= new PVector[pts[i].length][];
    for (int j=0; j< pts[i].length; j++) {
      vecs[i][j] = new PVector[pts[i][j].length-1];
      for (int k=0; k< pts[i][j].length-1; k++) {
        vecs[i][j][k] = PVector.sub(pts[i][j][k], pts[i][j][k+1]);
      }
    }
  }

  return vecs;
}

//
// _______________________ ANGLES (for WireBender)
//


float[] createAngles(PVector[] vecs) {
  // angles are one less than vectors, two less than points

    float[] angs = new float[vecs.length-1];

  for (int i = 0; 	i< vecs.length-1; i++) {
    PVector u = vecs[i].get();
    PVector v = vecs[i+1].get();
    u.normalize();
    v.normalize();
    float angle = dirAng(u, v); // see dirAng notes for explanation
    angs[i]=angle; // the sign is inverted because of machine construction
  }

  return angs;
}

//
// _______________________ BOUNDS
//

PVector[] getBounds(PVector[] pts) {

  PVector[] bds = new PVector[2];

  PVector max = new PVector(-Float.MAX_VALUE, -Float.MAX_VALUE);
  PVector min = new PVector(Float.MAX_VALUE, Float.MAX_VALUE);
  for (int i=0; i< pts.length; i++) {
    if (pts[i].x < min.x) {
      min.x = pts[i].x;
    } else if (pts[i].x > max.x) max.x = pts[i].x;
    if (pts[i].y < min.y) {
      min.y = pts[i].y;
    } else if (pts[i].y > max.y) max.y = pts[i].y;
  }

  bds[0] = min;
  bds[1] = max;

  return bds;
}

PVector[] getBounds(PVector[][][] pts) {

  PVector[] bds = new PVector[2];

  PVector max = new PVector(-Float.MAX_VALUE, -Float.MAX_VALUE, -Float.MAX_VALUE);
  PVector min = new PVector(Float.MAX_VALUE, Float.MAX_VALUE, Float.MAX_VALUE);
  for (int i=0; i< pts.length; i++) {
    for (int j=0; j< pts[i].length; j++) {
      for (int k=0; k< pts[i][j].length; k++) {
        if (pts[i][j][k].x < min.x) {
          min.x = pts[i][j][k].x;
        } else if (pts[i][j][k].x > max.x) max.x = pts[i][j][k].x;
        if (pts[i][j][k].y < min.y) {
          min.y = pts[i][j][k].y;
        } else if (pts[i][j][k].y > max.y) max.y = pts[i][j][k].y;
        if (pts[i][j][k].z < min.z) {
          min.z = pts[i][j][k].z;
        } else if (pts[i][j][k].z > max.z) max.z = pts[i][j][k].z;
      }
    }
  }

  bds[0] = min;
  bds[1] = max;

  return bds;
}


void centerPolylines(PVector[][][] polyLines, PVector[] bounds, float[]mVol) {
  PVector avg = PVector.add(bounds[1], bounds[0]); // average vector to center view
  avg.mult(0.5);
  PVector avg0 = new PVector(avg.x, avg.y, 0); // center of polylines on zero plane
  PVector cen0 = new PVector(mVol[0]*.5, -mVol[1]*.5, 0); // center of volume on zero plane
  PVector move = PVector.sub(cen0, avg0);

  for (int i=0; i< polyLines.length; i++) {
    for (int j=0; j< polyLines[i].length; j++) {
      for (int k=0; k< polyLines[i][j].length; k++) {
        polyLines[i][j][k].add(move);
      }
    }
  }
}
