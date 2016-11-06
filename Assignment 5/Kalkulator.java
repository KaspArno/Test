import java.util.Scanner;

public class Kalkulator{

    // en metode for addisjon
	public static int addisjon(int tall1, int tall2){
	int sum = tall1+tall2;
	return sum;
    }

    //  en metode for subtraksjonm
    public static int subtraksjon(int tall1, int tall2){
	int diff = tall1-tall2;
	return diff;
    }

    // en metode for heltallsdivisjon
    public static int heltallsdivisjon (int tall1, int tall2){
	int helDiv = tall1/tall2;
	return helDiv;
    }

    //  en metode for divisjon
    public static double divisjon(double tall1, double tall2){
	double div = tall1/tall2;
	return div;
    }

    //  main metode som tar inn tall
    public static void main(String[] args){
	Scanner in = new Scanner(System.in);
	System.out.println("skriv inn to tall");
	System.out.print("tall1: ");
	int tall1 = Integer.parseInt(in.nextLine()); // Lar brukerern skrive inn 2 tall
	System.out.print("tall2: ");
	int tall2 = Integer.parseInt(in.nextLine());

	int sum = addisjon(tall1,tall2); // sender inn tallene og lager summen av de

	int addSvar = addisjon(3,4);

	System.out.println(sum);
	System.out.println(addSvar);

	System.out.println("skriv inn to tall"); // lar brukeren skrive inn to nye tall, ser i etterkant at dette kunne vært en metode
	System.out.print("tall1: ");
	tall1 = Integer.parseInt(in.nextLine());
	System.out.print("tall2: ");
	tall2 = Integer.parseInt(in.nextLine());

	int diff = subtraksjon(tall1,tall2); // Finner differansen til tallene

	int subSvar = subtraksjon(5,2);

	System.out.println(diff);
	System.out.println(subSvar);

	System.out.println("skriv inn to tall"); // kunne igjen faatt bruk for denne metoden her... men orker ikke gjore om paa det naa
	System.out.print("tall1: ");
	tall1 = Integer.parseInt(in.nextLine());
	System.out.print("tall2: ");
	tall2 = Integer.parseInt(in.nextLine());

	int helDiv = heltallsdivisjon(tall1,tall2);

	int helDivSvar = heltallsdivisjon(10,3);

	System.out.println(helDiv);
	System.out.println(helDivSvar);

	System.out.println("skriv inn to tall"); // ah, her er det ikke sikkert jeg kunne brukt samme  metode som jeg kunne ha gjort paa de andre over, for her trenger jeg double!
	System.out.print("tall1: ");
	double tall3 = Double.parseDouble(in.nextLine());
	System.out.print("tall2: ");
	double tall4 = Double.parseDouble(in.nextLine());

	double div = divisjon(tall3,tall4); // Sender de av gaarde til helltallsdividjonsmetoden

	double DivSvar = divisjon(10,3);

	System.out.println(div);
	System.out.println(DivSvar);



    }
}