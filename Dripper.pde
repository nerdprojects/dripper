import controlP5.ControlEvent;
import controlP5.ControlP5;
import controlP5.ListBox;
import controlP5.Slider;
import controlP5.Textfield;
import java.awt.Component;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import javax.swing.JFileChooser;
import processing.core.PApplet;
import processing.core.PImage;
import processing.core.PVector;

ArrayList<Drip> dripArray;
PVector start = new PVector(0.0F, 0.0F);
HashMap configMap;
ArrayList<ParameterEntry> configArray;
PImage backgroundImage;
ControlP5 controlP5;
ListBox l;
Textfield t1;
Slider s0;
Slider s1;
Slider s2;
Slider s3;
Slider s4;
Slider s5;
Slider s6;
Slider s7;
Slider s8;
Slider s9;
int stepSize;
int dripColor;
float dSize;
float dropEnd;
float wetSpeed;
float drySpeed;
float dripSpeed;
float maxSpeed;
float dropEndSpeed;
float yVarFrame;
float yVarMin;
float yVarMax;
float sizeVarFrame;
float sizeVarMin;
float sizeVarMax;
float dist;
boolean fileSelectDone = false;

void setup() {
  smooth();
  frameRate(30.0F);
  size(1000, 800);
  background(-1);
  backgroundImage = loadImage("tag.png");
  image(backgroundImage, 200.0F, 0.0F);
  configMap = new HashMap<Object, Object>();
  configArray = new ArrayList();
  loadConfig();
  applyConfig(0);
  controlP5 = new ControlP5(this);
  setupGUI();
  dripArray = new ArrayList();
}

void draw() {
  float f = PVector.dist(start, new PVector(mouseX, mouseY));
  if (mousePressed && f > stepSize && mouseX > 200) {
    dripArray.add(new Drip(mouseX, mouseY));
    start = new PVector(mouseX, mouseY);
  }
  for (byte b = 0; b < dripArray.size(); b++) {
    Drip drip = dripArray.get(b);
    println(String.valueOf(b) + "  " + drip.speed);
    drip.update();
    drip.display();
    if (drip.speed < 0.0F)
      dripArray.remove(b);
  }
  displayGUI();
}

void loadConfig() {
  String[] arrayOfString = loadStrings("presets.txt");
  for (byte b = 0; b < arrayOfString.length; b++) {
    String[] arrayOfString1 = split(arrayOfString[b], '\t');
    if (arrayOfString1.length == 2) {
      String str = arrayOfString1[0];
      HashMap<Object, Object> hashMap = new HashMap<Object, Object>();
      String[] arrayOfString2 = split(arrayOfString1[1], ';');
      for (byte b1 = 0; b1 < arrayOfString2.length; b1++) {
        String[] arrayOfString3 = split(arrayOfString2[b1], '=');
        if (arrayOfString3.length == 2)
          hashMap.put(arrayOfString3[0], arrayOfString3[1]);
      }
      configArray.add(new ParameterEntry(str, hashMap));
    }
  }
}

void saveConfig() {
}

void applyConfig(int paramInt) {
  println("ApplyConfig " + paramInt);
  dripColor = -16777216;
  stepSize = 9;
  dSize = 10.0F;
  dropEnd = 0.02F;
  wetSpeed = 0.03F;
  drySpeed = 0.01F;
  dripSpeed = 0.1F;
  maxSpeed = 2.0F;
  dropEndSpeed = 0.4F;
  yVarFrame = 4.0F;
  yVarMin = -0.2F;
  yVarMax = 0.2F;
  sizeVarFrame = 4.0F;
  sizeVarMin = -0.2F;
  sizeVarMax = 0.2F;
  dist = 10.0F;
  ParameterEntry parameterEntry = configArray.get(paramInt);
  HashMap hashMap = parameterEntry.entry;
  Iterator<Map.Entry> iterator = hashMap.entrySet().iterator();
  while (iterator.hasNext()) {
    Map.Entry entry = iterator.next();
    if (entry.getKey().equals("stepSize"))
      stepSize = parseInt(entry.getValue().toString());
    if (entry.getKey().equals("dripColor"))
      dripColor = color(parseInt(entry.getValue().toString()));
    if (entry.getKey().equals("dSize"))
      dSize = parseFloat(entry.getValue().toString());
    if (entry.getKey().equals("dropEnd"))
      dropEnd = parseFloat(entry.getValue().toString());
    if (entry.getKey().equals("wetSpeed"))
      wetSpeed = parseFloat(entry.getValue().toString());
    if (entry.getKey().equals("drySpeed"))
      drySpeed = parseFloat(entry.getValue().toString());
    if (entry.getKey().equals("dripSpeed"))
      dripSpeed = parseFloat(entry.getValue().toString());
    if (entry.getKey().equals("maxSpeed"))
      maxSpeed = parseFloat(entry.getValue().toString());
    if (entry.getKey().equals("dropEndSpeed"))
      dropEndSpeed = parseFloat(entry.getValue().toString());
    if (entry.getKey().equals("yVarFrame"))
      yVarFrame = parseInt(entry.getValue().toString());
    if (entry.getKey().equals("yVarMin"))
      yVarMin = parseFloat(entry.getValue().toString());
    if (entry.getKey().equals("yVarMax"))
      yVarMax = parseFloat(entry.getValue().toString());
    if (entry.getKey().equals("sizeVarFrame"))
      sizeVarFrame = parseInt(entry.getValue().toString());
    if (entry.getKey().equals("sizeVarMin"))
      sizeVarMin = parseFloat(entry.getValue().toString());
    if (entry.getKey().equals("sizeVarMax"))
      sizeVarMax = parseFloat(entry.getValue().toString());
    if (entry.getKey().equals("dist"))
      dist = parseInt(entry.getValue().toString());
  }
}


void setupGUI() {
  int b1 = 10;
  ListBox listBox = controlP5.addListBox("myList", 10, b1, 170, 170);
  listBox.setItemHeight(15);
  listBox.setBarHeight(15);
  listBox.setHeight(60);
  listBox.setCaptionLabel("Presets");
  for (int b2 = 0; b2 < configArray.size(); b2++) {
    ParameterEntry parameterEntry = configArray.get(b2);
    listBox.addItem(parameterEntry.name, b2);
  }
  b1 += 70;
  s0 = controlP5.addSlider("markerSize", 0.0F, 50.0F, dSize, 10, b1, 100, 15);
  b1 += 30;
  s1 = controlP5.addSlider("inkAmount", 0.01F, 0.2F, wetSpeed, 10, b1, 100, 15);
  b1 += 30;
  s2 = controlP5.addSlider("dripSize", 0.0F, 0.2F, dropEnd, 10, b1, 100, 15);
  b1 += 30;
  s3 = controlP5.addSlider("steps", 2.0F, 20.0F, stepSize, 10, b1, 100, 15);
  b1 += 50;
  s4 = controlP5.addSlider("yVariationMin", -5.0F, 0.0F, yVarMin, 10, b1, 100, 10);
  b1 += 20;
  s5 = controlP5.addSlider("yVariationMax", 0.0F, 5.0F, yVarMax, 10, b1, 100, 10);
  b1 += 20;
  s6 = controlP5.addSlider("yVariationStep", 1.0F, 10.0F, yVarFrame, 10, b1, 100, 10);
  b1 += 40;
  s7 = controlP5.addSlider("sizeVariationMin", -5.0F, 0.0F, sizeVarMin, 10, b1, 100, 10);
  b1 += 20;
  s8 = controlP5.addSlider("sizeVariationMax", 0.0F, 5.0F, sizeVarMax, 10, b1, 100, 10);
  b1 += 20;
  s9 = controlP5.addSlider("sizeVariationStep", 1.0F, 10.0F, sizeVarFrame, 10, b1, 100, 10);
  b1 += 200;
  controlP5.addButton("save", 100.0F, 10, b1, 60, 20);
  controlP5.addButton("load", 100.0F, 80, b1, 40, 20);
  controlP5.addButton("delete", 100.0F, 130, b1, 50, 20);
}

void displayGUI() {
  noStroke();
  fill(-10125160);
  rect(0.0F, 0.0F, 200.0F, height);
  fill(-13415322);
  rect(5.0F, 5.0F, 190.0F, 400.0F);
}

void controlEvent(ControlEvent event) {

  if (event.isFrom("myList")) {
    Float float_ = Float.valueOf(event.getValue());
    int i = float_.intValue();
    applyConfig(i);
    s0.setValue(dSize);
    s1.setValue(wetSpeed);
    s2.setValue(dropEnd);
    s3.setValue(stepSize);
    s4.setValue(yVarMin);
    s5.setValue(yVarMax);
    s6.setValue(yVarFrame);
    s7.setValue(sizeVarMin);
    s8.setValue(sizeVarMax);
    s9.setValue(sizeVarFrame);
  }
}

void markerSize(float paramFloat) {
  dSize = paramFloat;
}

void inkAmount(float paramFloat) {
  wetSpeed = paramFloat;
}

void dripSize(float paramFloat) {
  dropEnd = paramFloat;
}

void steps(int paramInt) {
  stepSize = paramInt;
}

void yVariationMin(float paramFloat) {
  yVarMin = paramFloat;
}

void yVariationMax(float paramFloat) {
  yVarMax = paramFloat;
}

void yVariationStep(int paramInt) {
  yVarFrame = paramInt;
}

void sizeVariationMin(float paramFloat) {
  sizeVarMin = paramFloat;
}

void sizeVariationMax(float paramFloat) {
  sizeVarMax = paramFloat;
}

void sizeVariationStep(int paramInt) {
  sizeVarFrame = paramInt;
}

void save() {
  save("test.png");
}

void load() {
  selectInput("Choose an Image File:", "fileSelected");
  while(!fileSelectDone) {
    delay(100);
  }
  delete();
  fileSelectDone = false;
}

void fileSelected(File file) {
  if (file != null && (file.getName().endsWith("jpg") || file.getName().endsWith("jpeg") ||
    file.getName().endsWith("png") || file.getName().endsWith("gif"))) {
    backgroundImage = loadImage(file.getAbsolutePath());
  } else {
    println("No Valid Image File");
  }
  fileSelectDone = true;
}

void delete() {
  dripArray.clear();
  fill(-1);
  rect(200.0F, 0.0F, (width - 200), height);
  image(backgroundImage, 200.0F, 0.0F);
}

class Drip {

  PVector location;
  float startX;
  float startY;
  float speed;
  float dripSize;

  Drip(float x, float y) {
    location = new PVector(x, y);
    startX = x;
    startY = y;
    speed = dripSpeed;
    dripSize = dSize;
  }

  void update() {
    if (speed > 0.0F) {
      float f = PVector.dist(new PVector(startX, startY), new PVector(mouseX, mouseY));
      if (mousePressed && f < dist) {
        if (speed < maxSpeed)
          speed += wetSpeed;
      } else {
        speed -= drySpeed;
        if (speed < dropEndSpeed)
          dripSize += dropEnd;
      }
      if (frameCount % yVarFrame == 0.0F) {
        float f1 = random(yVarMin, yVarMax);
        location.add(f1, 0.0F, 0.0F);
      }
      if (frameCount % sizeVarFrame == 0.0F) {
        float f1 = random(sizeVarMin, sizeVarMax);
        if (dripSize > 0.0F)
          dripSize += f1;
      }
      location.add(0.0F, speed, 0.0F);
    }
  }

  void display() {
    noStroke();
    fill(dripColor);
    ellipse(location.x, location.y, dripSize, dripSize);
  }
}


class ParameterEntry {
  
  String name;
  HashMap entry;

  ParameterEntry(String param1String, HashMap param1HashMap) {
    name = param1String;
    entry = param1HashMap;
  }
}
