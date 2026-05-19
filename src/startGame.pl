consult('utilitasList.pl').
consult('fakta.pl').
:- dynamic(giliran/1).
:- dynamic(urutan/1). % buat sementara
:- dynamic(pemain/1). 
:- dynamic(tangan/2).
:- dynamic(discardPile/1).

panjang([], 0).
panjang([H|T], Hasil) :-
    panjang(T, HasilLama),
    Hasil is HasilLama + 1.

cariKartu(Hasil) :-
    retractall(list_kartu(_)),
    assertz(list_kartu([])),
    kartu(Warna, Jenis),
    update_list(kartu(Warna, Jenis)),
    fail.

cariKartu(Hasil) :- list_kartu(Hasil), !.

update_list(Kartu) :-
    retract(list_kartu(List)),
    ListBaru = [Kartu|List],
    assertz(list_kartu(ListBaru)).

startGame :-
    retractall(giliran(_)),
    retractall(giliran1(_)), 
    retractall(urutan(_)),
    retractall(tangan(_)),
    retractall(discardPile(_)),
    write('Masukkan jumlah pemain: '),
    read(Jumlah),
    cek(Jumlah),
    acakUrutan,
    discardTop(KartuAwal).

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
    read(Nama), validasi(Nama, Valid),
    assertz(pemain(Valid)), 
    Index2 is Index + 1,
    inputPemain(Index2, Max).

validasi(Nama, Valid) :-
    urutan(Nama), !, 
    write('Nama sudah digunakan. Masukkan nama lain: '),
    read(Nama1), validasi(Nama1, Valid).

validasi(Nama, Nama).

acakUrutan :-
    semuaPemain(ListPemain),
    acakList(ListPemain, ListUrutan),
    assertz(urutan(ListUrutan)), 
    urutanPemain(ListUrutan),
    pembagianKartu(ListUrutan).

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
    hapusElemenList(Acak, ListAwal, SisaElmt),
    acakList(SisaElmt,Sisa).

hapusElemenList(1, [_|T], T).
hapusElemenList(N, [H|T], [H|HasilTail]) :-
    N > 1,
    N1 is N - 1,
    write(HasilTail),
    hapusElemenList(N1, T, HasilTail).

urutanPemain([Pertama | Sisa]) :-
    write('Urutan pemain: '), write(Pertama),
    sisaPemain(Sisa), nl.
sisaPemain([Kedua|Sisa]) :-
    write(' - '), write(Kedua),
    sisaPemain(Sisa).

pembagianKartu(ListUrutan) :-
    write('Setiap pemain mendapatkan 7 kartu acak.'), nl,
    random(1, 54, deckKartu),
    pembagianKartu(ListUrutan).

discardTop(KartuAwal) :-
    panjang(deckKartu, PanjangList),
    random(0,PanjangList, KartuAwal),
    write('Kartu discard top: '), write(KartuAwal).