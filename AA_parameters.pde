/*
____________________________________________________________________________________________________________________________________
 #.:. PARAMETERS
 
 These are parameters for gCode sequence and file names
 
 ______________________________
 
 . user parameters
 
 */
public String dataPath = "dxf_data/";
public String fileName = "metaball_tolerance.dxf"; // put filename and extension of the file to load here - try also: "test_curve.dxf" or "Z-correct.dxf"
public String outPath = System.getProperty("user.home") + "/Desktop/"+this.getClass().getName();
public String gStart = "gStart.txt";  // start sequence for the gCode (file .txt)
public String gEnd =   "gEnd.txt";      // end sequence for the gCode (file .txt)

/*
______________________________
 
 . gCode & machine parameters
 
 */
public int round=3; // number of precision digits for gCode
public float eRate = 0.19; // extrusion rate (E)
public int[] f = { 6000, 4500 }; // Feed rate (F), first value for G0, second for G1 movements
public float[] mVol = {400,250,200}; // machine printing volume (x,y,z) in mm

/*

 . color charts
 
 */

// color chart
color bg = color(221);

// WASP scale

 color d1= #003580;
 color d2= #245fa7;
 color d3 = #5B9CE8;
 color m2 = #000000;
 color mg = #444444;
 color h2 = #cdcdcd;
 color hh = #ffffff;
 
 color grad[] = {m2,mg,d1,d2,d3};

/*
// scale 2 - reds
color d2 = color(230, 44, 33);
color d3 = color(242,134,113);
color m2 = color(0, 0, 0);
color mg = color(120);
color h2 = color(200, 200, 200);
color hh = color(255);

color grad[] = {m2,mg,d2,d3};
*/

// ________________________________________________________________________________________________________________________________________________________
// CONSTANTS (DO NOT ALTER THESE VALUES)
public static String EOL = System.getProperty("line.separator"); // line separator character
