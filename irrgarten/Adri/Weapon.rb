package irrgarten;
//Adri


/**
 * @authors Alvaro Perez Sanchez y Adrian Hernando Leal 
 */
public class Weapon {
    private float power;
    private int uses;

    public Weapon(float power, int uses) {
        this.power = power;
        this.uses = uses;
    }

    public float attack() {
        if (uses > 0) {
            uses--;
            return power;
        }
        return 0;
    }
 
    public String toString() {
       return "W[" + power + ", " + uses + "]";
    }

    public boolean discard() {
        return Dice.discardElement(uses);
    }

    public void reduceUses() {
        uses--;
    }



}
