//..................................ControlP5 to select file

void c5SelFile(ControlP5 cpSel, String[] s) {
  ListBox l;

  l = cpSel.addListBox("custData_folder")
    .setPosition(width*.5-150, height*.5+10)
      .setSize(300, 150)
        .setItemHeight(15)
          .setBarHeight(20)
            .setColorBackground(color(0, 1))
              .setColorActive(color(red(d2), green(d2), blue(d2), 200))
                .setColorForeground(color(red(d3), green(d3), blue(d3), 80));

  l.setCaptionLabel("choose a file");
  l.getCaptionLabel().toUpperCase(true);
  l.getCaptionLabel().setSize(10);
  l.getCaptionLabel().setColor(m2);
  l.getCaptionLabel().setPaddingY(3);
  l.getValueLabel().setPaddingY(3);

  color c;
  for (int i=0; i<s.length; i++) {
    c = color(map((float)i, 0, s.length, 0, 200));
    l.addItem(s[i], i);
    l.getItem(i).setColorLabel(c); // set color of label for each element in the folder
    //l.getItem(i).setColorBackground(0xffff0000);
  }
}


//..................................when the file is choosen: start the sketch!
void controlEvent(ControlEvent theEvent) {
  int id;
  if (chooseFile) {  
    if (theEvent.isGroup()) {
      id = (int) theEvent.getGroup().getValue();// << theEvent.group() return an integer related to the list items array [int] 
      println(s[id]); // this is the filename from the directory
      println(id+" from "+theEvent.getGroup());
      if (s[id].endsWith(".dxf") || s[id].endsWith(".DXF")) {
        println("excellent choice, Sir, fits your exquisite taste.");
        fileName = s[id]; 
        initFromFile(curve, mVol);
        chooseFile = false;
      }
      // insert more actions here if needed be..... or call a file load function
    }
  }
}


//...................................reset function to go back to file choice
void reset() {
  chooseFile = true;
}
