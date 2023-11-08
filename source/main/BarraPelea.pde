
class BarraPelea {

int duracion = 5; 
int dato = 120;
int rangoInicio = 10; 
int rangoFin = 20; 
int diametroBolita = 20; 
float bolitaX; 
boolean win = false;

public BarraPelea(){
  
  bolitaX = map(rangoInicio, 500, dato, 0, width/2) + diametroBolita / 2;
};


void setRango(){
   this.rangoInicio =  (int) random(10, 80 + 1);
   this.rangoFin =  (int) random(20, 90 + 1);
}
void displayBarra(){

    // Dibujar la barra de progreso
    fill(0, 200, 255);
    rect(0, height / 2 + 500, width, 40);
    
    // Dibujar el rango resaltado
    fill(255, 0, 255); // Color semitransparente
    float inicioX = map(rangoInicio, 0, dato, 0, width);
    float finX = map(rangoFin, 0, dato, 0, width);
    rect(inicioX, height / 2 + 500, finX - inicioX, 40);
    
    // Dibujar la bolita
    fill(57, 255, 20);
    ellipse(bolitaX, height / 2 + 500, diametroBolita, diametroBolita);
    
    // Verificar si la bolita está dentro del rango resaltado
    if (bolitaX >= inicioX && bolitaX <= finX) {
      fill(0, 255, 0);
    }
    
    // Actualizar la posición de la bolita en cada frame
    controlEvent(null); 
    
  }
 
 void evaluarPesca() {
    // Verificar si la bolita está dentro del rango resaltado al hacer clic
    if (bolitaX >= map(rangoInicio, 0, dato, 0, width) && bolitaX <= map(rangoFin, 0, dato, 0, width)) {
      println("¡Clic correcto!");
      system.pescando = false;
      this.win = true;
    } else {
      println("¡Clic incorrecto!");
      this.win = false;
      system.pescando = false;
    }
    
    setRango();
  }
  
Boolean Win(){
  return win;
}
  
  void controlEvent(ControlEvent event) {
    // Actualizar la posición de la bolita en cada frame
    bolitaX = map(millis() % (duracion * 1000), 0, duracion * 1000, 0, width) + diametroBolita / 2;
  }

  
}
