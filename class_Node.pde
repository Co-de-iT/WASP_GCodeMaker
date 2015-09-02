public class Node {

  PVector pos;		// absolute position of point
  PVector dir;		// vector with direction and length of curve trait
  //float ang;			// angle from previous node
  String gCode;		// will contain the generated gCode
  float e, f, z;
  int round = 3;


  public Node (PVector pos, PVector dir, float z, float e, float f) {
    this.pos = pos;
    this.dir = dir;
    this.z = z;
    if (z == 0) pos.z = z;
    this.e = e;
    this.f = f;
    //this.ang = ang;
    //this.invalid = abs(ang) > angTol;
    gCode = makeGCode();
  }

  public String makeGCode() {
    String g = "";
    g = (dir.mag()==0)? "G0 ":"G1 ";
    g+= (f==0)?"":" F"+f;
    g+= " X"+ pos.x + " Y" + pos.y + " Z" + pos.z + " E" + nfc(dir.mag()*e,round);
    return g;
  }
}
