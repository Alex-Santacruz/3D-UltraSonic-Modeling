# 3D-UltraSonic-Modeling
Arduino-based 3D depth scanning for modeling in Processing using Ultrasonic Sensor

The purpose of this project is to provide a low-cost solution to 3D scanning using an ultrasonic sensor for Arduino in Processing, which could be exported into 3D modeling software to create meshes. The use of the ultrasonic sensor was to ensure the device was budget-friendly, however, as our team has come to learn, it is counterproductive. The very mechanism by which the sensor works impedes accurate distance measurement on objects whose face is not (nearly) perpendicular to the soundwave. Nevertheless, our project is highly versatile and adaptable to any sensor compatible with the Arduino interface. Here's how it works:

## I. Arduino Point Sweeping and Printout
Once uploaded, the Arduino file programs the arduno to do 2 principle functions: sweeps both servo motors, accordingly, and measures distance to object.

  1. Both servo motors set to their starting postitions. By default, the horizoontal servo is set to begin at 35 degrees from the       horizontal axis (which points to the right hand side), and the vertical servo begins at 90 degrees from the vertical (which points down).
  2. At the starting position, the sensor will take its first measurement. This measurement is stored as the radius to the measured point a la spherical coordinates. After which, the Arduino will take the angles of both servos and the radius and calculate the cartesian coordinates of that point.
  3. The Arduino will then print out the coordinates via serial. It is here that Processing reads and displays the data (see II.a.1.).
  4. The horizontal servo now moves one degree counterclockwise, by default. The sensor takes a new measurement. Repeat step 3.
  5. Repeat step 4. Once the horizontal servo reaches the maximum angular displacement (default 135 degrees), Arduino does step 3 then moves the vertical servo up one degree.
  6. Repeat steps 3 and 4, only noww the horizontal servo moves clockwise.
  7. Repeat step 6 until the vertical servo reaches its maximum angular displacement (135 degrees). 
  8. Once both servos reach their maximum angles, the program is suspended indefinitely. Arduino then prints an END message that stops Processing point mappinging (see II.a.1.)

## II.a. Processing Point Mapping and Exporting
Processing is meant to run parallel to the Arduino sketch. As the Arduino is moving, Processing reads the data and draws points, creating a "point cloud". This point cloud is exported into a .txt file for later use.

1. If there non-null data coming through the primary serial port (COM4), Processing reads data sent from the Arduino. It saves this data in an array of vectors called the point cloud. If the data is and END message (see I.8.) the program is suspended indefinitely. If suspended, Processing skips to step #.
2. Processing then draws all previous points from point cloud, if any. A line is drawing from the origin to the latest point. The latest point is then plotted.
3. If an END message is received, point mapping stops. Processing takes point cloud and saves it to CLOUDPOINTS.txt, which by default is saved in the same folder as UltraSonicScanner.pde.

## II.b. Processing View Control
To aid with viewing of the point cloud, keyboard control was added to Processing. These movement functions can be accessed at any time while the Processing sketch is running or suspended. Here are the functions currently available.

WASD Translational Control - Using the conventional WASD keys, the user can control the translation of the point cloud.

Arrow Rotational Control - Using the arrow keys, the user can rotate the point cloud about the horizontal and vertical axes. Up and down arrows tilt the point cloud about the horiztonal, and the left and right rotate about the vertical counterclockwise and clockwise respectively.

Additional Control - Using the E and Q keys, the user can zoom in and out, respectively. Furthermore, the user can press BACKSPACE to reset the view to its default position.
