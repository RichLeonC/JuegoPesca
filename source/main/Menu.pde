// Menu.pde
import controlP5.*;

class Menu {
  ControlP5 cp5;
  int menuX, menuY; // Coordenadas del centro del menú
  
  Menu(int x, int y, ControlP5 cp5) {
    this.cp5 = cp5;
    menuX = x;
    menuY = y;
    createMenu();
  }

  void createMenu() {
    // Lógica para crear botones y perillas usando ControlP5
    // ...
  }
  
  void handleButton1() {
    println("Botón 1 presionado");
    // Agrega aquí la lógica para el Botón 1
  }
  
  void handleButton2() {
    println("Botón 2 presionado");
    // Agrega aquí la lógica para el Botón 2
  }
  
  void handleKnob1(float val) {
    println("Perilla 1: " + val);
    // Usa el valor de la perilla para modificar alguna variable
  }
  
  void handleKnob2(float val) {
    println("Perilla 2: " + val);
    // Usa el valor de la perilla para modificar alguna variable
  }
}
