// as found in: http://processing.org/discourse/beta/num_1142535442.html
// with a few tweaks by me.... ;)

String[][] readDXF(String folderPath) {
  String[][] ent;
  String[] dxf;
  String[] vport;
  String[] entity;
  dxf = loadStrings(folderPath);
  vport = cutSection(dxf, "VPORT", "ENDTAB");
  vport = cutSection(vport, " 12", " 43");
  dxf = cutSection(dxf, "ENTITIES", "ENDSEC");

  int numEntities = 0;
  for (int i = 0; i < dxf.length; i++) {
    if (dxf[i].contains("  0")) {
      dxf[i] = "ENTITY";
      numEntities ++;
    }
  }
  String joindxf;
  joindxf = join(dxf, "~");

  entity = split(joindxf, "ENTITY");
  ent = new String[numEntities + 1][];
  for (int i = 0; i <= numEntities; i++) {
    ent[i] = split(entity[i], "~");
  }
  return ent;
}

//
// ______________________________________________ support functions
//


String[] cutSection(String[] dxfs, String startcut, String endcut) {
  int cutS = -1;
  for (int i = 0; i < dxfs.length; i++) {
    if (dxfs[i].contains(startcut)) {
      cutS = i;
    }
  }
  if (cutS == -1) {
    println("SECTION " + startcut + " NOT FOUND.");
  }
  dxfs = subset(dxfs, cutS + 1);

  int cutF = -1;
  for (int i = 0; i < dxfs.length; i++) {
    if (dxfs[i].contains(endcut)) {
      cutF = i;
      break;
    }
  }
  if (cutF == -1) {
    println("SECTION NOT TERMINATED at " + endcut + ".");
  }
  return subset(dxfs, 0, cutF-1);
}

//
// ______________________________________________ extract functions
//

// extracts polylines
PVector[][][] extractPolyLines(String [][] ent) {
  PVector[][][] polylines;
  ArrayList<PVector[]> polys = new ArrayList<PVector[]>();
  ArrayList<PVector[]> rev = new ArrayList<PVector[]>();
  ArrayList<PVector> pVerts = new ArrayList<PVector>(); // temporarily contains polyline vertices
  PVector[] pVarr, pCon;
  int[] levels = new int[1];
  int j=0, lc=0;
  float x = 0;
  float y = 0;
  float z = 0;
  //
  // ____________________ Phase A: parse polylines from dxf entities string
  //
  for (int i = 1; i < ent.length; i++) {
    if (ent[i][1].contains("POLYLINE")) {
      pVerts.clear();
      // extract vertices as PVectors

      while (ent[++i][1].contains ("VERTEX")) {
        // println(ent[i].length);
        // println(ent[i]);
        j=0;
        while (j<ent[i].length-1) {
          if (ent[i][j].contains("10")) {
            x = float(ent[i][++j]);
            // print("x = ",x);
          } else 
            if (ent[i][j].contains("20")) {
            y = float(ent[i][++j]);
            // print("; y = ",y);
          } else 
            if (ent[i][j].contains("30")) {
            z = float(ent[i][++j]);
            // println("; z = ",z);
          }
          ++j;
        }
        PVector p = new PVector(x, y, z);
        pVerts.add(p);
      }

      // converts pVerts to array (pVarr)   
      pVarr = new PVector[pVerts.size()];
      for (int k=0; k<pVerts.size (); k++) {
        pVarr[k] = pVerts.get(k);
      }
      // adds PVector array to ArrayList of polylines
      polys.add(pVarr);
    }
  }
  println("polylines parsing done");
  println(polys.size(), "polylines");
  
  // reverse polyline order to start with lower polyline first
  for(int i=polys.size()-1; i>=0; i--){
   rev.add(polys.get(i));
   }
  
  polys.clear();
  
  for(int i=0; i<rev.size(); i++){
   polys.add(rev.get(i));
  }
  
  rev.clear();
  
  //
  // ____________________ Phase B: convert ArrayList of PVectors[] (polylines) in full array, divided by Z layers
  //

  // sort number of curves per each level
  pCon = polys.get(0);
  levels[0]=1;
  for (int i=1; i< polys.size (); i++) {
    pVarr = polys.get(i);
    if (pVarr[0].z == pCon[0].z) {
      levels[lc]++;
    } else {
      pCon = polys.get(i);
      if (++lc > levels.length-1) levels = expand(levels, (levels.length+1));
      levels[lc]=1;
      //lp=1; // 1 curve on new level
    }
  }
  println("layers sorting done");
  // puts them in the array
  int ind =0;
  polylines = new PVector[levels.length][][];
  // converts arrayList to Array
  // spans all found polylines
  for (int i=0; i< polylines.length; i++) {
    // gets vector array
    polylines[i] = new PVector[levels[i]][];
    for (j=0; j< levels[i]; j++) {
      polylines[i][j] = polys.get(ind);
      ind++;
    }
  }
  nPolyLines = polys.size();
  nLayers = polylines.length;
  println ( nPolyLines, "polylines on", nLayers, "layers");

  return polylines;
}



// extracts a single polyline
PVector[] extractPolyLine(String [][] ent) {
  PVector[] vertices;
  ArrayList<PVector> verts = new ArrayList<PVector>();
  int j=0;
  float x = 0;
  float y = 0;
  float z = 0;
  for (int i = 1; i < ent.length; i++) {

    if (ent[i][1].contains("POLYLINE")) {

      // extract vertices as PVectors

        while (ent[++i][1].contains ("VERTEX")) {
        // println(ent[i].length);
        // println(ent[i]);
        j=0;
        while (j<ent[i].length-1) {
          if (ent[i][j].contains("10")) {
            x = float(ent[i][++j]);
            // print("x = ",x);
          } else 
            if (ent[i][j].contains("20")) {
            y = float(ent[i][++j]);
            // print("; y = ",y);
          } else 
            if (ent[i][j].contains("30")) {
            z = float(ent[i][++j]);
            // println("; z = ",z);
          }
          ++j;
        }
        PVector p = new PVector(x, y, z);
        verts.add(p);
      }
    }
  }
  vertices = new PVector[verts.size()];
  //vertices = verts.toArray();
  // converts arrayList to Array
  for (int i=0; i< vertices.length; i++) {
    vertices[(vertices.length-1) - i] = verts.get(i); // reverse order of vertices so to start from the lowest one
  }

  return vertices;
}

//
// ______________________________________________ display functions
//


void drawDXF(String[][] ent) {
  noFill();
  ellipseMode(CENTER);

  for (int i = 1; i < ent.length; i++) {
    if (ent[i][1].contains("LINE")) {
      if (ent[i][5].contains("HID")) {
        stroke(0, 200, 0);
      } else {
        stroke(255);
      }
      line(float(ent[i][7]), -float(ent[i][9]), float(ent[i][13]), -float(ent[i][15]));
    }
    if (ent[i][1].contains("ARC")) {
      float SA, EA;
      SA = 360 - float(ent[i][17]);
      EA = 360 - float(ent[i][15]);
      if (SA > EA) {
        EA += 360;
      }

      if (ent[i][5].contains("HID")) {
        stroke(0, 200, 0);
      } else {
        stroke(255);
      }
      arc(float(ent[i][7]), -float(ent[i][9]), 2*float(ent[i][13]), 2*float(ent[i][13]), radians(SA), radians(EA));
    }
    if (ent[i][1].contains("CIRCLE")) {
      if (ent[i][5].contains("HID")) {
        stroke(0, 200, 0);
      } else {
        stroke(255);
      }
      ellipse(float(ent[i][7]), -float(ent[i][9]), 2*float(ent[i][13]), 2*float(ent[i][13]));
    }
    if (ent[i][1].contains("POLYLINE")) {
      if (ent[i][5].contains("HID")) {
        stroke(0, 200, 0);
      } else {
        stroke(0);
        strokeWeight(1);
      }
      // draw polyline as shape
      beginShape();
      while (ent[++i][1].contains ("VERTEX")) {
        vertex(float(ent[i][15]), float(ent[i][17]), float(ent[i][19]));
      }
      endShape();
    }
  }
}
