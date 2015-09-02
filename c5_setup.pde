
CallbackListener cb;
Slider s1, s2;

void c5_setup() {

  // see Gui.pde in testjavaemotic for reference
  float x = 10, y=10;
  c5.setColorBackground(d2).setColorForeground(m2).setColorActive(h2); // add .setFont(font); whith a 10 pix font
  c5.setFont(c5font, 10);

  s1 = c5.addSlider("Z")
    .setPosition(width-120, height-550)
      .setSize(10, 200)
        .setRange(0.1, 50)
          .setValue(10.0)
            .setCaptionLabel("Z")
              .setColorCaptionLabel(m2)
                .setColorValueLabel(m2)
                  .setColorForeground(h2)
                    .setColorBackground(m2)
                      .setColorActive(d2);

  s1.addCallback( new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_RELEASED):
        case(ControlP5.ACTION_RELEASEDOUTSIDE):
        // println(Z);
        rebuildPoly(polyLines, vectors, Z);
        break;
      }
    }
  }
  );
  s2 = c5.addSlider("eRate")
    .setPosition(width-170, height-550)
      .setSize(10, 200)
        .setRange(0.01, 1)
          .setValue(eRate)
            .setCaptionLabel("E rate")
              .setColorCaptionLabel(m2)
                .setColorValueLabel(m2)
                  .setColorForeground(h2)
                    .setColorBackground(m2)
                      .setColorActive(d2);

  c5.addButton("GCode")
    .setPosition(width-185, height-295)
      .setSize(100, 100)
        .setView(new CircularButton());

  c5.addButton("screenshot")
    .setPosition(width-110, height-190)
      .setSize(60, 60)
        .setCaptionLabel("img")
          .setView(new CircularButton());

  c5.addButton("res")
    .setPosition(width-210, height-200)
      .setSize(40, 40)
        .setCaptionLabel("file")
          .setView(new CircularButton());

  c5.addToggle("custZ")
    .setPosition(width-170, height-170)
      .setSize(40, 40)
        .setCaptionLabel("cZ")
          .setValue(custZ)
              .setView(new CircularToggle());

  c5.getController("GCode")
    .getCaptionLabel()
      .setSize(20);

  c5.getController("screenshot")
    .getCaptionLabel()
      .setSize(14);

  //...................... global c5 Callback

  /*
  // the following CallbackListener will listen to any controlP5 
   // action such as enter, leave, pressed, released, releasedoutside, broadcast
   // see static variables starting with ACTION_ inside class controlP5.ControlP5Constants
   
   cb = new CallbackListener() {
   public void controlEvent(CallbackEvent theEvent) {
   switch(theEvent.getAction()) {
   case(ControlP5.ACTION_ENTER):
   break;
   case(ControlP5.ACTION_RELEASED):
   case(ControlP5.ACTION_RELEASEDOUTSIDE):
   println(Z);
   break;
   }
   }
   };    
   c5.addCallback(cb);
   */
}


public void screenshot(int theValue) {
  // println("a button event from stop: "+theValue);
  saveImg();
  iCount=0;
}

public void GCode(int theValue) {
  //println("a button event from export: "+theValue);
  exportGCode(custZ?polyLines:pOrig, vectors, eRate, f, fileName);
  gCount=0;
}

public void res(int theValue) {
  reset();
}

public void custZ(boolean theFlag) {
  custZ=theFlag;
  s1.setLock(!custZ);
  s1.setColorBackground(custZ? m2: color(200));
  if (custZ) rebuildPoly(polyLines, vectors, Z);
}

// custom button appearance (round) - see ControlP5CustomView.pde in the ControlP5 examples

class CircularButton implements ControllerView<Button> {

  public void display(PApplet theApplet, Button theButton) {
    theApplet.pushMatrix();
    //theApplet.ellipseMode(CENTER);
    if (theButton.isInside()) {
      if (theButton.isPressed()) { // button is pressed
        theApplet.fill(h2);
      } else { // mouse hovers the button
        theApplet.fill(d2);
      }
    } else { // the mouse is located outside the button area
      theApplet.fill(m2);
    }

    // center the caption label 
    int x = theButton.getWidth()/2 - theButton.getCaptionLabel().getWidth()/2;
    //int y = theButton.getCaptionLabel().getHeight();
    int y = theButton.getHeight()/2 - theButton.getCaptionLabel().getHeight()/2;

    theApplet.ellipse(0, 0, theButton.getWidth(), theButton.getHeight());
    //theButton.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM);
    theApplet.translate(x, y);
    theButton.getCaptionLabel().draw(theApplet);

    theApplet.popMatrix();
  }
}

class CircularToggle implements ControllerView<Toggle> {

  public void display(PApplet theApplet, Toggle theToggle) {
    theApplet.pushMatrix();
    //theApplet.ellipseMode(CENTER);
    if (theToggle.getValue()==0) { // toggle is false (inactive)
      theApplet.fill(mg);
    } else { // the mouse is located outside the toggle area
      theApplet.fill(d2);
    }

    if (theToggle.isInside()) {
      // mouse hovers the button
      theApplet.fill(d3);
    }

    // center the caption label 
    int x = theToggle.getWidth()/2 - theToggle.getCaptionLabel().getWidth()/2;
    //int y = theToggle.getCaptionLabel().getHeight();
    int y = theToggle.getHeight()/2 - theToggle.getCaptionLabel().getHeight()/2;

    theApplet.ellipse(0, 0, theToggle.getWidth(), theToggle.getHeight());
    //theButton.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM);
    theApplet.translate(x, y);
    theToggle.getCaptionLabel().draw(theApplet);

    theApplet.popMatrix();
  }
}
