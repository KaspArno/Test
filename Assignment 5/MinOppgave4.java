import java.util.Scanner;
import java.io.File;

// Les inn en fil og skriv den inn i et array for saa aa skriv ut teksten i en linje, hvis det kommer et punktum, bytt linje

public class MinOppgave4{

    public static void main(String[] args) throws Exception{
	File filNavn = new File("README.txt");
	Scanner in = new Scanner(filNavn);
	int teller = 1;

	while (in.hasNextLine()){ // Setter in en teller for å finne ut hvor lang filen er
	    in.nextLine();
	    teller++;
	}

	String[] tekst = new String[teller];
	int i = 0;
	in = new Scanner(filNavn); // resetter in variabelen min saa den begynner fra begynnelsen av filen igjen

	while (in.hasNextLine()){
	    tekst[i] = in.nextLine();
	    System.out.print(tekst[i]); // Skriver ut teksten paa skjermen
	    System.out.print(" ");
	    if (tekst[i].equals(".")){ // sorger for at den bytter linje ved punktum
		System.out.println();
	    }
	    i++;		//  sorger for at i oker
	}  
    }
}