program sortowanie;

uses
  SysUtils;

const
  MAKSYMALNA_ILOSC_WIERSZY = 1000;

type
  WierszePliku = array[1..MAKSYMALNA_ILOSC_WIERSZY] of AnsiString;

{ pobierzDaneOdUzytkownika
   Pobiera dane wpisane przez uzytkownika wyswietlajac podany komunikat.
 Argumenty:
   komunikatDlaUzytkownika:string - komunikat jaki ma zostac wyswietlony
                                  uzytkownikowi przed pobraniem danych.
 Zwraca:
   Dane wpisane przez uzytkownika.
}
  function pobierzDaneOdUzytkownika(komunikatDlaUzytkownika: string): string;
  var
    pobraneDane: string;
  begin
    Write(komunikatDlaUzytkownika, ': ');
    readln(pobraneDane);
    pobierzDaneOdUzytkownika := pobraneDane;
  end;

{ pobierzSciezkeDoIstniejacegoPlikuOdUzytkownika
   Pobiera _poprawna_ sciezke do pliku wpisana przez uzytkownika wyswietlajac
   podany komunikat. Poprawna sciezka to taka, ktora wskazuje na istiejacy plik.
 Argumenty:
   komunikatDlaUzytkownika:string - komunikat jaki ma zostac wyswietlony
                                  uzytkownikowi przed pobraniem danych.
 Zwraca:
   Poprawna sciezka do pliku podana przez uzytkownika.
}
  function pobierzSciezkeDoIstniejacegoPlikuOdUzytkownika(komunikatDlaUzytkownika: string): string;
  var
    pobranaSciezka: string;
    plikIstnieje: boolean;
  begin
    repeat
      pobranaSciezka := pobierzDaneOdUzytkownika(komunikatDlaUzytkownika);
      plikIstnieje := FileExists(pobranaSciezka);
      if not plikIstnieje then
        writeln('Podana sciezka jest nieprawidlowa!');
    until plikIstnieje;
    pobierzSciezkeDoIstniejacegoPlikuOdUzytkownika := pobranaSciezka;
  end;

{ jestPoprawnaNazwaPliku
   Sprawdza czy podana nazwa pliku jest poprawna i czy mozna jej uzyc do
   stworzenia pliku.
 Argumenty:
   nazwaPliku:string - nazwa pliku jaka powinna byc poddana weryfikacji.
 Zwraca:
   True - jezeli plik o podanej nazwie moze zostac stworzony;
   False - jezeli plik o podanej nazwie NIE moze zostac stworzony.
}
  function jestPoprawnaNazwaPliku(nazwaPliku: string): boolean;
  var
    i: integer;
    niedozwoloneZnaki: array[1..9] of char = ('*', ':', '?', '"', '<', '>', '|', '/', '\');
    nazwaZawieraNiedozwoloneZnaki: boolean;
  begin
    nazwaZawieraNiedozwoloneZnaki := False;
    for i := 1 to High(niedozwoloneZnaki) do
    begin
      if pos(niedozwoloneZnaki[i], nazwaPliku) <> 0 then
      begin
        nazwaZawieraNiedozwoloneZnaki := True;
        break;
      end;
    end;
    jestPoprawnaNazwaPliku := not nazwaZawieraNiedozwoloneZnaki;
  end;

{ pobierzNazwePlikuOdUzytkownika
   Pobiera _poprawna_ nazwe pliku wpisana przez uzytkownika wyswietlajac
   podany komunikat. Nazwa pliku nie moze zawierac znakow : * ? " < > |
   Zobacz takze: jestPoprawnaNazwaPliku
 Argumenty:
   komunikatDlaUzytkownika:string - komunikat jaki ma zostac wyswietlony
                                  uzytkownikowi przed pobraniem danych.
 Zwraca:
   Poprawna nazwa pliku podana przez uzytkownika.
}
  function pobierzNazwePlikuOdUzytkownika(komunikatDlaUzytkownika: string): string;
  var
    pobranaNazwa: string;
    nazwaJestPoprawna: boolean;
  begin
    repeat
      pobranaNazwa := pobierzDaneOdUzytkownika(komunikatDlaUzytkownika);
      nazwaJestPoprawna := jestPoprawnaNazwaPliku(pobranaNazwa);
      if not nazwaJestPoprawna then
        writeln('Podana nazwa jest nieprawidlowa. Zawiera niedozwolone znaki!');
    until nazwaJestPoprawna;
    pobierzNazwePlikuOdUzytkownika := pobranaNazwa;
  end;

{ pobierzWierszeZPliku
   Pobiera wiersze z pliku o podanej sciezce. Maksymalna ilosc wierszy jaka
   moze byc odczytana z pliku wynosi 1000.
 Argumenty:
   sciezkaDoPliku:string - sciezka do pliku w ktorym znajduja sie wiersze do
                         odczytania
 Zwraca:
   Wiersze pliku (max. 1000)
}
  function pobierzWierszeZPliku(sciezkaDoPliku: string): WierszePliku;
  var
    plik: Text;
    odczytaneWiersze: WierszePliku;
    i: integer;
  begin
    i := 1;
    Assign(plik, sciezkaDoPliku);
    Reset(plik);
    repeat
      ReadLn(plik, odczytaneWiersze[i]);
      Inc(i);
    until (EOF(plik) or (i >= MAKSYMALNA_ILOSC_WIERSZY));
    Close(plik);
    pobierzWierszeZPliku := odczytaneWiersze;
  end;

{ zapiszWierszeDoPliku
   Zapisuje podane wiersze do pliku o podanej sciezce. Maksymalna ilosc wierszy jaka
   moze byc zapisana do pliku wynosi 1000.
 Argumenty:
   sciezkaDoPliku:string - sciezka do pliku w ktorym znajda sie wiersze do
                         zapisu
   wierszeDoZapisu:WierszePliku - wiersze ktore maja sie znalezc w pliku
}
  procedure zapiszWierszeDoPliku(sciezkaDoPliku: string; wierszeDoZapisu: WierszePliku);
  var
    plik: Text;
    i: integer;
    iloscWierszyDoZapisu: integer;
  begin
    i := 1;
    iloscWierszyDoZapisu := High(wierszeDoZapisu);
    Assign(plik, sciezkaDoPliku);
    Rewrite(plik);
    repeat
      if (Length(wierszeDoZapisu[i]) > 0) then
        WriteLn(plik, wierszeDoZapisu[i]);
      Inc(i);
    until i >= iloscWierszyDoZapisu;
    Close(plik);
  end;

{ podajDlugoscKrotszegoCiagu
   Porownuje podane ciagi i zwraca dlugosc (Length) krotszego z nich.
 Argumenty:
   ciagA:string - dowolny ciag znakow
   ciagB:string - dowolny ciag znakow
 Zwraca:
   Dlugosc (Length) krotszego ciagu.
}
  function podajDlugoscKrotszegoCiagu(ciagA: string; ciagB: string): integer;
  begin
    if (Length(ciagA) < Length(ciagB)) then
      podajDlugoscKrotszegoCiagu := Length(ciagA)
    else
      podajDlugoscKrotszegoCiagu := Length(ciagB);
  end;

{ pobierzLitereZCiagu
   Pobiera litere o podanej pozycji z podanego ciagu.
 Argumenty:
   pozycjaLitery:integer - pozycja na ktorej znajduje sie litera w ciagu
   ciag:string - dowolny ciag znakow
 Zwraca:
   Litera ktora znajduje sie na pozycji pozycjaLitery w ciagu 'ciag'.
}
  function pobierzLitereZCiagu(pozycjaLitery: integer; ciag: string): char;
  begin
    pobierzLitereZCiagu := upcase(ciag[pozycjaLitery]);
  end;

{ sortujWiersze
   Sortuje (babelkowo) podane wiersze.
 Argumenty:
   wiersze:WierszePliku - wiersze jakie maja zostac posortowane.
 Zwraca:
   Posortowane wiersze.
}
  function sortujWiersze(wiersze: WierszePliku): WierszePliku;
  var
    aktualny, nastepny, pozycjaLitery, przedostatniWiersz, dlugoscKrotszegoWiersza: integer;
    literaWierszaAktualnego, literaWierszaNastepnego: char;
    wystapilaZamiana: boolean;

    { zamienWiersze
       Zamienia dwa wiersze o podanych indeksach miejscami.
     Argumenty:
       indeksWierszaA:integer - dowolny indeks wiersza w tablicy 'wiersze'.
       indeksWierszaB:integer - dowolny indeks wiersza w tablicy 'wiersze'.
    }
    procedure zamienWiersze(indeksWierszaA: integer; indeksWierszaB: integer);
    var
      wierszPomocniczy: string;
    begin
      wierszPomocniczy := wiersze[indeksWierszaA];
      wiersze[indeksWierszaA] := wiersze[indeksWierszaB];
      wiersze[indeksWierszaB] := wierszPomocniczy;
    end;

  begin
    przedostatniWiersz := High(wiersze) - 1;
    repeat
      wystapilaZamiana := False;
      for aktualny := 1 to przedostatniWiersz do
      begin
        nastepny := aktualny + 1;
        dlugoscKrotszegoWiersza := podajDlugoscKrotszegoCiagu(wiersze[aktualny], wiersze[nastepny]);

        for pozycjaLitery := 1 to dlugoscKrotszegoWiersza do
        begin
          literaWierszaAktualnego := pobierzLitereZCiagu(pozycjaLitery, wiersze[aktualny]);
          literaWierszaNastepnego := pobierzLitereZCiagu(pozycjaLitery, wiersze[nastepny]);
          if literaWierszaAktualnego > literaWierszaNastepnego then
          begin
            zamienWiersze(aktualny, nastepny);
            wystapilaZamiana := True;
          end;
          if (literaWierszaNastepnego = literaWierszaAktualnego)
          and (pozycjaLitery = dlugoscKrotszegoWiersza)
          and (Length(wiersze[aktualny]) > Length(wiersze[nastepny])) then
          begin
            zamienWiersze(aktualny, nastepny);
            wystapilaZamiana := True;
          end;
          if literaWierszaAktualnego <> literaWierszaNastepnego then
            Break;
        end;
      end;
    until wystapilaZamiana = False;

    sortujWiersze := wiersze;
  end;

{ trymujWiersze
   Trymuje (usuwa puste) wiersze w podanych wierszach.
 Argumenty:
   wiersze:WierszePliku - zbior wierszy z jakich maja zostac usuniete puste wiersze.
 Zwraca:
   Wytrymowane wiersze.
}
  function trymujWiersze(wiersze: WierszePliku): WierszePliku;
  var
    indeks, indeksWytrymowanych: integer;
    wytrymowaneWiersze: WierszePliku;
  begin
    indeksWytrymowanych := 1;
    for indeks := 1 to High(wiersze) do
      if Length(wiersze[indeks]) > 0 then
      begin
        wytrymowaneWiersze[indeksWytrymowanych] := wiersze[indeks];
        Inc(indeksWytrymowanych);
      end;
    trymujWiersze := wytrymowaneWiersze;
  end;

var
  plikZNieposortowanymiWierszami: Text;
  plikZPosortowanymiWierszami: Text;

  sciezkaDoPlikuZNieposortowanymiWierszami: string;
  sciezkaDoPlikuZPosortowanymiWierszami: string;

  nieposortowaneWiersze: WierszePliku;
  posortowaneWiersze: WierszePliku;

begin
  sciezkaDoPlikuZNieposortowanymiWierszami :=
    pobierzSciezkeDoIstniejacegoPlikuOdUzytkownika('Prosze podac poprawna sciezke do pliku z nieposortowanymi danymi');
  nieposortowaneWiersze := pobierzWierszeZPliku(sciezkaDoPlikuZNieposortowanymiWierszami);

  posortowaneWiersze := sortujWiersze(trymujWiersze(nieposortowaneWiersze));

  sciezkaDoPlikuZPosortowanymiWierszami :=
    pobierzNazwePlikuOdUzytkownika('Prosze podac nazwe pliku do ktorego beda zapisane posortowane dane');
  zapiszWierszeDoPliku(sciezkaDoPlikuZPosortowanymiWierszami, posortowaneWiersze);

  writeln('Zapisano poprawnie. Nacisnij enter, aby zakonczyc.');
  readln();
end.
