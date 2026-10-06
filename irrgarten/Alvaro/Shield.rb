package irrgarten;
//Alvaro

/**
 * @authors Alvaro Perez Sanchez y Adrian Hernando Leal 
 */
public class Shield {
    private float protection;
    private int uses;

        public Shield(float _protection, int _uses) {
            this.protection = _protection;
            this.uses = _uses;
        }

        public float protect(){
            if(this.uses>0){
                uses--;
                return protection;
            }
            return 0f;
        }

        public String toString(){
            return "S[" + protection + ", " + uses + "]";
        }

        public boolean discard() {
            return Dice.discardElement(uses);
    }
}
