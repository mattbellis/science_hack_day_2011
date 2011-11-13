float width = 1300;
float height = 550;

float center_x = width/2.0;
float center_y = height/2.0;
float center_z = -200;

HScrollbar hs1;

int time_to_display = 100;
float speed_scale = 50.0/time_to_display;
int timer = 0;

String lines[] = new String[];

int event_count = 1;

float energy[] = new float[2];
float px[] = new float[2];
float py[] = new float[2];
float pz[] = new float[2];

float mass_cp = 0.0;
float mass_sr = 0.0;

float x0=0;
float y0=0;
float z0=0;

float x1=0;
float y1=0;
float z1=0;


float vals[] = new vals[];

int nbins = 200;
float min = 0;
float max = 100;
float bin_width = (max-min)/nbins;
float tick_height = 1.0;

float histogram_x[] = new float[nbins];
float histogram_y[] = new float[nbins];


int bin_index = 0;

void setup(){
    size(width,height,OPENGL);
    noStroke();
    //reader = createReader("/home/bellis/science_hack_day_2011/science_hack_day_2011/web_visualization/dimuons.csv");
    //reader = new BufferedReader(new FileReader("/home/bellis/science_hack_day_2011/science_hack_day_2011/web_visualization/dimuons.csv"));
    //String lines[] = loadStrings("dimuon_small.csv");
    lines = loadStrings("dimuon_small.csv");
    //console.log(lines[event_count]);

    hs1 = new HScrollbar(0,200,width,100);

    myline = lines[event_count];
    vals = split(myline,', ');
    fill_vals(vals);
    for (int i=0;i<nbins;i++)
    {
        histogram_x[i] = i*bin_width + min + bin_width/2.0;
        histogram_y[i] = 0;
    }
    event_count += 1;

}

void draw(){
    background(0);
    camera();
    lights();
    noStroke();
    //colorMode(HSB,100);
    //time_to_display  = hs1.getPos() - 500;

    // Muon
    e0 = energy[0];
    fill(0+8*e0,0,255-(8*e0));
    pushMatrix();
    x0 += px[0]*speed_scale;
    y0 += py[0]*speed_scale;
    z0 += pz[0]*speed_scale;
    translate(center_x+x0,center_y+y0,center_z+z0);
    sphere(20);
    popMatrix();

    // Muon
    e1 = energy[1];
    //fill(255);
    fill(0+8*e1,0,255-(8*e1));
    pushMatrix();
    x1 += px[1]*speed_scale;
    y1 += py[1]*speed_scale;
    z1 += pz[1]*speed_scale;
    translate(center_x+x1,center_y+y1,center_z+z1);
    sphere(20);
    popMatrix();

    ///////// Axis //////////////////
    stroke(255);
    line(0,height-30,width,height-30);
    noStroke();
    for (int i=0;i<nbins;i+=12)
    {
        textSize(30);
        String axiss = String(histogram_x[i].toFixed(0));
        //stroke(255);
        fill(255);
        xpos = i*(width/nbins);
        text(axiss, xpos, height-30, 100, 100);
        //text("test", 50, 50, 500, 100);
    }

    ////////// Text //////////////////
    textSize(60);

    float time_step = 255/time_to_display;
    //String s = String(mass_cp.toFixed(3));
    //fill(255-time_step*timer);
    //text(s, 15, 20, 700, 70);

    //console.log(mass_sr);
    s = String(mass_sr.toFixed(3));
    fill(255-time_step*timer,100-(100/time_to_display)*timer,100-(100/time_to_display)*timer);
    text(s, width-250, 20, 700, 70);

    range = 50;
    //bin_width = width/float(range);

    //fill(255-2.5*timer);
    fill(255);
    xpos = bin_index*(width/nbins);
    rect(xpos, height-histogram_y[bin_index]*tick_height - 30, width/nbins, histogram_y[bin_index]*tick_height);
    for (int i=0;i<nbins;i++)
    {
        fill(255,100,100);
        xpos = (width/nbins)*i;
        rect(xpos, height-histogram_y[i]*tick_height - 30, width/nbins, histogram_y[i]*tick_height);
    }

    //fill(255-2.5*timer,100-timer,100-timer);
    //fill(255-2.5,100,100);
    //xpos = mass_sr*bin_width;
    //rect(xpos, height-bin_width, bin_width, histogram[bin_index]*20);

    timer += 1;

    if (timer >= time_to_display)
    {
        timer = 0;
        myline = lines[event_count];
        vals = split(myline,', ');
        fill_vals(vals);

        event_count += 1;
        //console.log(lines[event_count])
        //console.log(px[0])

        x0=0;
        y0=0;
        z0=0;

        x1=0;
        y1=0;
        z1=0;

    }
    hs1.update();
    hs1.display();
}

void fill_vals(vals)
{
    //console.log(vals);
    energy[0] = float(vals[3]);
    px[0] = float(vals[4]);
    py[0] = float(vals[5]);
    pz[0] = float(vals[6]);

    energy[1] = float(vals[11]);
    px[1] = float(vals[12]);
    py[1] = float(vals[13]);
    pz[1] = float(vals[14]);

    v4 = [energy[0]+energy[1],px[0]+px[1],py[0]+py[1],pz[0]+pz[1]];
    mass_cp = mass_from_classical_physics(v4);
    mass_sr = mass_from_special_relativity(v4);
    console.log("mass sr: "+mass_sr);

    min = 0;
    bin_index = int((mass_sr-min)/bin_width);
    console.log(bin_index);
    histogram_y[bin_index] += 1;

    //console.log(histogram_x);
    //console.log(histogram_y);
}

////////////////////////////////////////////////////////////////////////////////
// Calculate the magnitude of a three-vector
////////////////////////////////////////////////////////////////////////////////
float magnitude_of_3vec(v3)
{

    float magnitude = sqrt(v3[0]*v3[0] + v3[1]*v3[1] + v3[2]*v3[2]);

    return magnitude;

}

////////////////////////////////////////////////////////////////////////////////
// Calculate the mass of a particle using Classical Physics
////////////////////////////////////////////////////////////////////////////////
float mass_from_classical_physics(v4)
{

    float[] v3 = [v4[1],v4[2],v4[3]];

    float pmag = magnitude_of_3vec(v3);

    float mass = pmag*pmag/(2.0*v4[0]);

    return mass;

}

////////////////////////////////////////////////////////////////////////////////
// Calculate the mass of a particle using Special Relativity
////////////////////////////////////////////////////////////////////////////////
float mass_from_special_relativity(v4)
{

    float[] v3 = [v4[1],v4[2],v4[3]];
    float pmag = magnitude_of_3vec(v3);

    float mass_squared = v4[0]*v4[0] - pmag*pmag;

    if (mass_squared>0)
    {
        return sqrt(mass_squared);
    }
    else
    {
        return -sqrt(abs(mass_squared));
    }

}

////////////////////////////////////////////////////////////////////////////////

class HScrollbar
{
    int swidth, sheight;    // width and height of bar
    int xpos, ypos;         // x and y position of bar
    float spos, newspos;    // x position of slider
    int sposMin, sposMax;   // max and min values of slider
    int loose;              // how loose/heavy
    boolean isOver;           // is the mouse over the slider?
    boolean locked;
    float ratio;

    HScrollbar (int xp, int yp, int sw, int sh, int l) {
        swidth = sw;
        sheight = sh;
        int widthtoheight = sw - sh;
        ratio = (float)sw / (float)widthtoheight;
        xpos = xp;
        ypos = yp-sheight/2;
        spos = xpos + swidth/2 - sheight/2;
        newspos = spos;
        sposMin = xpos;
        sposMax = xpos + swidth - sheight;
        loose = l;
    }

    void update() {
        if(over()) {
            isOver = true;
        } else {
            isOver = false;
        }
        if(mousePressed && isOver) {
            locked = true;
        }
        if(!mousePressed) {
            locked = false;
        }
        if(locked) {
            newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
        }
        if(abs(newspos - spos) > 1) {
            spos = spos + (newspos-spos)/loose;
        }
    }

    int constrain(int val, int minv, int maxv) {
        return min(max(val, minv), maxv);
    }

    boolean over() {
        if(mouseX > xpos && mouseX < xpos+swidth &&
                mouseY > ypos && mouseY < ypos+sheight) {
            return true;
        } else {
            return false;
        }
    }


    void display() {
        fill(255);
        rect(xpos, ypos, swidth, sheight);
        if(isOver || locked) {
            fill(153, 102, 0);
        } else {
            fill(102, 102, 102);
        }
        rect(spos, ypos, sheight, sheight);
    }

    float getPos() {
        // Convert spos to be values between
        // 0 and the total width of the scrollbar
        return spos * ratio;
    }
}

