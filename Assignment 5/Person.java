/**
 * En Person
 *  En person til DVD administrasjons programmet
 * @author: Kasper Skjeggestad
 * @version; 2014-10-22
 */

import java.util.ArrayList;
import java.util.HashMap;

public class Person{

    String navn;
    HashMap<String, Dvd> dvdHylle = new HashMap<>();
    /**
     *Lager en person med navn n
     * @param n navnet til personen
     */
    Person(String n){
	navn = n;
    }

    /**
     * Las klassen sende ut navnet
     * @return navnet
     */
    public String toString(){
	return navn;
    }
    /**
     * Legger til en dvd i dvdsammlinen til personen
     * @param d dvden som legges til sammlingen
     */
    public void leggTilDvd(Dvd d){
	dvdHylle.put(d.toString(), d);
    }

    public void laanDvd(Person p, String s){
	Dvd d = p.laanUtDvd(s);
	dvdHylle.put(s,d);
    }

    public Dvd laanUtDvd(String s){
	Dvd d =	dvdHylle.get(s);
	dvdHylle.remove(s);
	return d;
    }

    public int hentAntall(){
	return dvdHylle.size();
    }

    public HashMap<String,Dvd> hentHylle(){
	return dvdHylle;
    }

    public void fjernDvd(String d){
	dvdHylle.remove(d);
    }

    /**
     * Returnerer en laant dvd til eieren
     * @param t titelen paa dvden du onsker aa levere
     */
    public void returnerDvd(String t){
	if (dvdHylle.containsKey(t)){
	    if (!(dvdHylle.get(t).hentLaaner() == null)){
		dvdHylle.get(t).settLaaner(null);
		dvdHylle.get(t).hentEier().leggTilDvd(dvdHylle.get(t));
		dvdHylle.remove(t);
		System.out.println(t + " har blitt returnet til eier");
	    }
	    else System.out.println(navn + " laaner ikke denne DvDen, den tillhoerer " + navn + " selv");
	}
	else System.out.println(navn + " har ikke laant denne DvDen");
    }

    public void visDvdHylle(){
	for (Dvd d: dvdHylle.values()){
	    System.out.print(d);

	    if (!(d.hentLaaner() == null)) System.out.println(" laant av " + d.hentEier());
	    else System.out.println();
	}
    }
}