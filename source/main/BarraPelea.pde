
class BarraPelea {

int duracion = 5; 
int dato = 120;
int rangoInicio; 
int rangoFin; 
int diametroBolita = 20; 
float bolitaX;
int win = 2; //Cero perdio, 1 gano, 2 neutro (jugando o sin empezar)

public BarraPelea(){
  rangoInicio = (int) random(100, width - 200);
  rangoFin = rangoInicio + (int) random(100, min(200, width - rangoInicio));
  bolitaX = 0 + diametroBolita;
};


void setRango(){
  rangoInicio = (int) random(100, width - 200);
  rangoFin = rangoInicio + (int) random(100, min(200, width - rangoInicio));
}

void displayBarra(){

    // Dibujar la barra de progreso
    fill(0, 200, 255);
    float inicioX = 0;
    float finX = width;
    int altura = 25;
    rect(inicioX, height*0.97 - altura / 2, finX - inicioX, altura);
    
    // Dibujar el rango resaltado
    fill(255, 0, 255); // Color semitransparente
    rect(rangoInicio, height*0.97 - altura / 2, rangoFin - rangoInicio, altura);
    
    // Dibujar la bolita
    fill(57, 255, 20);
    ellipse(bolitaX, height*0.97, diametroBolita, diametroBolita);
    
    // Verificar si la bolita está dentro del rango resaltado
    if (bolitaX >= inicioX && bolitaX <= finX) {
      fill(0, 255, 0);
    }
    
    // Actualizar la posición de la bolita en cada frame
    controlEvent(null); 
    
  }
 
 void evaluarPesca() {
    // Verificar si la bolita está dentro del rango resaltado al hacer clic
    if (bolitaX >= rangoInicio && bolitaX <= rangoFin) {
      //println("¡Clic correcto!");
      system.pescando = false;
      this.win = 1;
    } else {
      //println("¡Clic incorrecto!");
      this.win = 0;
      system.pescando = false;
    }
    
    setRango();
  }
  
  int Win(){
    return win;
  }
  
  void controlEvent(ControlEvent event) {
    // Actualizar la posición de la bolita en cada frame
    bolitaX+=15;
    if(bolitaX >= width + diametroBolita){
      bolitaX = 0 + diametroBolita;
    }
  }

  
}
