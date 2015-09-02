class DDCam {

  // ____________________________________ fields

  float x, y, z;
  float inX, inY, inZ;
  float thres, easing, panFactor, zoomFactor;
  boolean reset;

  // ____________________________________ constructors

  DDCam(float inX, float inY, float inZ, float panFactor, float zoomFactor, float easing) {
    this.inX = inX;
    this.inY = inY;
    this.inZ = inZ;
    x = this.inX;
    y = this.inY;
    z = this.inZ;
    thres = 0.1;
    reset=false;
    this.panFactor = panFactor;
    this.zoomFactor = zoomFactor;
    this.easing = easing;
  }

  DDCam(float inX, float inY, float inZ) {
    this(inX, inY, inZ, 1.0, 2.0, 0.12);
  }

  DDCam(float inX, float inY, float inZ, float easing) {
    this(inX, inY, inZ, 1.0, 2.0, easing);
  }


  // ____________________________________ methods

  void drag() {
    x += (pmouseX-mouseX)*panFactor;
    y += (pmouseY-mouseY)*panFactor;
  }

  void zoom(float e) {
    z = constrain(z+e, 10, 1000);
  }

  void update() {
    if (reset) {
      if (checkThres()) {
        reset = false;
      } else {
        x+= (inX - x)* easing;
        y+= (inY - y)* easing;
        z+= (inZ - z)* easing;
      }
    }
    camera(x, y, z, x, y, 0, 0, 1, 0); // camera with Y up (like in P2D view)
  }

  boolean checkThres() {
    float d = sqrt(pow(x-inX, 2)+pow(y-inY, 2)+pow(z-inZ, 2));
    return d < thres;
  }


  void beginHUD() {
    camera();
  }

  void endHUD() {
    update();
  }
}
