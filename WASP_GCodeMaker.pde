/*

 WASP GCode exporter from DXF
 
 NOTES: see README.md
 
 
 */

import javax.swing.*; 
import controlP5.*;
import peasy.*;


// create a file chooser 
final JFileChooser fc = new JFileChooser(); 

// in response to a button click: 
int returnVal;

// custom 2D camera + PEasyCam
DDCam cam2D;
PeasyCam cam;

// GUI (Graphic User Interfaces)
ControlP5 c5, cpSel;

String[][] curve;
String[] s;
PVector[] polyLine, vecs, bounds;
PVector[][][] polyLines, pOrig;
PVector[][][] vectors;
float inZ, Z;
float gCount = -1, iCount=-1;
PShape py, v;
PImage logoC, logoW, logoCT, logoWT, logoU;
boolean dispSw = false, dispG0lines=false, deg=true, chooseFile=true, custZ=false, fastFile = true;
PFont font, c5font;
int currInd = 0, nPolyLines, nLayers; 


void setup() {

  //size(1200, 800, P3D);
  size(displayWidth-20, displayHeight-40, P3D);
  smooth(4);
  cursor(CROSS);
  ellipseMode(CENTER);

  // set system look and feel 
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } 
  catch (Exception e) { 
    e.printStackTrace();
  } 
  // font creation
  font = createFont("Lekton04-Thin", 14);
  c5font = createFont("Lekton04-Thin", 14);
  textFont(font);
  
  // logos
  logoC = loadImage("co-de-it_logo_b.png");
  logoW = loadImage("logowasp.png");
  logoCT = loadImage("co-de-it_logo_b_t.png");
  logoWT = loadImage("logowasp_t.png");
  logoU = loadImage("logosUnited.png");

  // load data path
  String Path = sketchPath(dataPath);
  Path = Path.replace('\\', '/');

  // loads directory files in String[] s
  File dirToOpen = new File(Path); 
  s = dirToOpen.list();  //


  // initialize GUI
  c5 = new ControlP5(this);
  c5.setAutoDraw(false);
  c5_setup();
  
  // defines new interface with list box
  cpSel = new ControlP5(this);
  cpSel.setAutoDraw(false);
  c5SelFile(cpSel, s); // defines listbox for file choice
  
  // initialize camera
  cam = new PeasyCam(this, mVol[0]*.5, mVol[1]*.5, 0, 400);
  // defines perspective, aspect ratio, near clip and far clip
  perspective(PI/3.0, float(width)/float(height), 0.001, 10000);
}


void draw() {
  background(bg);
  textSize(3);
  if (chooseFile) {
    cam.beginHUD();
    imageMode(CENTER);
    image(logoU, width*.5, height*.5-(logoU.height+10));
    if (!fastFile) {
      // file selection happens in cSelFile tab, in the controlEvent function
      returnVal =  fc.showOpenDialog(this);
    } else {
      cpSel.draw();
    }
    imageMode(CORNER);
    cam.endHUD();
  } else {
    scale(1, -1, 1); // compensate display for y axis inversion
    cam.setActive(!c5.isMouseOver());
    pushStyle();
    rectMode(CORNER);
    noFill();
    stroke(20, 180);
    strokeWeight(2);
    rect(0, 0, mVol[0], -mVol[1]);
    // rectMode(CORNER);
    pushMatrix();
    translate(mVol[0]*.5, -mVol[1]*.5, mVol[2]*.5);
    strokeWeight(0.5);
    box(mVol[0], mVol[1], mVol[2]);
    popMatrix();
    ellipse(0,0,10,10);
    popStyle();
    
    // display vectors with original or custom Z type polylines
    dispVecs(custZ?polyLines:pOrig, vectors);
    
    // displays GUI
    cam.beginHUD();
    gui();
    cam.endHUD();
  }
}



void keyPressed() {
  if (key=='v') dispSw = !dispSw;
  if (key=='g') dispG0lines = !dispG0lines;
  // if (key=='d') deg = !deg;
  // if (key=='+') currInd = ++currInd%angles.length;
  // if (key=='-') currInd = (--currInd+angles.length)%angles.length;
  if (key=='i') saveImg();
  if (key=='e') {
    exportGCode(custZ?polyLines:pOrig, vectors, eRate, f, fileName);
    gCount=0;
  }
  if (key=='r') reset();
}


// uncheck this function for auto-fullscreen mode

boolean sketchFullScreen() {
  return true; // true to force fullscreen
}
