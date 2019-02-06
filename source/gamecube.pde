import processing.serial.*; //import the Serial library

int end = 10;    // the number 10 is ASCII for linefeed (end of serial.println), later we will look for this to break up individual messages
String serial;   // declare a new string called 'serial' . A string is a sequence of characters (data type know as "char")
Serial port;  // The serial port, this is a new instance of the Serial class (an Object)

PImage[] buttons = { null, null, null, null, null, null, null, null, null, null, null, null }; // I'm literally too lazy to do this better sue me
PImage[] pressed_buttons = { null, null, null, null, null, null, null, null, null, null, null, null };
PImage[] stick_bases = { null, null };
PImage[] sticks = { null, null };
PImage gcc;

int WIDTH = 500;
int HEIGHT = 500;

void settings() {
  size(WIDTH, HEIGHT);
}

void setup() {
  port = new Serial(this, Serial.list()[1], 115200); // initializing the object by assigning a port and baud rate (must match that of Arduino)
  port.clear();  // function from serial library that throws out the first reading, in case we started reading in the middle of a string from Arduino

  buttons[0] = loadImage("a.png");
  pressed_buttons[0] = loadImage("a_press.png");
  
  buttons[1] = loadImage("b.png");
  pressed_buttons[1] = loadImage("b_press.png");
  
  buttons[2] = loadImage("x.png");
  pressed_buttons[2] = loadImage("x_press.png");
  
  buttons[3] = loadImage("y.png");
  pressed_buttons[3] = loadImage("y_press.png");
  
  buttons[4] = loadImage("z.png");
  pressed_buttons[4] = loadImage("z_press.png");
  
  buttons[5] = loadImage("l.png");
  pressed_buttons[5] = loadImage("l_press.png");
  
  buttons[6] = loadImage("r.png");
  pressed_buttons[6] = loadImage("r_press.png");
  
  buttons[7] = loadImage("d_left.png");
  pressed_buttons[7] = loadImage("d_left_press.png");
  
  buttons[8] = loadImage("d_up.png");
  pressed_buttons[8] = loadImage("d_up_press.png");
  
  buttons[9] = loadImage("d_down.png");
  pressed_buttons[9] = loadImage("d_down_press.png");
  
  buttons[10] = loadImage("d_right.png");
  pressed_buttons[10] = loadImage("d_right_press.png");
  
  buttons[11] = loadImage("start.png");
  pressed_buttons[11] = loadImage("start_press.png");
  
  stick_bases[0] = loadImage("a_stick_base.png");
  sticks[0] = loadImage("a_stick.png");
  
  stick_bases[1] = loadImage("c_stick_base.png");
  sticks[1] = loadImage("c_stick.png");
  
  background(0,0,0);
}

String raw;

void draw() {
  raw = port.readString();
  
 
  if (raw != null) {  //if the string is not empty, print the following
    String[] blah = split(raw, '\r');

    if (blah.length < 2) {
      return;
    }
    serial = blah[blah.length - 2];
    if (serial.length() == 0) {
      return;
    }
    serial = serial.substring(1);
  
    String[] input = split(serial, ',');  //a new array (called 'a') that stores values into separate cells (separated by commas specified in your Arduino program)
    if (input.length != 16) {
      return;
    }
    
    //draw_stick_base(0, 100, 170); // a stick
    //draw_stick_base(1, 240, 300); // c stick
    
    //draw_stick(input, 12, 0, 100, 170, 90, 2.844); // a stick
    //draw_stick(input, 14, 1, 240, 300, 80, 3.2); // c stick
    
    //draw_button(input, 0, 300, 130); // a
    //draw_button(input, 1, 245, 190); // b
    //draw_button(input, 2, 385, 120); // x
    //draw_button(input, 3, 290, 70); // y
    
    //draw_button(input, 5, 20, 0); // l
    //draw_button(input, 6, 330, 0); // r
    
    //draw_button(input, 4, 315, 30); // z
    //draw_button(input, 11, 315, 30); // start
    
    //draw_button(input, 7, 300, 130); // d_left
    //draw_button(input, 8, 245, 190); // d_up
    //draw_button(input, 9, 385, 120); // d_down
    //draw_button(input, 10, 290, 70); // d_right
    
    draw_stick_base(0, 100, 220); // a stick
    draw_stick_base(1, 240, 260); // c stick
       
    draw_button(input, 0, 340, 160); // a
    draw_button(input, 1, 300, 230); // b
    draw_button(input, 2, 420, 145); // x
    draw_button(input, 3, 323, 112); // y
    
    draw_button(input, 5, 55, 90); // l
    draw_button(input, 6, 190, 90); // r
    
    draw_button(input, 4, 190, 165); // z
    draw_button(input, 11, 300, 185); // start
    
    draw_button(input, 7, 20, 290); // d_left
    draw_button(input, 8, 60, 290); // d_up
    draw_button(input, 9, 100, 290); // d_down
    draw_button(input, 10, 140, 290); // d_right
    
    draw_stick(input, 12, 0, 100, 220, 90, 2.844); // a stick
    draw_stick(input, 14, 1, 240, 260, 80, 3.2); // c stick
  }
}

void draw_stick_base(int index, int x, int y) {
  imageMode(CENTER);
  image(stick_bases[index], x, y);
  imageMode(CORNERS);
}

void draw_stick(String[] input, int input_index, int index, int x, int y, int distance, float scale) {
  imageMode(CENTER);
  int ax = Integer.parseInt(input[input_index]);

  int ay = Integer.parseInt(input[input_index + 1]);

  image(sticks[index], x + (ax / scale) - (distance/2), y - (ay / scale) + (distance/2));
  imageMode(CORNERS);
}

void draw_button(String[] input, int index, int x, int y) {
  if (input[index].equals("0")) {
    image(buttons[index], x, y);
  } else {
    image(pressed_buttons[index], x, y);
  }
}
