program sortowanie;

uses
  SysUtils;

const
  MAKSYMALNA_ILOSC_WIERSZY = 1000;

type
  WierszePliku = array[1..MAKSYMALNA_ILOSC_WIERSZY] of string;

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

{ pobierzSciezkeDoPlikuOdUzytkownika
   Pobiera _poprawna_ sciezke do pliku wpisana przez uzytkownika wyswietlajac
   podany komunikat. Poprawna sciezka to taka, ktora wskazuje na istiejacy plik.
 Argumenty:
   komunikatDlaUzytkownika:string - komunikat jaki ma zostac wyswietlony
                                  uzytkownikowi przed pobraniem danych.
 Zwraca:
   Poprawna sciezka do pliku podana przez uzytkownika.
}
  function pobierzSciezkeDoPlikuOdUzytkownika(
    komunikatDlaUzytkownika: string): string;
  var
    pobranaSciezka: string;
    plikIstnieje: boolean;
  begin
    repeat
      pobranaSciezka := pobierzDaneOdUzytkownika(komunikatDlaUzytkownika);
      plikIstnieje := FileExists(pobranaSciezka);
      if plikIstnieje = False then
        writeln('Podana sciezka jest nieprawidlowa!');
    until plikIstnieje;
    pobierzSciezkeDoPlikuOdUzytkownika := pobranaSciezka;
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

  function zapiszWierszeDoPliku(sciezkaDoPliku: string;
    wierszeDoZapisu: WierszePliku): boolean;
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
      WriteLn(plik, wierszeDoZapisu[i]);
      Inc(i);
    until i >= iloscWierszyDoZapisu;
    Close(plik);
  end;

  function pobierzDlugoscNajkrotszegoCiagu(ciagA: string; ciagB: string): integer;
  begin
    if (Length(ciagA) < Length(ciagB)) then
      pobierzDlugoscNajkrotszegoCiagu := Length(ciagA)
    else
      pobierzDlugoscNajkrotszegoCiagu := Length(ciagB);
  end;

  function sortujWiersze(wiersze: WierszePliku): WierszePliku;
  var
    i, j, dlugoscNajkrotszegoWiersza: integer;
    pom: string;
    wystapilaZamiana: boolean;
  begin
    dlugoscNajkrotszegoWiersza := 0;
    repeat
      wystapilaZamiana := False;
      for i := 1 to High(wiersze) - 1 do
      begin
        dlugoscNajkrotszegoWiersza :=
          pobierzDlugoscNajkrotszegoCiagu(wiersze[i], wiersze[i + 1]);
        for j := 1 to dlugoscNajkrotszegoWiersza do
        begin
          if wiersze[i][j] > wiersze[i + 1][j] then
          begin
            pom := wiersze[i];
            wiersze[i] := wiersze[i + 1];
            wiersze[i + 1] := pom;
            wystapilaZamiana := True;
          end;
          if wiersze[i][j] <> wiersze[i + 1][j] then
            Break;
        end;
      end;
    until wystapilaZamiana = False;

    sortujWiersze := wiersze;
  end;

var
  plikZNieposortowanymiWierszami: Text;
  sciezkaDoPlikuZNieposortowanymiWierszami: string;
  nieposortowaneWiersze: WierszePliku;
  posortowaneWiersze: WierszePliku;

begin
  sciezkaDoPlikuZNieposortowanymiWierszami :=
    pobierzSciezkeDoPlikuOdUzytkownika(
    'Prosze podac poprawna sciezke do pliku z nieposortowanymi danymi');

  nieposortowaneWiersze := pobierzWierszeZPliku(
    sciezkaDoPlikuZNieposortowanymiWierszami);

  posortowaneWiersze := sortujWiersze(nieposortowaneWiersze);

  zapiszWierszeDoPliku('output.txt', posortowaneWiersze);

  writeln('Zakonczono poprawnie.');
  readln();
end.
