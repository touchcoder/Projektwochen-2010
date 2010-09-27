// http://www.tuio.org/?processing
// http://www.tuio.org/?java

import TUIO.*;
TuioProcessing tuioClient;

float eraserWidth = 20;
float brushWidth = 16;
float brushHeight = 6;

void setup()
{
  size(screen.width,screen.height);
  smooth();
  noLoop();
  background(255);  
  tuioClient  = new TuioProcessing(this);
}

void draw()
{
}

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
    if (tobj.getSymbolID() == 1) {
        // Radiergummi
        stroke(255);
        strokeWeight(eraserWidth);
        Vector pointList = tobj.getPath();
        if (pointList.size() > 1) {
            // Linie von der letzten zur aktuellen Position ziehen
            TuioPoint lastPoint = (TuioPoint) pointList.elementAt(pointList.size()-2);
            TuioPoint currentPoint = (TuioPoint) pointList.elementAt(pointList.size()-1);
            line(lastPoint.getScreenX(width), lastPoint.getScreenY(height), currentPoint.getScreenX(width), currentPoint.getScreenY(height));
        }
    } else if (tobj.getSymbolID() == 2) {
        // Pinsel
        Vector pointList = tobj.getPath();
        if (pointList.size() > 1) {
            noStroke();
            // Die Transparenz ist von der Geschwindigkeit abhängig –
            // je schneller das Objekt bewegt wird,
            // desto transparenter
            fill(0, map(tobj.getMotionSpeed(), 1, 5, 100, 20));

            // Da der Pinsel gedreht werden kann,
            // können wir nicht einfach eine normale Linie ziehen,
            // sondern müssen eine Art Parallelogramm zeichnen
            
            // Rotation des Pinsels ausrechnen
            PVector angle = rotateVector(new PVector(brushWidth/2, 0), degrees(tobj.getAngle()));
            
            // Aktueller und voriger Mittelpunkt der Pinselspitze
            TuioPoint lastPoint = (TuioPoint) pointList.elementAt(pointList.size()-2);
            TuioPoint currentPoint = (TuioPoint) pointList.elementAt(pointList.size()-1);
            
            // Ecken des Parallelogramms ausrechnen,
            // indem die Hälfe der gedrehten Pinselspitze 
            // von den Mittelpunkten abgezogen bzw. addiert wird
            PVector currentLeft = new PVector(currentPoint.getScreenX(width), currentPoint.getScreenY(height));
            currentLeft.sub(angle);
            PVector currentRight = new PVector(currentPoint.getScreenX(width), currentPoint.getScreenY(height));
            currentRight.add(angle);
            PVector lastLeft = new PVector(lastPoint.getScreenX(width), lastPoint.getScreenY(height));
            lastLeft.sub(angle);
            PVector lastRight = new PVector(lastPoint.getScreenX(width), lastPoint.getScreenY(height));
            lastRight.add(angle);
            
            // Parallelogramm zeichnen
            quad(currentLeft.x, currentLeft.y, currentRight.x, currentRight.y, lastRight.x, lastRight.y, lastLeft.x, lastLeft.y);      
        }
    }
}

// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
    stroke(0);
    Vector pointList = tcur.getPath();
    if (pointList.size() > 1) {
        // Mit dem Finger Malen
        TuioPoint lastPoint = (TuioPoint) pointList.elementAt(pointList.size()-2);
        TuioPoint currentPoint = (TuioPoint) pointList.elementAt(pointList.size()-1);
        line(lastPoint.getScreenX(width), lastPoint.getScreenY(height), currentPoint.getScreenX(width), currentPoint.getScreenY(height));
    }
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
}

// called after each message bundle
// representing the end of an image frame
void refresh(TuioTime bundleTime) { 
  redraw();
}

// Vektorrotation
PVector rotateVector (PVector vector, float _angle)
{
    float angle = (float) Math.toRadians(_angle);
    float xNew = cos(angle) * vector.x - sin(angle) * vector.y;
    float yNew = cos(angle) * vector.y + sin(angle) * vector.x;
    return new PVector(xNew, yNew);
}