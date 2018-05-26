import processing.serial.*;

Serial serial;

// View Control Variables
float xView, yView, zView, xView_Initial, yView_Initial, zView_Initial;
float equatorialView, azimuthView;
boolean scrollLeft, scrollRight, scrollDown, scrollUp;
boolean panLeft, panRight, panDown, panUp;
boolean zoomIn, zoomOut, resetView;
int equatorialViewCounter = 0;
int azimuthViewCounter = 0;

// Array for points
ArrayList<PVector> cloudpoints;

boolean isOff = false;
boolean printOnce = true;

void setup(){
  
  size(1280,720, P3D);
  noSmooth();
  
// Set view ot middle of the screen

// Setting viewport to middle of screen
  xView_Initial = width/2;                               
  yView_Initial = height/2;
  zView_Initial = -20;
  translate(xView_Initial, yView_Initial, zView_Initial);
  xView = xView_Initial;
  yView = yView_Initial;
  zView = zView_Initial;
  equatorialView = 0;
  azimuthView = 0;
  
  cloudpoints = new ArrayList();
  serial = new Serial(this, "COM4", 9600);
}

void draw(){
// Retreive serial data and display on screen or end program and export
  String endMark = "END";
  String input = serial.readStringUntil(10);
  
  if(input != null){
    String[] components = split(input, ' ');
    if(components.length == 3){
      if(components[0].equals(endMark)){
        isOff = true;
        println("Exporting...");
      }
      cloudpoints.add(new PVector(float(components[0]), float(components[1]), float(components[2])));
    }
  }

  background(0);                                         // Sets background color to 0 (black) every loop
  translate(xView, yView, zView);                        // Moves object by /parameter/ amount
  rotateX(azimuthView);                                  // Rotates object horizontally by /parameter/ amount
  rotateY(equatorialView);                               // Rotates object vertically by /parameter/ amount
  
  //Scrolling
  if(scrollLeft)                                         
    xView = xView + 1f;
    else if(scrollRight)
      xView = xView - 1f;
  if(scrollDown) yView = yView - 1f;
    else if(scrollUp) yView = yView + 1f;
  
// Panning  
  if(panLeft){                                           
    equatorialView = equatorialView + 0.07f;
    equatorialViewCounter = equatorialViewCounter + 1;
  }
    else if(panRight){
      equatorialView = equatorialView - 0.07f;
      equatorialViewCounter = equatorialViewCounter - 1;
    }
  if(panDown){
    azimuthView = azimuthView + 0.07f;
    azimuthViewCounter = azimuthViewCounter + 1;
  }
    else if(panUp){
      azimuthView = azimuthView - 0.07f;
      azimuthViewCounter = azimuthViewCounter - 1;
    }
  
// Zooming    
  if(zoomIn) zView = zView + 1f;                          
    else if(zoomOut) zView = zView - 1f;
  
// Reset
  if(resetView){                                          // Reset view of object to initial (setup) values
    xView = xView_Initial;
    yView = yView_Initial;
    zView = zView_Initial;
    equatorialView = equatorialView - equatorialViewCounter*0.07f;
    equatorialViewCounter = 0;
    azimuthView = azimuthView - azimuthViewCounter*0.07f;
    azimuthViewCounter = 0;
  }

// Draw point cloud and line or export cloudpoints to CLOUDPOINTS.txt
  int cloudSize = cloudpoints.size();
if(isOff && printOnce){
    String[] stringCloudPoints = new String[cloudSize];
    for(int i = 0; i < cloudSize; i++){
      PVector points = cloudpoints.get(i);
      String stringPoints = str(points.x) + str(points.y) + str(points.z);
      stringCloudPoints[i] = stringPoints;
    }
    saveStrings("CLOUDPOINTS.txt",stringCloudPoints);
    println("DONE!");
    printOnce = false;
  } else {

  for(int i = 0; i < cloudSize; i++){
    PVector points = cloudpoints.get(i);
    stroke(255,255,255);
    point(points.x, points.y, points.z);
    if(i == cloudSize - 1){
      stroke(0,255,0);
      line( 0, 0, 0, points.x, points.y, points.z);
    }
  }
}
}
  void keyPressed(){
  scrollController(key,true);
  panController(keyCode,true);
  zoomController(key,true);
  resetController(keyCode,true);
}
void keyReleased(){
  scrollController(key,false);
  panController(keyCode,false);
  zoomController(key,false);
  resetController(keyCode,false);
}
  
boolean scrollController(char button, boolean bool){     // Controls the translation of viewport
  switch(button){
    case 'a':                                            // Move left
      return scrollLeft = bool;
    case 'd':                                            // Move right
      return scrollRight = bool;
    case 's':                                            // Move down
      return scrollDown = bool;
    case 'w':                                            // Move up
      return scrollUp = bool;
    default:
      return bool;
  }
}

boolean panController(int button, boolean bool){        // Controls the rotation of the viewport
  switch(button){
    case LEFT:                                          // Rotate left
      return panLeft = bool;
    case RIGHT:                                         // Rotate right
      return panRight = bool;
    case DOWN:                                          // Rotate down
      return panDown = bool;
    case UP:                                            // Rotate Up
      return panUp = bool;
    default:
      return bool;
  }
}

boolean zoomController(char button, boolean bool){      // Controls the depth of the viewport
  switch(button){
    case 'e':                                           // Zoom in
      return zoomIn = bool;
    case 'q':                                           // Zoom out
      return zoomOut = bool;
    default:
      return bool;
  }
}

boolean resetController(int button, boolean bool){      // Resets to initial values
  switch(button){
    case BACKSPACE:                                     // Reset
      return resetView = bool;
    default:
      return false;
  }
}
      
