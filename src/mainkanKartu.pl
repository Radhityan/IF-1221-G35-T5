:- consult('utilitasList.pl').
:- dynamic tanganPemain/2.
:- dynamic giliran/1.
mainkanKartu(X):-
    giliran(Pemain),
    tanganPemain(Pemain, ListKartu),
    ambilElemenList(N, ListKartu, kartu(Warna, Jenis)),
    write(Pemain), write(' memainkan kartu: '), write(Warna), write('-'), write(Jenis), write('.'),
    hapusElemenList(N, ListKartu, ListKartuBaru),
    retract(tanganPemain(Pemain, ListKartu))
    asserta(tanganPemain(Pemain, ListKartu))