# RENT A CAR

## Desktop aplikacija
- **Uloga:** Admin  
- **Username:** admin  
- **Password:** admin  

## Mobile aplikacija
- **Uloga:** User  
  - **Username:** test1  
  - **Password:** test  

- **Uloga:** User  
  - **Username:** test2  
  - **Password:** test  
---
Prilikom pokretanja mobilne aplikacije, OBAVEZNO pokrenuti komandu .\setup_env.bat , kako bi se uspostavila ispravna konekcija sa Stripe sistemom plaćanja i kako bi se .env fajl popunio vrijednostima. Tu se OBAVEZNO moraju unijeti oba stripe ključa koja su navedena ispod (ili Vaši lični stripe ključevi).

# Stripe:

stripePublishableKey: pk_test_51PMVHpRrJwr9yxSmwklss7mgn2fcVKJRhsFY5jDJ6aowlBuvfHIathT3Je3EL9pRuer9y2bK16BvhFy3U4M2cJLc00GZ7FLudv
secretKey: sk_test_51PMVHpRrJwr9yxSmTmLhu9D6rFknT703NS22C6gJ45NJ3iwOfwWCtuSpGgT3WvmwUKKsCSkLA1MoR3ZkZsywN40P00G3FljD5O

- **Podaci za Stripe plaćanje:**

Card number: 4242 4242 4242 4242
Date: Bilo koji datum u budućnosti
CVC: Bilo koje 3 cifre
ZIP Code: Bilo kojih 5 cifara

## Napomena ##
U nastavku dokumentacije slijedi **detaljan opis aplikacije** sa svim slikama.

# Desktop aplikacija (Admin)

## 1. Login stranica
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/1.png?raw=true)

Prva stranica aplikacije je login forma namijenjena administratorima.

**Elementi**
- Polja Username i Password
- Ikona za prikaz/sakrivanje lozinke (password toggle)
- Dugme Login za prijavu

**Funkcionalnosti**
- Validacija praznih polja – nije moguće poslati prazan unos.
- Ako korisnik pokuša da se prijavi sa računom koji nije admin dobija poruku:  
  **„Nemate dozvolu za pristup.”**
- Ako su podaci netačni dobija poruku:  
  **„Neispravan username ili password!”**  
  (poruka je generička iz sigurnosnih razloga – ne prikazuje se da li je pogrešan username ili lozinka, čime se otežava eventualni pokušaj napada)

---

## 2. Meni aplikacije
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/2.png?raw=true)

Nakon uspješnog logina, administrator dolazi na glavni meni aplikacije koji se nalazi na lijevoj strani.  
Meni predstavlja centralnu navigaciju kroz sve funkcionalnosti.

**Stavke menija**
- Vozila (defaultna stranica nakon logina)
- Cijene vozila po periodima
- Rezervacije
- Gradovi
- Dodatne usluge
- Recenzije
- Pregledi vozila
- Kontakt
- Korisnici
- Izvještaj
- Profil
- Odjava

---

## 3. Vozila – prikaz svih vozila
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/3.png?raw=true)

Na ovoj stranici administrator ima potpuni pregled svih vozila.

**Funkcionalnosti i elementi**
- Filter po modelu – unosom modela i klikom na dugme Pretraga prikazuju se samo vozila koja odgovaraju kriteriju.
- Dodaj novo vozilo – otvara formu za unos novog vozila.
- Prikaz vozila u gridu (4 u jednom redu):
  - Ikona crvenog ključa (hover tekst: „Pregled vozila i rezervacije”) → vodi na posebnu stranicu za preglede
  - Slika vozila
  - Model automobila
  - Osnovne informacije: godište, motor, tip goriva, kilometraža
  - Dugme **Detalji** – vodi na stranicu sa detaljnim informacijama o vozilu
  - Dugme **Obriši** – brisanje vozila iz baze (uz potvrdu: „Da li sigurno želite obrisati ovo vozilo?”)
  - Padajući meni Opcije:
    - **Activate** – vozilo se prikazuje korisnicima mobilne aplikacije
    - **Hide** – vozilo se sakriva iz pregleda korisnicima

![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/4.png?raw=true)

**Logika stanja**
Vozila funkcionišu preko state mašine i mogu biti u dva stanja:
⦁	Active – vozilo vidljivo korisnicima mobilne aplikacije
⦁	Draft – vozilo sakriveno
- Ako je vozilo sakriveno, a korisnik ga je ranije rezervisao, ono će se i dalje prikazivati u njegovoj listi rezervacija (rezervacija ostaje važeća).

---

## 4. Pregled odabranog vozila
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/5.png?raw=true)

Klikom na crvenu ikonu ključa u listi vozila otvara se stranica za upravljanje pregledima tog vozila.

**Elementi i funkcionalnosti**
- U vrhu: broj zakazanih pregleda za odabrano vozilo
- Sekcija Datumi – lista svih datuma na kojima su zakazani pregledi (lakša navigacija za otkazivanje ili odgađanje)
- Kalendar:
  - Pregledi se mogu zakazivati samo od narednog dana (ne za isti dan)
  - Svaki dan ima znak „+” (hover tekst: „Dodaj vozilo na pregled”) → klik otvara dijalog za odabir vremena pregleda
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/6.png?raw=true)

  - Rezervisani dani → označeni su crvenom bojom i na njima nije moguće zakazati pregled
- Za dane gdje je već zakazan pregled stoji tekst:
  - „Pregled modela: [Naziv modela]”
  - „Vrijeme: [Vrijeme pregleda]”

**Akcije**
- Ikona kante za smeće (hover: „Ukloni pregled vozila”) → brisanje pregleda
- Ikona kalendara s olovkom (hover: „Uredi pregled vozila”) → izmjena termina

---

## 5. Uređivanje vozila
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/8.png?raw=true)

Na ovu stranicu se dolazi klikom na dugme Detalji pored svakog vozila u gridu.

**Funkcionalnosti i logika stranice**
- Ako je vozilo u **Active** stanju:
  - U vrhu stranice se pojavljuje crvena poruka:  
    **„Podaci se ne mogu mijenjati jer je vozilo u active stanju!”**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/7.png?raw=true)
  - Sva polja, padajući meniji, upload slike i dugme **Sačuvaj** su onemogućeni.
  - Ovo pravilo sprječava situaciju da admin mijenja podatke dok korisnik istovremeno pravi rezervaciju.

- Ako je vozilo u **Draft** stanju:
  - Sva polja i opcije su aktivna i moguće ih je mijenjati.

**Elementi stranice**
- Naslov: **Detalji vozila**
- Forma podijeljena u dvije kolone sa sljedećim poljima:
  - Godina proizvodnje
  - Motor
  - Model
  - Marka
  - Kilometraža
  - Gorivo (padajući meni)

- Ispod forme:
  - Tip vozila (padajući meni)
  - Opis – detaljniji opis tipa vozila
  - Dugme **Dodaj tip vozila i opis** → vodi na stranicu za dodavanje novog tipa vozila
  - Dugme **Dodaj tip goriva** → vodi na stranicu za dodavanje tipa goriva
  - Polje **Odaberite novu sliku** – upload nove slike sa preview prikazom prije spremanja
  - Dugme **Sačuvaj** – sprema izmjene

**Validacije**
Sva polja su obavezna.

- **Godina proizvodnje**
  - Obavezno polje
  - Minimalna vrijednost: **1886** (prva godina serijske proizvodnje automobila)
  - Maksimalna vrijednost: **tekuća godina**
  - Dozvoljeni samo numerički unosi

- **Motor**
  - Obavezno polje
  - Dozvoljen format samo u obliku „broj tačka broj” (npr. 1.9, 2.0)

- **Tip goriva (padajući meni)**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/9.png?raw=true)
  - Svaka stavka ima opcije **Edit** i **Delete**
  - Ako se pokuša obrisati gorivo koje koristi rezervisano vozilo → poruka:  
    **„Došlo je do pogreške. Gorivo se ne može obrisati jer neko od vozila koje ima taj tip goriva je rezervisano.”**

- **Tip vozila (padajući meni)**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/10.png?raw=true)
  - Također ima opcije **Edit** i **Delete**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/11.png?raw=true)
  - Isto pravilo kao i kod goriva – tip vozila se ne može obrisati ako ga koristi rezervisano vozilo

---

## 6. Dodavanje novog vozila
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/12.png?raw=true)

Na ovu stranicu se dolazi klikom na dugme **Dodaj novo vozilo** na listi svih vozila.

**Elementi**
- **Naslov:** Dodajte novo vozilo
- **Forma** sa svim istim poljima kao i kod uređivanja vozila:
  - Godina proizvodnje
  - Motor
  - Model
  - Marka
  - Kilometraža
  - Gorivo (padajući meni)
  - Tip vozila (padajući meni)
  - Opis
- **Dugme Dodaj tip vozila i opis** – vodi na stranicu za dodavanje novog tipa vozila
- **Dugme Dodaj tip goriva** – vodi na stranicu za dodavanje tipa goriva
- **Upload slike** (Odaberite novu sliku)
- **Dugme Sačuvaj** – sprema novo vozilo u sistem

**Validacija**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/13.png?raw=true)
- Sva polja su obavezna
- Vozilo se ne može dodati dok sve validacije nisu ispravne

---

## 7. Dodavanje tipa vozila i opisa
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/14.png?raw=true)

Na ovu stranicu se dolazi klikom na dugme **Dodaj tip vozila i opis**.

**Elementi stranice**
- Polje za unos tipa vozila
- Polje za unos opisa
- Dugme **Spremi**

**Validacija**
- Oba polja su obavezna i ne smiju ostati prazna

---

## 8. Dodavanje tipa goriva
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/15.png?raw=true)

Na ovu stranicu se dolazi klikom na dugme **Dodaj tip goriva**.

**Elementi stranice**
- Polje za unos tipa goriva
- Dugme **Spremi**

**Validacija**
- Polje je obavezno i ne smije ostati prazno

---

## 9. Cijene vozila po periodima
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/16.png?raw=true)

Ova stranica služi za definisanje i upravljanje cijenama vozila u zavisnosti od trajanja perioda najma.

**Elementi stranice**
- **Naslov:** Cijene vozila
- **Dva dugmeta iznad tabele:**
  - Dodaj novi period u tabelu
  - Unesite novo vozilo u tabelu
- **Tabela cijena** sa kolonama:
  - **Akcije** – crvena ikona kante za brisanje cijelog reda (hover: „Obriši cijeli redak”)
  - **Vozilo** – prikazana samo slika vozila
  - **Model** – naziv modela vozila
  - **Marka** – naziv marke vozila
  - **Periodi** – maksimalno 3 kolone odjednom, uvijek sortirane od najmanjeg do najvećeg perioda

**Funkcionalnosti tabele**
- **Paginacija perioda:**  
  - Ako postoji više od 3 perioda, ispod tabele se pojavljuje dugme **Sljedeća stranica** (zelene boje)  
  - Kada nema više perioda za prikaz, dugme se mijenja u **Prethodna stranica** (crvene boje), koje vraća na prethodna 3 perioda
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/17.png?raw=true)
- **Hover na naziv perioda** → prikazuje tekst „Uredi period”. Klik otvara dijalog **Uredi trajanje perioda**

**Validacije pri uređivanju perioda**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/18.png?raw=true)
- Format mora biti tačan: „n-n dana”
- Prvi dan mora biti manji od drugog
- Period ne može biti duplikat postojećeg → poruka: „Uneseni period već postoji!”

- Pored naziva svakog perioda stoji crvena ikona kante → „Obriši period”, čime se briše cijeli period za sva vozila (npr. 1-2 dana)

**Unos cijena u kolonama**
- Dozvoljen samo format broja sa tačkom (npr. 67.55)
- Ako korisnik unese slovo ili više od jedne tačke → cijelo polje se automatski briše
- Ispod svake cijene stoji siva ikona kante za brisanje → briše cijenu i zamjenjuje je dugmetom **Unesite cijenu**

**Dodavanje novog vozila u tabelu cijena**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/19.png?raw=true)
Ova forma se prikazuje na stranici **Cijene vozila po periodima** nakon klika na dugme **Unesite novo vozilo u tabelu**.

**Elementi dijaloga**
- Dropdown meni za izbor **Marke vozila**
- Polje **Trajanje** – automatski postavljeno na prvi period iz tabele
- Polje **Cijena** – validacija ista kao i u tabeli:  
  - Samo numerički unos i tačka  
  - Format: „67.55”  
  - Ne smije biti unesen drugi znak ili druga tačka
- Dugmad: **Odustani** i **Spremi**

---

## 10. Dodavanje novog perioda
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/20.png?raw=true)

Na ovu stranicu se dolazi klikom na dugme **Dodaj novi period u tabelu**.

**Elementi stranice**
- **Naslov:** Unos trajanja novog perioda
- **Tekst objašnjenja:**  
  „Dodajte neki novi period za rezervaciju vozila koji ne postoji na prethodnoj tabeli. Nakon toga imate mogućnost da postavljate željene cijene za novi period. Molimo da unesete neku nepostojeću i valjanu vrijednost za trajanje novog perioda.”
- Polje za unos perioda
- Dugme **Spremi**

**Validacije**
- Format mora biti „n-n dana”
- Prvi dan manji od drugog
- Period ne smije već postojati

---

## 11. Rezervacije
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/21.png?raw=true)

Na ovoj stranici se prikazuju sve rezervacije, a u vrhu nalaze se dva polja za pretragu:
- Korisničko ime
- Model vozila
Desno od njih je dugme **Pretraga** koje pokreće filtriranje rezultata.

**Tabela rezervacija** – kolone:
- **Korisnik** – ime korisnika koji je rezervisao vozilo
- **Vozilo (model)** – naziv modela rezervisanog automobila
- **Slika** – prikazana fotografija vozila
- **Početni datum** – od kada počinje rezervacija
- **Završni datum** – do kada traje rezervacija
- **Dodatne usluge** – prikazane usluge koje je korisnik odabrao:  
  - Ako nema usluga → prikazuje se `/`  
  - Ako postoji jedna → prikazuje se njen naziv  
  - Ako ih ima više → prikazuje se plava ikonica "i" (info). Klikom na nju otvara se dijalog **Dodatne usluge** gdje su pobrojane sve usluge + dugme **Zatvori**
- **Grad** – grad u kojem je izvršena rezervacija
- **Cijena (KM)** – ukupna cijena rezervacije (uračunati period + dodatne usluge)
- **Zahtjev za otkazivanje** –  
  - Ako nema zahtjeva → `/`  
  - Ako je korisnik poslao zahtjev → prikazuje se tekst **Na čekanju** i dugme **Potvrdi**, kojim admin potvrđuje otkazivanje

-Rezervacije se mogu samo pregledati – admin nema mogućnost izmjene

---

## 12. Gradovi
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/22.png?raw=true)

Stranica za upravljanje gradovima u kojima posluje Rent-a-Car servis.

**Napomene**
- Grad se ne može obrisati ako je već uključen u neku rezervaciju

**Dugme Dodaj grad** otvara dijalosku formu sa:
- Poljem za unos naziva grada
- Dugmadima **Odustani** i **Dodaj**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/23.png?raw=true)

**Validacije**
- Polje ne smije biti prazno
- Ako grad već postoji → greška: „Grad već postoji!”

**Tabela gradova** – kolone:
- **Gradovi** – nazivi gradova
- **Uređivanje** – plava ikonica olovke → otvara dijalog za izmjenu naziva (validacija: polje ne smije biti prazno)
- **Brisanje** – crvena ikonica kante → briše grad, osim ako je povezan sa rezervacijama (tada je brisanje onemogućeno)

---

## 13. Dodatne usluge
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/24.png?raw=true)

Ovdje se upravlja dodatnim uslugama (npr. GPS, dječija sjedalica, dodatni vozač).

**Napomene**
- Dodatne usluge se ne mogu obrisati ako su već uključene u neku rezervaciju

**Dugme Dodaj dodatnu uslugu** otvara dijalog sa:
- Poljem **Naziv**
- Poljem **Cijena**
- Dugmadima **Odustani** i **Dodaj**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/25.png?raw=true)

**Validacije**
- Polja ne smiju biti prazna
- Cijena mora biti u validnom numeričkom formatu (isto kao i u tabeli)

**Tabela**
- **Dodatne usluge** – naziv usluge
- **Cijena** – cijena usluge
- **Uređivanje** – plava ikonica olovke → otvara dijalog sa poljem za naziv i poljem za cijenu
- **Brisanje** – crvena ikonica kante → briše dodatnu uslugu, osim ako je povezana sa rezervacijama (tada je brisanje onemogućeno)

---

## 14. Recenzije za vozila
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/26.png?raw=true)

Na ovoj stranici prikazane su sve recenzije i reakcije za vozila (lajkovi, dislajkovi, komentari), bez obzira da li se vozila nalaze u active ili draft stanju.

**Prikaz stranice**
- Vozila su raspoređena u gridove po 4 u redu
- Svaki grid sadrži:  
  - Slika vozila
  - Tekst „Model:” i naziv modela
  - Godište, motor, gorivo i kilometraža
  - Ikonice:
    - 👍 Lajk – pored nje broj lajkova
    - 👎 Dislajk – pored nje broj dislajkova
    - 💬 Komentari – pored nje broj komentara + tekst „komentar/a”

**Komentari**
- Klikom na broj komentara otvara se posebna stranica sa listom svih komentara za to vozilo
  - Prikazano je ime i prezime korisnika i ispod njegov komentar
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/27.png?raw=true)

---

## 15. Pregledi vozila
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/28.png?raw=true)

Ova stranica omogućava pregled svih tehničkih pregleda planiranih za vozila.

**Elementi stranice**
- Naslov: „Pregledi za sva vozila”
- Tekst: **Ukupan broj pregleda svih vozila:** → sa desne strane brojčana vrijednost
- Tekst: **Datumi:** → lista svih datuma planiranih pregleda
- Kalendar pregleda:
 - Ako za određeni dan postoji pregled samo jednog vozila → u kalendaru je ispisano:
   - „Pregled modela: [naziv modela]”
   - „Vrijeme: [vrijeme pregleda]”
 - Ako za isti dan više vozila ima pregled → prikazuje se ikona upitnika (?). Klik otvara dijalog:
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/29.png?raw=true)
   - **Naslov:** Svi pregledi na ovaj dan
   - Za svako vozilo posebno prikazano:
     - „Vozilo model: [naziv modela]”
     - „Vrijeme pregleda: [vrijeme pregleda]”
   - Na dnu dijaloga dugme **Zatvori**

---

## 16. Kontakti
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/30.png?raw=true)

Stranica omogućava adminu pregled i upravljanje svim porukama koje su korisnici poslali putem kontakt forme.

**Elementi stranice**
- Na vrhu:
  - Polje **Pretraga po imenu i prezimenu**
  - Dugme **Pretraga** (aktivira filtriranje)
- **Tabela kontakata** – kolone:
  - **Ime i prezime korisnika** – korisnik koji je poslao poruku
  - **Poruka** – sadržaj poruke
  - **Telefon korisnika** – broj telefona
  - **Email korisnika** – e-mail adresa
  - **Ukloni kontakt** – crvena ikona kante za smeće za brisanje kontakta

---

## 17. Korisnici
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/31.png?raw=true)

Stranica omogućava adminu uvid u sve korisnike aplikacije i njihove uloge.

**Elementi stranice**
- Na vrhu:
  - Polje **Pretraga po imenu i prezimenu**
  - Dugme **Pretraga** (pokreće filtriranje)
  - Tekst: **Prikaz uloga za korisnike:** → pored toga dropdown sa dvije opcije:
    - „Prikaži uloge”
    - „Ne prikazuj uloge”

- **Tabela korisnika** – kolone:
  - Ime
  - Prezime
  - Email
  - Telefon
  - Uloge (vidljivo samo ako je uključeno u dropdown opcijama)

---

## 18. Izvještaji
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/32.png?raw=true)

Stranica **Izvještaji** omogućava administratoru pregled i analizu podataka o zaradi, filtriranje po različitim kriterijima te preuzimanje izvještaja u PDF formatu.

**Filteri**
Na vrhu stranice nalaze se četiri filter comboboxa:

- **Korisnici** – podrazumijevana opcija *Svi korisnici*; moguće je odabrati i tačno jednog korisnika
- **Mjeseci** – podrazumijevana opcija *Svi mjeseci*; moguće je odabrati jedan konkretan mjesec
- **Godine** – podrazumijevana opcija *Sve godine*; moguće je odabrati jednu konkretnu godinu
- **Gradovi** – podrazumijevana opcija *Svi gradovi*; moguće je odabrati jedan grad

Desno od filtera nalazi se dugme **Preuzmi PDF**, kojim se generiše i preuzima izvještaj u skladu sa izabranim kriterijima.

**Grafički prikaz podataka**
Ispod filtera nalazi se grafički prikaz ukupne zarade. On se dinamički mijenja zavisno od toga da li je odabran određeni mjesec ili svi mjeseci:

- **Svi mjeseci** – prikazuje se pregled zarade po mjesecima (od januara do decembra)
  - Svaki mjesec je predstavljen kvadratom sa skraćenim nazivom
  - Ispod naziva mjeseca prikazuje se ukupna zarada za taj mjesec
  - Kvadrati su pozicionirani po visini - što je veća zarada, kvadrat je više pozicioniran
  - Ispod kvadrata nalazi se plava linija koja vizuelno prikazuje odnos zarade po mjesecima
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/33.png?raw=true)

- **Određeni mjesec** – prikazuje se pregled po danima tog mjeseca
  - Kolone predstavljaju dane (1–31), a redovi ukupnu zaradu
  - Svaki dan sa zabilježenom zaradom ima tačku na linijskom grafu, pri čemu se plava linija izdiže proporcionalno ostvarenom iznosu
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/34.png?raw=true)


**Tabelarni prikaz podataka**
Ispod grafičkog prikaza nalazi se tabela sa detaljima svih unosa koji odgovaraju kriterijima iz filtera.

**Tabela sadrži sljedeće kolone:**
- Ime
- Prezime
- Grad
- Početni datum
- Završni datum
- Dodatne usluge
- Ukupna cijena

Ako ne postoje podaci za prikaz, umjesto tabele se prikazuje poruka:  
*"Nema podataka za prikaz."*

---

**PDF izvještaj**
Klikom na dugme **Preuzmi PDF** generiše se izvještaj u PDF formatu sa sljedećim sadržajem:
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/35.png?raw=true)

- Ilustrativna slika na vrhu
- Naslov: **Rent a Car Izvjestaj**
- Odabrane vrijednosti iz filtera:
  - Korisnik/ci
  - Mjesec/i
  - Godina/e
  - Grad/ovi
- Tekst: *"Izvještaj generisan na datum:"* uz prikaz tačnog datuma preuzimanja
- Tabela sa podacima:
  - **User** (ime korisnika)
  - Kolone za mjesece od januara do decembra
  - **Total** – ukupna cijena koju je korisnik platio

---

## 19. Profil
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/36.png?raw=true)

Stranica **Profil** omogućava administratoru pregled i uređivanje vlastitih podataka i pristupnih informacija.

**Prikaz stranice**
- **Naslov:** Uredite Vaš profil
- Plava ikonica na vrhu – ilustrativna oznaka da se radi o profilu korisnika
- **Polja prikazana jedno ispod drugog:**
  - Ime – prikazano trenutno ime korisnika
  - Prezime – prikazano trenutno prezime korisnika
  - Email – prikazan trenutno email korisnika
  - Telefon – prikazan trenutni broj telefona

**Postavke profila**
U gornjem desnom uglu nalazi se ikona postavki. Klikom na ikonu pojavljuju se dvije opcije:
- Uredite profil
- Promijenite korisničko ime i lozinku
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/37.png?raw=true)

**19.1. Uređivanje profila**
Omogućava izmjenu osnovnih podataka korisnika.

**Validacije**
- Nijedno polje ne smije ostati prazno
- Email i telefon podliježu potpunoj validaciji formata

**Dugmad**
- **Spasi** – sprema izmjene profila
- **Odustani** – poništava sve nepohranjene promjene

---

**19.2. Promjena korisničkog imena i lozinke**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/38.png?raw=true)

Klikom na opciju *Promijenite korisničko ime i lozinku* otvara se dijaloška forma.

**Elementi dijaloga**
- **Naslov:** Promijenite Vaše pristupne podatke
- **Polja za unos:**
  - Korisničko ime (opcionalno)
  - Trenutna lozinka – ne pojavljuje se greška dok se ne pritisne dugme *Promijenite podatke*
  - Nova lozinka – mora se podudarati s poljem za potvrdu
  - Ponovo unesite novu lozinku – potvrda nove lozinke

**Dugmad**
- **Odustani** – zatvara dijalog bez izmjena
- **Promijenite podatke** – potvrđuje promjene

**Validacije**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/39.png?raw=true)

- Nijedno polje osim polja za korisničko ime ne smije ostati prazno
- Trenutna lozinka se provjerava tek pri potvrdi promjene, čime se sprječava nagađanje lozinke
- Ikona oka uz polja lozinke omogućava prikaz ili skrivanje unesenih znakova
- Nova lozinka i potvrda nove lozinke moraju se podudarati, inače se prijavljuje greška

---

## 20. Odjava
Siguran izlazak iz aplikacije i prekid sesije.

**Funkcionalnosti**
- Klikom na Odjava → sesija se prekida
- Administrator se vraća na početnu Login stranicu
- Svi nedovršeni podaci i filteri se resetuju

**Sigurnosne napomene**
- Odjava osigurava da neovlaštene osobe ne mogu pristupiti podacima administratora ukoliko napuste uređaj bez zatvaranja aplikacije
- Preporučuje se da administrator uvijek koristi opciju **Odjava** kada napušta radno mjesto, posebno u zajedničkim okruženjima
- Nakon odjave, svi podaci i privilegije sesije postaju nedostupni dok se ponovo ne prijavi

---
---
---

# Dokumentacija mobilne aplikacije

## 1. Login stranica
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/40.png?raw=true)

Login stranica predstavlja početnu tačku mobilne aplikacije i omogućava korisnicima siguran pristup sistemu putem Basic autentifikacije.

**Funkcionalnosti**
- Forma sadrži dva obavezna polja:
  - Username
  - Password
- Klikom na dugme **Login** pokreće se proces autentifikacije.
- Ukoliko korisnik pokuša pristupiti sa administratorskim podacima ili unese netačne korisničke podatke, sistem prikazuje poruku:
  "Nemate dozvolu za pristup."

**Dodatne mogućnosti**
- Na dnu stranice nalazi se tekst:
  "Nemate profil? Kreirajte ga ovdje"
- Klikom na link *ovdje* otvara se forma za registraciju novog profila.

---

## 2. Kreiranje novog profila
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/41.png?raw=true)

Kreiranje profila omogućava novim korisnicima pristup mobilnoj aplikaciji.

**Funkcionalnosti**
- Forma sadrži sva obavezna polja potrebna za registraciju.
- Sva polja posjeduju odgovarajuću validaciju:
  - Email mora biti u validnom formatu
  - Broj telefona mora sadržavati numeričke vrijednosti
  - Nijedno polje ne smije ostati prazno

**Navigacija**
- Na dnu stranice nalazi se strelica sa tekstom "Back to Login", koja korisniku omogućava povratak na login stranicu bez završetka procesa registracije.

---

## 3. Stranica Vozila (defaultna stranica)
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/42.png?raw=true)

Nakon uspješne prijave korisnik dolazi na defaultnu stranicu **Vozila**.

**Funkcionalnosti**
- Prikazuju se isključivo vozila koja su od strane administratora postavljena u stanje **Active**.
- Vozila u stanju **Draft** nisu dostupna korisnicima.
- Vozila se prikazuju u gridu raspoređenom po dva vozila u redu.

**Elementi grida:**
- Slika vozila
- Model vozila
- Godište
- Motor
- Gorivo
- Kilometraža
- Dugme **Detalji i preporuke**
- Dugme **Rezerviši vozilo**

**Dodatne opcije**
- Na vrhu stranice nalazi se **Filter po modelu** i dugme **Pretraga**, koje korisniku omogućava filtriranje vozila prema modelu.

---

## 4. Detalji za vozilo i preporuke
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/43.png?raw=true)

Klikom na dugme **Detalji i preporuke** otvara se stranica pod naslovom **Detalji za vozilo i preporuke**.

**Struktura stranice**
- Na vrhu stranice prikazana je slika vozila.
- Neposredno ispod nalazi se dugme **Pregledaj kalendar rezervacija** i tekst:
  "Pogledajte kada je ovo vozilo slobodno za rezervaciju!"

**Sekcija Detalji vozila (dvije kolone)**
- Godina proizvodnje
- Motor
- Model
- Marka
- Kilometraža
- Gorivo

**Dodatni podaci**
- Tip vozila
- Opis vozila

**Sistem preporuka**
- Na dnu stranice integrisan je **Collaborative Filtering (CF) recommender sistem**
- Prikazuju se tri vozila paralelno, uz mogućnost horizontalnog skrolovanja
- Za svako vozilo prikazuje se:
  - Slika
  - Model i marka
  - Godina proizvodnje
  - Kilometraža
  - Gorivo
  - Tip vozila
  - Dugme **Detalji vozila** koje vodi na detalje o tom vozilu

---

## 5. Kalendar rezervacija
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/44.png?raw=true)

Klikom na dugme **Pregledaj kalendar rezervacija** otvara se kalendar sa vizualnim prikazom dostupnosti vozila.

**Legenda boja i ikona**
- Siva boja – današnji datum
- Zelena boja – vozilo je slobodno za rezervaciju
- Crvena boja – vozilo je rezervisano
- Plava boja – vozilo je na popravci

**Napomena**
- Dani označeni crvenom ili plavom bojom sadrže i odgovarajuće ikone za rezervaciju odnosno popravku.

---

## 6. Rezervacija vozila
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/45.png?raw=true)

Klikom na dugme **Rezerviši vozilo** otvara se stranica za rezervaciju vozila.

**Struktura stranice**
- Na vrhu se prikazuje slika vozila
- Ispod slike nalaze se podaci korisnika koji je trenutno ulogovan:
  - Ime, prezime, e-mail, telefon
- Ispod stoji info ikonica (i) koja prikazuje poruku:
  "Vaše podatke možete mijenjati na stavci Profil."
- **Padajući meni Odaberite grad** – lista gradova u kojima je moguće rentati vozilo
- **Sekcija Odaberite dodatne usluge** – lista checkboxova sa dodatnim uslugama koje korisnik može odabrati
- **Padajući meni Period** – odabir željenog trajanja rezervacije
- **Kalendar za odabir perioda:**
  - Onemogućen je odabir dana u prošlosti
  - Onemogućen je odabir dana kada je vozilo već rezervisano ili se nalazi na popravci

**Validacija raspona**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/46.png?raw=true)

- Ako odabrani datum ne omogućava minimalni broj dana, sistem prikazuje upozorenje:
  "Odabrani datum nije moguć jer nije u odabranom rasponu."

**Završetak rezervacije**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/47.png?raw=true)

- Nakon uspješnog odabira, sistem izračunava ukupnu cijenu koja uključuje trajanje i dodatne usluge
- Korisnik može mijenjati period i dodatne usluge dok ne završi rezervaciju
- Klikom na dugme **Dovršite rezervaciju ovdje** otvara se integrisani **Stripe sistem plaćanja**
![image_alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/48.png?raw=true)

- Ukoliko su podaci ispravni, rezervacija se uspješno završava
- U slučaju greške korisnik dobija odgovarajuće upozorenje

---

## 7. Cijene
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/49.png?raw=true)

Stranica **Cijene** omogućava pregled cijena najma vozila prema unaprijed definisanim vremenskim periodima. Stranici se pristupa putem navigacijskog menija smještenog na dnu ekrana mobilne aplikacije.

**Funkcionalnosti**
- U središtu stranice nalazi se tabela sa sljedećim kolonama:
  - **Vozilo** – prikazuje fotografiju vozila
  - **Model** – model vozila
  - **Marka** – marka vozila
  - **Periodi** – u svakom prikazu istovremeno su prikazana tri perioda sa pripadajućim cijenama  
- Za svaki vremenski period prikazana je cijena najma koja može varirati od vozila do vozila
- Periodi su uvijek poredani od najmanjeg prema najvećem

**Navigacija kroz periode**
- Ispod tabele nalazi se zeleni dugmić **Sljedeća stranica**, koji prikazuje naredna tri perioda (ako su dostupna)
- Kada se prikaže posljednji skup perioda, umjesto zelenog dugmeta pojavljuje se crveni dugmić **Prethodna stranica**, koji vraća korisnika na prethodna tri perioda
- Na ovaj način omogućeno je pregledavanje svih perioda po segmentima od po tri

**Dodatne napomene**
- Stranica je responzivna i optimizirana za prikaz većeg broja vozila i perioda
- Stranica podržava horizontalno skrolovanje
- Prikazane cijene ažuriraju se automatski prema unesenim podacima u administrativnom dijelu sistema

---

## 8. Recenzije
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/50.png?raw=true)

Stranica **Recenzije** omogućava korisnicima pregled i interakciju sa povratnim informacijama o vozilima i pruža uvid u iskustva prethodnih korisnika.

**Funkcionalnosti**
- Vozila su prikazana u obliku **grid prikaza** (jedan po redu)
- Za svako vozilo su dostupne sljedeće informacije:
  - Fotografija vozila
  - Model vozila
  - Godište
  - Motor
  - Gorivo
  - Kilometraža

**Ikone ispod osnovnih informacija**
- **Plava ikona (Like)**
  - Ako je samo trenutni korisnik lajkovao vozilo → tekst: "Sviđa vam se"
  - Ako je korisnik lajkovao zajedno sa drugima → tekst: "Vi i X" (X = broj ostalih korisnika)
  - Ako korisnik nije lajkovao → prikazuje se samo ukupan broj lajkova
- **Crvena ikona (Dislike)**
  - Ako je samo trenutni korisnik dislajkovao vozilo → tekst: "Ne sviđa vam se"
  - Ako je korisnik dislajkovao zajedno sa drugima → tekst: "Vi i X"
  - Ako korisnik nije dislajkovao → prikazuje se samo ukupan broj dislajkova
- **Siva ikona (Komentari)** – prikazuje broj komentara i tekst "komentar/a"

**Interaktivne opcije**
- Ikona i tekst **Like** – klikom dodaje lajk (ikona postaje plava)
- Ikona i tekst **Dislike** – klikom dodaje dislajk (ikona postaje crvena)
- Ikona i tekst **Komentar** – klikom otvara stranicu **Ostavite svoj komentar**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/51.png?raw=true)

**Interakcija i ažuriranje podataka**
- Klikom na bilo koju od opcija ("Like", "Dislike", "Komentar") podaci se odmah ažuriraju u prikazu vozila
- Klikom na **Komentar**, korisniku se otvara nova stranica u kojoj može:
  - Dodati novi komentar
  - Urediti postojeći komentar (samo vlastiti)
  - Obrisati postojeći komentar (samo vlastiti)

**Svrha funkcionalnosti**
- Recenzije i ocjene predstavljaju ključan mehanizam za izgradnju povjerenja među korisnicima
- Omogućavaju budućim korisnicima donošenje informisanih odluka o odabiru vozila i pružatelja usluge
- Transparentnost recenzija doprinosi poboljšanju kvaliteta usluge i povećanju zadovoljstva svih korisnika

---

## 19. Upiti
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/52.png?raw=true)

Stranica **Upiti** omogućava korisnicima slanje upita administratoru putem forme. Ova funkcionalnost osigurava direktnu komunikaciju između korisnika i administratorskog tima.

**Funkcionalnosti**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/53.png?raw=true)

- Forma za unos sadrži sljedeća polja:
  - Ime i prezime
  - Telefon
  - Email
  - Poruka
- Sva polja su validirana i ne smiju ostati prazna
- Dodatne validacije:
  - **Telefon** – mora biti u validnom formatu
  - **Email** – mora biti u validnom formatu
- Na dnu forme nalazi se dugme **Pošalji upit**
- Kada su sva polja ispravno popunjena i dugme kliknuto, upit se šalje putem **RabbitMQ** servisa
- Upit se registruje u odgovarajućem **queue-u (kontakt_notifications)**, što omogućava administratoru da preuzme i obradi zahtjev
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/54.png?raw=true)

![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/55.png?raw=true)


**Napomena**
- Ova funkcionalnost osigurava asinhronu obradu upita – korisnik ne mora čekati dok administrator odgovori, jer se upit sigurno pohranjuje u sistem

---

## 20. Profil
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/56.png?raw=true)

Stranica **Profil** dostupna je putem navigacijskog menija i prikazuje osnovne informacije o ulogovanom korisniku, aktivne rezervacije i opcije za upravljanje korisničkim računom.

**Osnovni prikaz**
- U gornjem desnom uglu nalaze se dvije ikone:
  - Postavke
  - Odjava
- U sredini pri vrhu prikazana je plava ilustracija profila
- Ispod ikone prikazani su osnovni korisnički podaci:
  - Ime i prezime
  - Email
  - Telefon

**Aktivne rezervacije**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/57.png?raw=true)

- Ispod osnovnih podataka prikazane su sve aktivne rezervacije korisnika (jedna po redu)
- Svaka rezervacija sadrži:
  - Slika vozila
  - Grad (mjesto rezervacije)
  - Datum početka rezervacije
  - Datum završetka rezervacije
  - Dodatne usluge (lista odabranih usluga - ako ih ima)
  - Ukupna cijena
  - Crveno dugme **Poništi rezervaciju**
- Klikom na dugme **Poništi rezervaciju**:
  - Zahtjev se šalje administratoru i čeka potvrdu
  - Dugme se zamjenjuje tekstom: "Zahtjev za otkazivanje na čekanju."

**Postavke**
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/58.png?raw=true)

- Klikom na ikonu **Postavke** otvara se meni sa dvije opcije:
  1. **Uredite profil**  
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/59.png?raw=true)

     - Omogućava izmjenu ličnih podataka (ime, prezime, email, telefon)
     - Sva polja su obavezna i validirana
     - Dugmad: **Spasi** i **Odustani**
  2. **Promijenite pristupne podatke**  
![image alt](https://github.com/Dzenko123/Rent-a-car/blob/098a164dfca787a8a1aba7107eca9d7ac3a35bae/RentACarImg/60.png?raw=true)

     - Otvara formu sa sljedećim poljima:
       - Korisničko ime (opcionalno)
       - Trenutna lozinka
       - Nova lozinka
       - Ponovo unesite novu lozinku
     - Polja za lozinke su obavezna i strogo validirana
     - Lozinke se mogu prikazati/sakrivati (ikona oka)
     - Nova lozinka i potvrda nove lozinke moraju se podudarati

**Odjava**
- Klikom na ikonu **Odjava**, korisnik se odjavljuje iz aplikacije i preusmjerava na Login stranicu
- Sesija se prekida i podaci postaju nedostupni dok se korisnik ponovo ne prijavi
