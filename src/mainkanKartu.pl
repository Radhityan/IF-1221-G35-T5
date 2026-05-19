:- consult('utilitasList.pl').
:- consult('startGame.pl')
:- consult('fakta.pl')

mainkanKartu(X):-
    giliran(Pemain),
    tangan(Pemain, ListKartu),
    getElement(X, ListKartu, kartu(Warna, Jenis)),
    validasi(Warna, Jenis),
    write(Pemain), write(' memainkan kartu: '), write(Warna), write('-'), write(Jenis), write('.'),
    retract(discardPile(_)),
    asserta(discardPile(kartu(Warna, Jenis)))
    hapusElemenList(X, ListKartu, ListKartuBaru),
    retract(tangan(Pemain, ListKartu)),
    asserta(tangan(Pemain, ListKartuBaru)),
    efekKartu(Jenis),
    urutan([Next|Sisa]),
    asserta(giliran(Next)),
    appendUjung(Sisa, [Pemain], UrutanBaru),
    retract(urutan(_)),
    asserta(urutan(UrutanBaru)).

mainkanKartu(X):-
    urutan(Pemain),
    tangan(Pemain, ListKartu),
    ambilElemenList(X, ListKartu, kartu(Warna, Jenis)),
    \+ validasi(Warna, Jenis),
    write('Eror: Kartu '), write(Warna), write('-'), write(Jenis), 
    write(' tidak cocok dengan kartu di atas discard pile!'), nl.

validasi(Warna, _):-
    discardPile(kartu(Warna, _)).

validasi(_,Jenis):-
    discardPile(kartu(_, Jenis )).

validasi(hitam, _).

efekKartu(skip):-
    urutan([Next|Sisa]),
    asserta(giliran(Next)),
    appendUjung(Sisa, [Pemain], UrutanBaru),
    retract(urutan(_)),
    asserta(urutan(UrutanBaru)),
    write('Giliran '), write(Next), write(' dilompati').

efekKartu(draw_two):-
    urutan([Next|_]),
    giliran(Next),
    tangan(Next,TanganLama),
    ambilKartuN(Next, 2),
    write(Next), write(' Mengambil dua kartu'),
    efekKartu(skip).

efekKartu(revers):-
    urutan(UrutanLama),
    reverseList(UrutanLama, UrutanBaru),
    retract(urutan(_)),
    asserta(urutan(UrutanBaru)),
    write('Urutan giliran dibalik!').

efekKartu(wild):-
    write('Pilih warna:'),
    read(Warna),
    
    