

class Leaf {
  float size;
  float dest; 
  PVector pos;
  
  color col;
   
   Leaf(PVector _pos) {
     pos = new PVector(_pos.x + random(-0.1, 0.1), _pos.y + random(-0.1, 0.1));
     dest = random(0.05, 0.4);
     size = 0;
     col = lerpColor(#208219, #BAB026, random(1));
   }
   
   void draw() {
     size += 0.02 * (dest - size);
     noStroke();
     fill(col);
     ellipse(pos.x, pos.y, size, size);
     
   }
   
}


class Flower extends Leaf {
   PShape c;
   Flower(PVector _pos) {
     super(_pos);
     c = flowerShape;
   }
   
   void draw() {
     size += 0.01 * (dest - size);
     shape( c, pos.x, pos.y, size, size);
   }
   
}
