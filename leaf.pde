

class Leaf {
  float size;
  float dest; 
  PVector pos;
  
  color col;
   
   Leaf(PVector _pos, float max) {
     pos = new PVector(_pos.x + random(-0.1, 0.1), _pos.y + random(-0.1, 0.1));
     dest = random(0.05, max);
     size = 0;
     col = lerpColor(#208219, #BAB026, random(1));
   }
   
   void draw() {
     size += 0.02 * (dest - size);
     noStroke();
     fill(col);
     ellipseMode(CENTER);
     ellipse(pos.x, pos.y, size, size);
     
   }
   
}


class Flower extends Leaf {
   PShape flower, pedals;
   Flower(PVector _pos) {
     super(_pos, 0.4);
     flower = flowerShape;
     pedals = flower.getChild("pedals");
   }
   
   void draw() {
     shapeMode(CENTER);
     size += 0.01 * (dest - size);
     shape(flower, pos.x, pos.y, size, size);
   }
   
}
