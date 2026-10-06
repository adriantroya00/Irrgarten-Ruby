package irrgarten;
import java.util.Random;



/**
 * @authors Alvaro Perez Sanchez y Adrian Hernando Leal 
 */
public class TestP1 {

    private static final Random generator = new Random();
    public static void main(String[] args) {
    
        // ======================================================
        // 1. Prueba Weapon
        // ======================================================
        System.out.println("===== PRUEBAS ESPADA =====");

        Weapon espada = new Weapon(5,5);

        boolean usable1 = true;

        do {
            System.out.println("La espada ataca con " + espada.attack());

            if(espada.discard()){
                System.out.println("NO se ha descartado la espada");
                System.out.println(espada.toString());

            } else {
                System.out.println("SI se ha descartado la espada");
                usable1 = false;
            }
        } while(usable1);

        // ======================================================
        // 2. Prueba Shield
        // ======================================================

        System.out.println("===== PRUEBAS ESCUDO =====");

        Shield escudo = new Shield(3,4);

        boolean usable2 = true;

        do {
            System.out.println("El escudo defiende con " + escudo.protect());

            if(escudo.discard()){
                
                System.out.println("NO se ha descartado el escudo");
                System.out.println(escudo.toString());

            } else {
                System.out.println("SI se ha descartado el escudo");
                usable2 = false;
            }
        } while(usable2);

        // ======================================================
        // 3. Prueba GameState
        // ======================================================

        System.out.println("===== PRUEBAS GAMESTATE =====");

        GameState gs = new GameState("lab1", "jugadores", "monstruos", 0, false, "log inicial");

        System.out.println("El laberinto es: " + gs.getLabyrinth());
        System.out.println("Los jugadores son: " + gs.getPlayers());
        System.out.println("Los monstruos son: " + gs.getMonsters());
        System.out.println("El jugador actual es: " + gs.getCurrentPlayer());
        System.out.println("Ganador " + gs.isWinner());
        System.out.println("El log es:" + gs.getLog());

        // ======================================================
        // 4. Prueba Enumerados
        // ======================================================

        System.out.println("===== PRUEBAS ENUMERADOS =====");

        Directions dir = Directions.LEFT;
        Orientation ori = Orientation.HORIZONTAL;
        GameCharacter gc = GameCharacter.MONSTER;

        System.out.println("La direccion es: " + dir);
        System.out.println("La orientacion es: " + ori);
        System.out.println("El personaje es un: " + gc);

        System.out.println("Todas las direcciones: ");
        for (Directions d : Directions.values()){
            System.out.println("La direccion es: " + d);
        }

        System.out.println("Todas las orientaciones: ");
        for (Orientation o : Orientation.values()){
            System.out.println("La direccion es: " + o);
        }

        System.out.println("Todos los tipos de personajes: ");
        for (GameCharacter c : GameCharacter.values()){
            System.out.println("La direccion es: " + c);
        }

        

        // ======================================================
        // 5. Pruebas Dice
        // ======================================================

        System.out.println("===== PRUEBAS ENUMERADOS (100 pruebas por metodo)=====");

        // randomPos
        System.out.println("Direccion aleatoria (randomPos): " + Dice.randomPos(5));

        // whoStarts
        for (int i = 0 ; i < 100 ; i++)
        System.out.println("Empieza el jugador: " + Dice.whoStarts(3));
        
        // randomIntelligence y randomStrength
        for (int i = 0 ; i < 100 ; i++){
            System.out.println("Inteligencia: " + Dice.randomIntelligence());
            System.out.println("Fuerza: " + Dice.randomStrength());
        }
       
        

        //resurrectPlayer
        int resurrect_count = 0;
        for (int i = 0 ; i < 100 ; i++){
            if(Dice.resurrectPlayer())
                resurrect_count++;
        }
        System.out.println("Veces resucitadas: " + resurrect_count);

        // weaponReward, shieldReward y healthReward 
        for (int i = 0 ; i < 100 ; i++){
            System.out.println("------- " + i + " -------");
            System.out.println("Armas: " + Dice.weaponsReward());
            System.out.println("Escudos: " + Dice.shieldsReward());
            System.out.println("Vida: " + Dice.healthReward());
        }

        // weaponPower y shieldPower
        for (int i = 0 ; i < 100 ; i++){
            System.out.println("------- " + i + " -------");
            System.out.println("Poder Arma: " + Dice.weaponPower());
            System.out.println("Poder Escudo: " + Dice.shieldPower());
        }

        //usesLeft
        for (int i = 0 ; i < 100 ; i++){
            System.out.println("------- " + i + " -------");
            System.out.println("El objeto empezara con: " + Dice.usesLeft() + " usos");
        }

        //intensity
        for (int i = 0 ; i < 100 ; i++){
            System.out.println("------- " + i + " -------");
            System.out.println("Se usara una intensidad de: " + Dice.intensity(5) + " usos");
        }

        //discardElement
        int discard_count = 0;
    
        for (int i = 0 ; i < 10000 ; i++){
            if(Dice.discardElement(0))
                discard_count++;
        }

        System.out.println("Veces descartado: " + discard_count);

        
        

    }
}
