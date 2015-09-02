void gui() {

  pushMatrix();
  textSize(14);
  fill(0);
  float x = width-250;
  float y = height-103;
  float inc = 16, margin = 60;
  textAlign(RIGHT);
  text(fileName, x, y+=inc);
  text("polylines:  "+str(nPolyLines), x, y+=inc);
  text("layers: "+str(nLayers), x, y+=inc);
  // text("angles:  "+str(angles.length), x, y+=inc);
  if (gCount >=0 && gCount <= 150) {
    fill(0, gCount<20?255:map(gCount, 0, 150.0, 255.0, 0));
    text("GCode exported", x, y+=20);
    gCount++;
  }
    if (iCount >=0 && iCount <= 150) {
    fill(0, iCount<20?255:map(iCount, 0, 150.0, 255.0, 0));
    text("screenshot saved", x, y+=20);
    iCount++;
  }

  popMatrix();

  image(logoW, width-(logoW.width+margin), height-110);
  image(logoC, width-(logoW.width+logoC.width+margin+20), height-110);

  c5.draw();
}
