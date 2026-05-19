:- include('utilitasList.pl').
:- include('aksi.pl').
:- include('fakta.pl').

:- dynamic(giliran/1).
:- dynamic(giliran1/1). 
:- dynamic(urutan/1).
:- dynamic(pemain/1). 
:- dynamic(tangan/2).
:- dynamic(discardPile/1).

startGame :-
    retractall(giliran(_)),
    retractall(giliran1(_)), 
    retractall(urutan(_)),
    retractall(pemain(_)),
    retractall(tangan(_,_)),
    retractall(discardPile(_)),
    write('Masukkan jumlah pemain: '),
    read(Jumlah),
    cek(Jumlah),
    acakUrutan,
    discardTop(_),
    giliran(GiliranPertama), nl,
    write('Giliran '), write(GiliranPertama), write('.').

cek(Jumlah):-
    Jumlah >= 2, Jumlah =< 4, !,
    inputPemain(1, Jumlah),
    nl.

cek(_):-
    write('Mohon masukkan angka antara 2-4'), nl,
    startGame.

inputPemain(Index, Max) :-
    Index > Max, !.

inputPemain(Index, Max) :-
    Index =< Max,
    write('Masukkan nama pemain '), write(Index), write(': '),
    read(Nama), validasiNama(Nama, Valid),
    assertz(pemain(Valid)), 
    NextIndex is Index + 1,
    inputPemain(NextIndex, Max).

validasiNama(Nama, Valid) :-
    pemain(Nama), !, 
    write('Nama sudah digunakan. Masukkan nama lain: '),
    read(Nama1), validasiNama(Nama1, Valid).
validasiNama(Nama, Nama).

acakUrutan :-
    semuaPemain(ListPemain),
    acakList(ListPemain, ListUrutan),
    assertz(urutan(ListUrutan)), 
    urutanPemain(ListUrutan),
    pembagianKartu(ListUrutan),
    ListUrutan = [Pertama|_],
    assertz(giliran(Pertama)).

semuaPemain(_) :-
    pemain(Nama),
    assertz(giliran1(Nama)),
    fail.

semuaPemain(ListAkhir) :-
    hasil(ListAkhir).

hasil([Nama | Sisa]) :-
    retract(giliran1(Nama)), !,
    hasil(Sisa).
hasil([]).

acakList([], []) :- !.
acakList(ListAwal, [Pilihan | Sisa]) :-
    panjang(ListAwal, PanjangList),
    random(0, PanjangList, Acak),
    hapusElemen(Acak, ListAwal, Pilihan, SisaElemen),
    acakList(SisaElemen,Sisa).

hapusElemen(0, [H|T], H, T) :- !.
hapusElemen(Index, [H|T], Elmt, [H|Sisa]) :-
    Index > 0,
    NewIndex is Index - 1,
    hapusElemen(NewIndex, T, Elmt, Sisa).

urutanPemain([Pertama | Sisa]) :-
    write('Urutan pemain: '), write(Pertama),
    sisaPemain(Sisa), write('.'),nl.
sisaPemain([Kedua|Sisa]) :-
    write(' - '), write(Kedua),
    sisaPemain(Sisa).
sisaPemain([]).

pembagianKartu([]) :-
    nl, write('Setiap pemain mendapatkan 7 kartu acak.'), nl, nl.
pembagianKartu([Nama | Sisa]) :-
    bagiKartu(Nama, 7, []),
    pembagianKartu(Sisa).

bagiKartu(Nama, 0, Tangan) :-
    assertz(tangan(Nama, Tangan)), !.
bagiKartu(Nama, N, TanganLama) :-
    N > 0,
    cariKartu(ListKartu),
    panjang(ListKartu, P),
    MaxIdx is P + 1,
    random(1, MaxIdx, Index),
    getElement(ListKartu, Index, KartuAcak),
    appendUjung(TanganLama, KartuAcak, TanganBaru),
    N1 is N - 1,
    bagiKartu(Nama, N1, TanganBaru).

discardTop(KartuAwal) :-
    cariKartu(ListKartu),
    panjang(ListKartu, PanjangList),
    MaxIdx is PanjangList + 1,
    random(1, MaxIdx, Index),
    getElement(ListKartu, Index, KartuAwal), 
    KartuAwal = kartu(W,J),
    W \= hitam,
    J \= skip, J \= draw_two, J \= revers, J \= mimic,
    assertz(discardPile(KartuAwal)),
    write('Kartu discard top: '), write(W), write(' - '), write(J), write('.'), nl, !.
discardTop(KartuAwal) :-
    discardTop(KartuAwal).
