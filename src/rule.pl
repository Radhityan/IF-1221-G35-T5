
/* RULES */
startGame :-
    write('Masukkan jumlah pemain: '),
    read(Jumlah),
    cek(Jumlah).
cek(Jumlah):-
    Jumlah >= 2, Jumlah =< 4, !,
    inputPemain(1, Jumlah, [], ListPemain),
    nl.
cek(_):-
    write('Mohon masukkan angka antara 2-4'), nl,
    startGame.

inputPemain(Index, Max, List, Atribut) :-
    Index > Max, !,
    reverse(List, Atribut).

inputPemain(Index, Max, List, Atribut) :-
    Index =< Max,
    write('Masukkan nama pemain '), write(Index), write(': '),
    read(Nama), validasi(Nama, List, Valid),
    Index2 is Index + 1,
    inputPemain(Index2, Max, [Valid | List], Atribut).

validasi(Nama, List, Valid) :-
    cekNama(Nama, List), !,
    write('Nama sudah digunaka. Masukkan nama lain: '),
    read(Nama1),
    validasi(Nama1, List, Valid).





