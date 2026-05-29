gantiGiliran :-
    urutan([Next|Sisa]),
    appendUjung(Sisa, Next, UrutanBaru),
    retract(urutan(_)),
    asserta(urutan(UrutanBaru)),
    UrutanBaru = [NextPemain|_],
    retract(giliran(_)),
    asserta(giliran(NextPemain)).

mainkanKartu(_) :-
    giliran(Pemain),
    pending_wild_draw_four(_, Pemain, _, _),
    write('Ada kartu wild_draw_four dimainkan! Anda hanya bisa melakukan aksi ambilKartu atau tantang. '), nl, !.

mainkanKartu(X) :-
    giliran(Pemain),
    tangan(Pemain, ListKartu),
    panjang(ListKartu, Jumlah),
    (X < 1 ; X > Jumlah),
    write('Indeks kartu tidak valid!'), nl, !.

mainkanKartu(X):-
    giliran(Pemain),
    tangan(Pemain, ListKartu),
    getElement(X , ListKartu, kartu(Warna, Jenis)),
    validasiKartu(Warna, Jenis),
    write(Pemain), write(' memainkan kartu: '), write(Warna), write('-'), write(Jenis), write('.'), nl,
    retract(discardPile(_)),
    asserta(discardPile([kartu(Warna, Jenis)])),
    hapusElemenList(X, ListKartu, ListKartuBaru),
    retract(tangan(Pemain, ListKartu)),
    asserta(tangan(Pemain, ListKartuBaru)),
    (retract(sembunyi(Pemain, kartu(Warna, Jenis))) -> true; true),
    cekEndGame(Pemain),
    efekKartu(Jenis),
    gantiGiliran,
    giliran(NextPemain),
    write('Giliran '), write(NextPemain), write('.'), nl, !.

mainkanKartu(X):-
    giliran(Pemain),
    tangan(Pemain, ListKartu),
    getElement(X, ListKartu, kartu(Warna, Jenis)),
    \+ validasiKartu(Warna, Jenis),
    write('Kartu '), write(Warna), write('-'), write(Jenis), 
    write(' tidak cocok dengan kartu di atas discard pile!'), nl.

validasiKartu(_, wild_draw_four) :-
    discardPile([kartu(_, wild_draw_four) | _]), !,
    write('Aturan: Tidak boleh menumpuk kartu wild_draw_four berturut-turut!'), nl, fail.

validasiKartu(_, draw_two) :-
    discardPile([kartu(_, draw_two) | _]), !,
    write('Aturan: Tidak boleh menumpuk kartu draw_two berturut-turut!'), nl, fail.

validasiKartu(Warna, _):-
    discardPile([kartu(Warna, _)|_]).

validasiKartu(_, Jenis):-
    discardPile([kartu(_, Jenis )|_]).

validasiKartu(hitam, _).

efekKartu(Jenis) :-
    \+ termasuk_member(Jenis, [skip, draw_two, revers, wild, wild_draw_four]), !.

efekKartu(skip):-
    gantiGiliran,
    giliran(PemainSkip),
    write('Giliran '), write(PemainSkip), write(' dilompati'), nl.

efekKartu(draw_two):-
    urutan([_, Next|_]),
    ambil_kartu(Next, 2),
    write(Next), write(' Mengambil dua kartu'), nl,
    gantiGiliran.

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
    asserta(discardPile([kartu(Warna, wild)])).

efekKartu(wild_draw_four):-
    giliran(Pemain),
    urutan([_, Next|_]),
    discardPile([_, kartu(WarnaLama, AngkaLama)|_]),
    write('Silahkan pilih warna: '), read(WarnaBaru),
    termasuk_member(WarnaBaru, [merah, kuning, hijau, biru]), !,
    retractall(pending_wild_draw_four(_, _, _, _)),
    assertz(pending_wild_draw_four(Pemain, Next, WarnaLama, AngkaLama)),
    retract(discardPile(_)),
    assertz(discardPile([kartu(WarnaBaru, wild_draw_four)])).


    /* efekKartu(wild),
    urutan([_, Next|_]),
    write(Next), write('terkena draw four, ingin tantang?(iya/tidak)'), nl,
    read(Answer),
    termasuk_member(Answer, [iya, tidak]), !,
    Answer = tidak,
    ambil_kartu(Next, 4),
    efekKartu(skip). */

/*efekKartu(wild_draw_four):-
    efekKartu(wild),
    urutan([Next|_]),
    write(Next), write('terkena draw four, ingin tantang?(iya/tidak)'), nl,
    read(Answer),
    termasuk_member(Answer, [iya, tidak]), !,
    Answer = iya,
    giliran(Pemain),
    tantang(Pemain).*/

tantang :-
    pending_wild_draw_four(Pemain, Next, WarnaLama, AngkaLama),
    giliran(PemainSekarang),
    PemainSekarang == Next, !,
    write('Tantangan dilakukan!'), nl,
    write('Memeriksa kartu, '), write(Pemain), write('...'), nl,
    tangan(Pemain, ListKartu),
    ( (cekWarnaDiTangan(WarnaLama, ListKartu) ; cekAngkaDiTangan(AngkaLama, ListKartu)) ->
    write('Tantangan berhasil! '), write(Pemain), write(' terbukti memiliki kartu yang cocok.'), nl,
    write(Pemain), write(' dihukum mengambil 4 kartu acak!'), nl,
    ambil_kartu(Pemain, 4), 
    retractall(pending_wild_draw_four(_, _, _, _))
    ;write('Tantangan gagal! '), write(Pemain), write(' tidak berbohong.'), nl,
    write(Next), write(' dihukum mengambil 6 kartu acak dan gilirannya dilompati!'), nl,
    ambil_kartu(Next, 6),
    retractall(pending_wild_draw_four(_, _, _, _)),
    gantiGiliran),
    giliran(NextPemain),
    write('Giliran '), write(NextPemain), write('.'), nl.

tantang :-
    \+ pending_wild_draw_four(_, _, _, _),
    write('Tidak ada kartu wild_draw_four yang bisa ditantang saat ini!'), nl.

cekEndGame(Pemain) :-
    tangan(Pemain, []), !,
    endGame,
    halt.

cekEndGame(_).

/*tantang(Pemain) :-
    tangan(Pemain, ListKartu),
    discardPile(kartu(Warna,_)),
    cekWarnaDiTangan(Warna, ListKartu), !,
    write('Tantangan Berhasil! '), write(Pemain), 
    write(' terbukti memiliki kartu berwarna '), write(Warna), write('.'), nl,
    write(Pemain), write(' harus mengambil 4 kartu sebagai hukuman!'), nl,
    bagiKartu(Pemain, 4, ListKartu).
    
tantang(Pemain) :-
    urutan([Next|_Sisa]),
    tangan(Next, Tangan),
    write('Tantangan Gagal! '), write(Pemain), 
    write(' tidak berbohong.'), nl,
    bagiKartu(Next, 6, Tangan),
    write(Next), write(' dihukum mengambil 6 kartu dan gilirannya dilompati!'), nl,
    efekKartu(skip). */
    
cekWarnaDiTangan(WarnaTarget, [kartu(WarnaTarget, _) | _]) :- !.
cekWarnaDiTangan(WarnaTarget, [_ | Sisa]) :-
    cekWarnaDiTangan(WarnaTarget, Sisa).
cekAngkaDiTangan(AngkaTarget, [kartu(_, AngkaTarget)|_]) :- !.
cekAngkaDiTangan(AngkaTarget, [_|Sisa]) :- cekAngkaDiTangan(AngkaTarget, Sisa).
