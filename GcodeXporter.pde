/*

 GCode exporter
 
 .:. steps:
 
 x. open file writer
 
 . write initialisation sequence
 
 . for each angle in the array:
 
 . push by vector length (send rotation command to stepper motors)
 . if angle changes sign > change direction
 . rotate pin by given angle
 . stop stepper motors
 
 . push by last vector
 
 . ending sequence
 
 x. close file writer
 
 */

void exportGCode(PVector[][][] pts, PVector[][][] vecs, float eRate, int[] f, String fileName) {

  //
  // ____________________________________________________ INITIALISE OUTPUT ______________________________________
  //

  // initialise variables
  //String filePath = dataPath(this.getClass().getName()+"_gcode/"+this.getClass().getName()+"_"+fileName+".g");
  String filePath = outPath+"/gCode/"+this.getClass().getName()+"_"+fileName+".g";
  float eTot=0; // the incremental value of E goes here
  // creates output & writes data
  PrintWriter output;   //Declare the PrintWriter
  output = createWriter(filePath);   //Create a new PrintWriter object

  //
  // _____________________________________________________ START SEQUENCE ________________________________________
  //

  output.println(gcodeStart()); // Writes the Gcode start sequence

  //
  // _____________________________________________________ POLYLINE VERTICES ________________________________________
  //

  String sE, sF;
  for (int i=0; i< pts.length; i++) {
    output.println("; ________ LAYER " + str(i));
    for (int j=0; j< pts[i].length; j++) {
      output.println("; ___ POLYLINE " + str(j));
      output.println("G0 " + "F" + str(f[0]) + " X"+ nfc(pts[i][j][0].x, round) + " Y"+ nfc(pts[i][j][0].y, round)+ " Z"+ nfc(pts[i][j][0].z, round));
      for (int k=1; k< pts[i][j].length; k++) {
        eTot+= vecs[i][j][k-1].mag()*eRate;
        // sE = " E" + nfc(vecs[i][j][k-1].mag()*eRate, round); // OLD - E is not incremental!!
        // sE = " E" + nfc(eTot, round); // NOT GOOD - adds a comma after thousands which makes GCode unreadable
        sE = " E" + String.format("%.3f", eTot);
        sF = k==1? "F"+str(f[1]):"";
        output.println("G1 " + sF + " X"+ nfc(pts[i][j][k].x, round) + " Y"+ nfc(pts[i][j][k].y, round)+ " Z"+ nfc(pts[i][j][k].z, round) + sE);
      }
    }
  }

  //
  // ____________________________________________________ FINISH SEQUENCE ________________________________________
  //

  output.println(gcodeFinish()); // Writes the Gcode finish sequence

  output.flush();  //Write the remaining data to the file
  output.close();  //Finishes the files


  println("G-code Saved");
}

//
// ____________________________________________________ GCODE START & FINISH SEQUENCE ________________________________________
//

String gcodeStart() {

  String pts="";
  String[] gS;

  gS = loadStrings(gStart);

  pts+= "; GCod exporter for WASP" + EOL;
  pts+= "; project by Co-de-iT + WASP 2015" + EOL;
  pts+= "; G-code generation & program interface by Alessio Erioli | Co-de-iT" + EOL;
  pts+= ";" + EOL;
  pts+= EOL;

  for (int i=0; i< gS.length; i++) {
    pts += gS[i] + EOL;
  }

  pts+= "; end of startup sequence" + EOL;
  pts+= EOL;

  return pts;
}


String gcodeFinish() {

  String pts="";
  String[] gE;

  gE = loadStrings(gEnd);

  pts+= ";" + EOL;
  pts+= "; begin end sequence" + EOL;
  pts+= ";" + EOL;

  for (int i=0; i< gE.length; i++) {
    pts += gE[i] + EOL;
  }

  return pts;
}
