# Coffee-Machine-Vivado

Proiectul presupune implementarea unui automat de cafea care trebuie sa aiba urmatoarele functionalitati:
    Posibilitatea de introducere a monedelor simulata printr-un semnal (poate fi legat la un switch);
            - Monedele vor avea mereu valoarea 1;
    Posibilitatea de a alege un tip de cafea:
            o Americano (costa 3 si dureaza 5 secunde);
            o Cappucino (costa 4 si dureaza 7 secunde);
            o Ceai (costa 2 si dureza 4 secunde).
    Posibilitatea de a cere restul. (Resetarea soldului cu ajutorul unui buton sau switch)
Utilizatorul va introduce monede cu ajutorul unui switch (sau buton), apoi va selecta o bautura (buton sau switch), dupa care pe display-urile BCD va aparea numaratoarea inversa. In tot acest timp va fi afisat si soldul curent. La final se va reseta soldul automat.
Pentru a sti statusul curent, 3 led-uri vor fi aprinse pe rand, fiecare reprezentand o stare diferita:
      Unul va fi aprins cat timp aparatul este in starea Idle (nu prepara nimic);
      Unul va fi aprins cat timp aparatul prepara bautura;
      Unul se va aprinde timp de 5 secunde daca utilizatorul alege o bautura insa nu a introdus destui bani.

Punctaje:
  Introducere monede 1p;
  Afisare sold 1p;
  Functionalitate creare bautura 3p;
  Fiecare tip de bautura 0.5p;
  Afisare durata 1p;
  Buton rest 0.5p;
  Rest automat la final 1p;
  Led-uri status 1p;
  Oficiu 1p;
In functie de cat de complete sunt implementate aceste functionalitati vor varia punctajele.
