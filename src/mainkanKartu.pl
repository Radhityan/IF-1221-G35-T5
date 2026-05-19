:- initialization(consult('utilitasList.pl')).
:- initialization(consult('startGame.pl')).
:- initialization(consult('fakta.pl')).

mainkanKartu(X):-
    giliran(Pemain),
    tangan(Pemain, ListKartu),
    getElement(ListKartu, X , kartu(Warna, Jenis)),
    validasi(Warna, Jenis),
    write(Pemain), write(' memainkan kartu: '), write(Warna), write('-'), write(Jenis), write('.'),
    efekKartu(Jenis),
    retract(discardPile(_)),
    asserta(discardPile(kartu(Warna, Jenis))),
    hapusElemenList(X, ListKartu, ListKartuBaru),
    retract(tangan(Pemain, ListKartu)),
    asserta(tangan(Pemain, ListKartuBaru)),
    urutan([Next|Sisa]),
    retract(giliran(_)),
    asserta(giliran(Next)),
    appendUjung(Sisa, [Pemain], UrutanBaru),
    retract(urutan(_)),
    asserta(urutan(UrutanBaru)),
    write('Giliran'), write(Next), nl.

mainkanKartu(X):-
    giliran(Pemain),
    tangan(Pemain, ListKartu),
    getElement(ListKartu, X, kartu(Warna, Jenis)),
    \+ validasi(Warna, Jenis),
    write('Eror: Kartu '), write(Warna), write('-'), write(Jenis), 
    write(' tidak cocok dengan kartu di atas discard pile!'), nl.

validasiKartu(Warna, _):-
    discardPile(kartu(Warna, _)).

validasiKartu(_,Jenis):-
    discardPile(kartu(_, Jenis )).

validasiKartu(hitam, _).

efekKartu(skip):-
    urutan([Next|Sisa]),
    giliran(Pemain),
    retract(giliran(_)),
    asserta(giliran(Next)),
    appendUjung(Sisa, [Pemain], UrutanBaru),
    retract(urutan(_)),
    asserta(urutan(UrutanBaru)),
    write('Giliran '), write(Next), write(' dilompati'), nl.

efekKartu(draw_two):-
    urutan([Next|_]),
    tangan(Next, Tangan),
    bagiKartu(Next, 2, Tangan),
    write(Next), write(' Mengambil dua kartu'), nl,
    efekKartu(skip).

efekKartu(revers):-
    urutan(UrutanLama),
    reverseList(UrutanLama, UrutanBaru),
    retract(urutan(_)),
    asserta(urutan(UrutanBaru)),
    write('Urutan giliran dibalik!'), nl.

efekKartu(wild):-
    write('Pilih warna:(merah, biru, hijau, kuning)'), nl,
    read(Warna),
    termasuk_member(Warna, [merah, biru, hijau, kuning]), !,
    retract(discardPile(_)),
    asserta(discardPile(kartu(Warna,wild))).

efekKartu(wild_draw_four):-
    efekKartu(wild),
    urutan([Next|_]),
    tangan(Next, Tangan),
    write(Next), write('terkena draw four, ingin tantang?(iya/tidak)'), nl,
    read(Answer),
    termasuk_member(Answer, [iya, tidak]), !,
    Answer = tidak,
    bagiKartu(Next, 4, Tangan),
    efekKartu(skip).

efekKartu(wild_draw_four):-
    efekKartu(wild),
    urutan([Next|_]),
    write(Next), write('terkena draw four, ingin tantang?(iya/tidak)'), nl,
    read(Answer),
    termasuk_member(Answer, [iya, tidak]), !,
    Answer = iya,
    giliran(Pemain),
    tantang(Pemain).

tantang(Pemain) :-
    tangan(Pemain, ListKartu),
    discardPile(kartu(Warna,_)),
    cekWarnaDiTangan(Warna, ListKartu), !,
    write('Tantangan Berhasil! '), write(Pemain), 
    write(' terbukti memiliki kartu berwarna '), write(Warna), write('.'), nl,
    write(Pemain), write(' harus mengambil 4 kartu sebagai hukuman!'), nl,
    bagiKartu(Pemain, 4, ListKartu).
    
tantang(Pemain) :-
    urutan([Next|Sisa]),
    tangan(Next, Tangan),
    write('Tantangan Gagal! '), write(Pemain), 
    write(' tidak berbohong.'), nl,
    bagiKartu(Next, 6, Tangan),
    write(Next), write(' dihukum mengambil 6 kartu dan gilirannya dilompati!'), nl,
    efekKartu(skip).
    
cekWarnaDiTangan(WarnaTarget, [kartu(WarnaTarget, _) | _]) :- !.
cekWarnaDiTangan(WarnaTarget, [_ | Sisa]) :-
    cekWarnaDiTangan(WarnaTarget, Sisa).
