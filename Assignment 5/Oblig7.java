/** 
 * Et DVD administrasjons program
 * Et program for å holde orden på hvilke DVDer eies og laanes av hvem
 * @author: Kasper Skjeggestad
 * @version: 2014-10-22
 */

import java.util.*;
import java.io.*;

public class Oblig7{

    static HashMap<String, Person> personer = new HashMap<>();
    static HashMap<String, Dvd> dvder = new HashMap<>();
    static Scanner in = new Scanner(System.in);

    /**
     * En metode for å sende deg til de forskjellige komandoene
     */
    public static void hovedMeny(){

	loop: while (true){
	    System.out.println("Du har foelgende valg");
	    System.out.println("");
	    System.out.println("K: Kjoep DVD");
	    System.out.println("L: Laan DVD");
	    System.out.println("O: Oversikt over alle personene");
	    System.out.println("R: Retuner film");
	    System.out.println("V: Vis dvder til en person");
	    System.out.println("H: Vis Dvd hyllene til alle personer");
	    System.out.println("N: Legg til ny person");
	    System.out.println("A: Avslutt");

	    String k = in.nextLine();
	    switch(k){
	    case("K"): kjoepDvd();
		break;
	    case("L"): laanDvd();
		break;
	    case("O"): oversikt();
		break;
	    case("R"): returnerDvd();
		break;
	    case("V"): vis();
		break;
	    case("H"): visHylle();
		break;
	    case("N"): nyPerson();
		break; 
	    case("A"):
		break loop;
	    }
	}
    }

    public static void tilbakeTilMeny(){
	System.out.println("Enter: Returner til Hovedmeny");
	in.nextLine();
    }

    /**
     * En metode for aa sende kjoepe dvd
     */
    public static void kjoepDvd(){
	System.out.println();
	System.out.println("Skriv inn navent paa kjoeperen: ");
	String p = in.nextLine();

	if (personer.containsKey(p)){
	    System.out.println("Skriv inn navn paa DvD " + p + " oensker aa kjoepe" );
	    String titel = in.nextLine();

	    if (dvder.containsKey(titel) && dvder.get(titel).hentEier().toString().equals(p)) System.out.println(p + " eier alleredie " + titel);
	    else {
		Dvd dvd = new Dvd(titel, personer.get(p));
		dvder.put(titel,dvd);
		personer.get(p).leggTilDvd(dvd);
		System.out.println(p + " eier naa " + titel);
	    }
	}
	else{
	    System.out.println("Personen finnes ikke i systemet");
	}
	System.out.println();
	tilbakeTilMeny();
    }

    /**
     * En metode for aa laane filmer
     */
    public static void laanDvd(){
	System.out.println();
	System.out.println("Hvem skal laane DvD? Disse personene er i systemet:");
	for (Person p: personer.values()) System.out.println(p);
	String p = in.nextLine();

	if (personer.containsKey(p)){
	    System.out.println("Hvem oensker " + p + " aa laane fra?");
	    String utlaaner = in.nextLine();

	    if (personer.containsKey(utlaaner)){
		System.out.println("Hvilken DvD oensker " + p + " aa laane, " + utlaaner + " har disse dvdene;");
		personer.get(utlaaner).visDvdHylle();
		String d = in.nextLine();

		if (personer.get(utlaaner).hentHylle().containsKey(d)){
		    if (personer.get(utlaaner).hentHylle().get(d).hentLaaner() == null){
			dvder.get(d).settLaaner(personer.get(p));
			personer.get(utlaaner).fjernDvd(d);
			personer.get(p).leggTilDvd(dvder.get(d));
			System.out.println(p + " laaner naa " + d + " av " + dvder.get(d).hentEier());
		    }
		    else System.out.println(utlaaner + " eier ikke denne DvDen selv, og kan derfor ikke laane den ut"); 
		}
		else System.out.println (utlaaner + " har ikke denne DvDen");
	    }
	    else System.out.println(utlaaner + " finnes ikke i systemet");
	}
	else System.out.println(p + " finnes ikke i systemet");
	System.out.println();
	tilbakeTilMeny();
    }

    /**
     * En metode for aa legge til en ny person i systemet
     */
    public static void nyPerson(){
	System.out.println("Skriv inn navn paa ny person i systemet");
	Person p = new Person(in.nextLine());
	personer.put(p.toString(),p);
	System.out.println(p + " er lakt inn i systemet");
	System.out.println();
	tilbakeTilMeny();
    }

    /**
     * En metode for aa faa en oversikt over personer og filmer
     */
    public static void oversikt(){
	System.out.println();
	for (Person p: personer.values()){
	    int eier = 0;
	    int laaner = 0;
	    HashMap<String,Dvd> hylle = p.hentHylle();
	    for (Dvd d: dvder.values())	{
		if (d.hentEier().toString().equals(p.toString())) eier++;
	    }
	    for (Dvd d: hylle.values()) if (!(d.hentLaaner() == null)) laaner++;
	    System.out.println(p + ":");
	    System.out.println("Antall DvDer i hyllen: " + p.hentAntall());
	    System.out.println("Eier totalt: " + eier);
	    System.out.println("Laaner: " + laaner);
	    System.out.println();
	}
	System.out.println();
	tilbakeTilMeny();
    }

    /**
     * En metode for aa levere tilbake laant dvd
     */
    public static void returnerDvd(){
	System.out.println();
	System.out.println("Hvem skal returnere en laant dvd? Personene i systemet er:");
	for (Person p: personer.values()) System.out.println(p);
	String p = in.nextLine();
	if (personer.containsKey(p)){
	    System.out.println("Hvilken Dvd oensker " + p + " aa returnere? " + p + " har laant disse dvdene");
	    for (Dvd d: personer.get(p).hentHylle().values()){
		if (!(d.hentLaaner() == null)) System.out.println(d + " laant av " + d.hentEier());
	    }
	    String returner = in.nextLine();

	    personer.get(p).returnerDvd(returner);
	}
	else{
	    System.out.println("Denne personen finnes ikke i systemet");
	}
	System.out.println();
	tilbakeTilMeny();
    }

    /**
     * En oversikt ovrer hvilke dvder en person har
     */
    public static void vis(){
	System.out.println();
	System.out.println("Skriv inn navne paa personen du vil vise dvdene til");
	String s = in.nextLine();
	System.out.println();
	if (s.equals("*")){
	    for (Person p: personer.values()){
		System.out.println(p + ":");
		for (Dvd d: dvder.values()){
		    if (d.hentEier().toString().equals(p.toString())){
			System.out.print(d);
			if (!(d.hentLaaner() == null)){ 
			    System.out.println(" laant bort til " + d.hentLaaner());
			}
			else System.out.println();
		    }
		}
		System.out.println();
	    }
	}
	else if (personer.containsKey(s)){
	    System.out.println(s + ":");
	    for (Dvd d: dvder.values()){
		if (d.hentEier().toString().equals(s)){
		    System.out.print(d);
		    if (!(d.hentLaaner() == null)) System.out.println(" laant bort til " + d.hentLaaner());
		    else System.out.println();
		}
	    }
	}
	else System.out.println("personen finnes ikke");
	System.out.println();
	tilbakeTilMeny();
    }

    /**
     * En metode for aa vise hva alle personene i systemet har i hyllene
     */
    public static void visHylle(){
	System.out.println();
	for (Person p: personer.values()){
	    System.out.println(p);
	    p.visDvdHylle();
	    System.out.println();
	}
	System.out.println();
	tilbakeTilMeny();
    }

    /**
     * Hovedmetoden for programmet
     * Leser inn fil ved navn dvdarkiv.txt. Foerste linje i filen er navn paa en person, de neste linjene er dvdene han eller hun har
     * Dersom en dvd begynner med *, er denne dvden laant og den neste linen visr navnet paa hvem som eier den
     * Når programmet avsluttes, skriver den inn alle personene i filen paa samme maate som den leser fra den
     */
    public static void main(String[] args) throws Exception{
	Scanner fil = new Scanner(new File("dvdarkiv.txt"));
	ArrayList<String> dvdArkiv = new ArrayList<>();

	while (fil.hasNextLine()){
	    dvdArkiv.add(fil.nextLine());
	}

	for (String s: dvdArkiv){
	    System.out.println(s);
	}

	int test = 1;
	Person person = null;
	Dvd dvd = null;

	for (int i = 0; i < dvdArkiv.size(); i++){

	    if (dvdArkiv.get(i).equals("")){
		test = 1;
	    }
	    else if (test == 3){
		test = 2;
	    }
	    else if (test == 2){

		if (dvdArkiv.get(i).startsWith ("*")){
		    if (personer.containsKey(dvdArkiv.get(i+1))){
			dvd = new Dvd(dvdArkiv.get(i).substring(1),personer.get(dvdArkiv.get(i+1)));
			dvd.settLaaner(person);
			person.leggTilDvd(dvd);
			dvder.put(dvd.toString(),dvd);
		    }
		    else{
			personer.put(dvdArkiv.get(i+1),new Person(dvdArkiv.get(i+1)));
			dvd = new Dvd(dvdArkiv.get(i).substring(1),personer.get(dvdArkiv.get(i+1)));
			dvd.settLaaner(person);
			dvder.put(dvd.toString(),dvd);
			person.leggTilDvd(dvd);
		    }
		    test++;
		}
		else{
		    dvd = new Dvd(dvdArkiv.get(i),person);
		    dvder.put(dvdArkiv.get(i),dvd);
		    person.leggTilDvd(dvd);
		}
	    }
	    else if (test == 1){
		if (!personer.containsKey(dvdArkiv.get(i))){
		    person = new Person(dvdArkiv.get(i));
		    personer.put(dvdArkiv.get(i),person);
		}
		else{
		    person = personer.get(dvdArkiv.get(i));
		}
		test++;
	    }
	}

	hovedMeny();


	PrintWriter w = new PrintWriter("dvdarkiv.txt");

	for (Person p: personer.values()){
	    w.println(p.toString());
	    HashMap<String,Dvd> hylle = p.hentHylle();
	    for (Dvd d: hylle.values()){
		if (!(d.hentLaaner() == null)){
		    w.print("*");
		    w.println(d.toString());
		    w.println(d.hentEier());
		}
		else w.println(d.toString());
	    }
	    w.println();
	}
	w.close();

    }
}
