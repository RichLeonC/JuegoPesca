
class BarraPelea {

int duracion = 5; 
int dato = 120;
int rangoInicio = 10; 
int rangoFin = 80; 
int diametroBolita = 20; 
float bolitaX; 
boolean win = false;

public BarraPelea(){
  
  bolitaX = map(rangoInicio, 500, dato, 0, width/2) + diametroBolita / 2;
};

void displayBarra(){

       // Dibujar la barra de progreso
      fill(0, 150, 255);
      rectMode(CORNER);
      rect(500, height / 2 - 10, width/2, 20);
      
      // Dibujar el rango resaltado
      fill(255, 0, 0, 150); // Color semitransparente
      float inicioX = map(rangoInicio, 500, dato, 0, width/2);
      float finX = map(rangoFin, 500, dato, 0, width/2); 
      rect(inicioX, height / 2 - 10, finX - inicioX, 20);
      
      // Dibujar la bolita
      fill(0, 0, 255);
      ellipse(bolitaX, height / 2, diametroBolita, diametroBolita);
      
      // Verificar si la bolita está dentro del rango resaltado
      if (bolitaX >= inicioX && bolitaX <= finX) {
        fill(0, 255, 0);
      }
      
      // Actualizar la posición de la bolita en cada frame
      controlEvent(null);   
    
  }
 
 void clicButton() {
    // Verificar si la bolita está dentro del rango resaltado al hacer clic
    if (bolitaX >= map(rangoInicio, 0, dato, 0, width) && bolitaX <= map(rangoFin, 0, dato, 0, width)) {
      println("¡Clic correcto!");
      this.win = true;
    } else {
      println("¡Clic incorrecto!");
      this.win = false;
      system.pescando = false;
      botonPescar.setVisible(false);
    }
  }
  
Boolean Win(){
  return win;
}
  
  void controlEvent(ControlEvent event) {
    // Actualizar la posición de la bolita en cada frame
    bolitaX = map(millis() % (duracion * 1000), 0, duracion * 1000, 0, width) + diametroBolita / 2;
  }

  
}
