package irrgarten;
import java.util.Random;

/**
 * @authors Alvaro Perez Sanchez y Adrian Hernando Leal 
 */
public class Dice {
    private static final int MAX_USES = 5; // Numero maximo de usos de armas y escudos
    private static final float MAX_INTELLIGENCE = 10.0f; // Valor maximo para la inteligencia de jugadores y monstruos
    private static final float MAX_STRENGTH = 10.0f; // Valor maximo para la fuerza de jugadores y monstruos
    private static final float RESURRECT_PROB = 0.3f; // Probabilidad de que un jugador sea resucitado en cada turno
    private static final int WEAPONS_REWARD = 2; // Numero maximo de armas recibidas al ganar un combate
    private static final int SHIELDS_REWARD = 3; // Numero maximo de escudos recibidos al ganar un combate
    private static final int HEALTH_REWARD = 5; // Numero maximo de unidades de salud recibidas al ganar un combate
    private static final int MAX_ATTACK = 3; // Maxima potencia de las armas
    private static final int MAX_SHIELD = 2; // Maxima potencia de los escudos

    private static final Random generator = new Random();

    /**
     * @param max numero filas y columnas
     * @return numero de fila/columna aleatoria siendo el valor del parámeyro el número filas o columnas tablero (filas y columnas menor valor tienen como índice el 0)
     */
    public static int randomPos(int max){
        return generator.nextInt(max);
    }

    /**
     * 
     * @param nplayers número jugadores en partida
     * @return índice del jugador que comenzará la partida (jugadores se numeran comenzando en el 0)
     */
    public static int whoStarts(int nplayers){
        return generator.nextInt(nplayers);
    }

    /**
     * 
     * @return valor aleatorio de inteligencia [0, MAX_INTELLIGENCE]
     */
    public static float randomIntelligence(){
        return generator.nextFloat() * MAX_INTELLIGENCE ;
    }

    /**
     * 
     * @return valor aleatorio de fuerza [0, MAX_STRENGTH]
     */
    public static float randomStrength(){
        return generator.nextFloat() * MAX_STRENGTH;
    }

    /**
     * 
     * @return si un jugador muerto debe ser resucitado o no
     */
    public static boolean resurrectPlayer(){
        return (generator.nextFloat()<RESURRECT_PROB);
    }

    /**
     * 
     * @return cantidad de armas que recibe el jugador al ganar el combate (sera un numero entre 0 (incluido) y el máximo)
     */
    public static int weaponsReward(){
        return generator.nextInt(WEAPONS_REWARD);
    }

    /**
     * 
     * @return cantidad de escudos que recibe el jugador al ganar el combate (sera un numero entre 0 (incluido) y el máximo)
     */
    public static int shieldsReward(){
        return generator.nextInt(SHIELDS_REWARD);
    }

    /**
     * 
     * @return cantidad de vida que recibe el jugador al ganar el combate (sera un numero entre 0 (incluido) y el máximo)
     */
    public static int healthReward(){
        return generator.nextInt(HEALTH_REWARD);
    }

    /**
     * 
     * @return valor aleatorio en intervalo [0, MAX_ATTACK]
     */
    public static float weaponPower(){
        return generator.nextFloat() * MAX_ATTACK;
    }

    /**
     * 
     * @return valor aleatorio en intervalo [0, MAX_SHIELD]
     */
    public static float shieldPower(){
        return generator.nextFloat() * MAX_SHIELD;
    }

    /**
     * 
     * @return numero usos que se asignara a un arma/escudo (número aleatorio entre 0 (incluido) y el máximo)
     */
    public static int usesLeft(){
        return generator.nextInt(MAX_USES);
    }

    /**
     * @param competence
     * @return cantidad competencia aplicada (valor aleatorio entre [0, competence])
     */
    public static float intensity(float competence){
        return generator.nextFloat() * competence;
    }

    /**
     * @brief Al usar un arma o escudo comprobamos si se descartara el objeto.
     * @param usesLeft usos restantes del arma/escudo
     * @return true con una probabilidad inversamente proporcional a lo cercano que esté el parametro del número máximo de usos que puede tener un arma/escudo
     */
    public static boolean discardElement(int usesLeft){
        if(generator.nextInt(MAX_USES)>=usesLeft){
            return true;
        } else {
            return false;
        }

        //5 usos = 100% falso
        //4 usos = 80% falso y 20% true
    }
    
}
