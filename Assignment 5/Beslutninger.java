import java.util.Scanner;

public class Beslutninger{
    public static void main(String[] args){
	Scanner in;
	int alder;
	in = new Scanner(System.in);
	alder = Integer.parseInt(in.nextLine());
	if(alder<18){
	    System.out.println("Du er ikke mynding");
	}
	else{
	    System.out.println("Du er Myndig");
	}
    }
}