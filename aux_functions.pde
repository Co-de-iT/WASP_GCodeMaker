void rebuildPoly(PVector[][][] polyLines, PVector[][][] vectors, float z) {
float globZ;
  for (int i=0; i< polyLines.length; i++) {
    globZ = z*i;
    for (int j=0; j< polyLines[i].length; j++) {
      for (int k=0; k< polyLines[i][j].length; k++) {
        polyLines[i][j][k].z = globZ;
      }
    }
  }
}
