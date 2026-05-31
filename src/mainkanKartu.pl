gantiGiliran :-
    urutan([Next|Sisa]),
    appendUjung(Sisa, Next, UrutanBaru),
    retract(urutan(_)),
    asserta(urutan(UrutanBaru)),
    UrutanBaru = [NextPemain|_],
    retract(giliran(_)),
    asserta(giliran(NextPemain)),
    write('Giliran '), write(NextPemain), write('.'), nl, !.

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
    getElement(X, ListKartu, kartu(Warna, Jenis)),
    \+ validasiKartu(Warna, Jenis),
    write('Kartu '), write(Warna), write('-'), write(Jenis), 
    write(' tidak cocok dengan kartu di atas discard pile!'), nl, !.

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
    efekKartu(Jenis),
    (retract(sembunyi(Pemain, kartu(Warna, Jenis))) -> true; true),
    (termasuk_member(Jenis, [skip, draw_two, revers, wild_draw_four, mimic]) 
     -> asserta(riwayat_aksi(Warna, Jenis)) ; true),
    cekEndGame(Pemain),
    gantiGiliran, !.


validasiKartu(_, wild_draw_four) :-
    discardPile([kartu(_, wild_draw_four) | _]), !,
    write('Aturan: Tidak boleh menumpuk kartu wild_draw_four berturut-turut!'), nl, fail.

validasiKartu(_, draw_two) :-
    discardPile([kartu(_, draw_two) | _]), !,
    write('Aturan: Tidak boleh menumpuk kartu draw_two berturut-turut!'), nl, fail.

validasiKartu(hitam,mimic):- !.

validasiKartu(Warna, _):-
    discardPile([kartu(Warna, _)|_]).

validasiKartu(_, Jenis):-
    discardPile([kartu(_, Jenis )|_]).

validasiKartu(hitam, _).

efekKartu(Jenis) :-
    \+ termasuk_member(Jenis, [skip, draw_two, revers, wild, wild_draw_four, mimic]), !.

efekKartu(skip):-
    gantiGiliran,
    giliran(PemainSkip),
    write('Giliran '), write(PemainSkip), write(' dilompati'), nl.

efekKartu(draw_two):-
    gantiGiliran,
    giliran(Next),
    ambil_kartu(Next, 2),
    write(Next), write(' Mengambil dua kartu dan gilirannya dilompati'), nl.
    

efekKartu(revers):-
    arahPermainan(kanan),
    retractall(arahPermainan(_)),
    asserta(arahPermainan(kiri)),
    giliran(Pemain),
    urutan([_|UrutanLama]),
    urutan(SemuaPemain),
    panjang(SemuaPemain, JumlahPemain),
    JumlahPemain \= 2,
    reverseList(UrutanLama, Temp),
    appendDepan(Temp ,Pemain ,UrutanBaru),
    retract(urutan(_)),
    asserta(urutan(UrutanBaru)),
    write('Urutan giliran dibalik!'), nl.

efekKartu(revers):-
    arahPermainan(kiri),
    retractall(arahPermainan(_)),
    asserta(arahPermainan(kanan)),
    urutan(UrutanLama),
    panjang(UrutanLama, JumlahPemain),
    JumlahPemain == 2,
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
    discardPile([kartu(WarnaLama, AngkaLama)|_]),
    write('Silahkan pilih warna: '), read(WarnaBaru),
    termasuk_member(WarnaBaru, [merah, kuning, hijau, biru]), !,
    retractall(pending_wild_draw_four(_, _, _, _)),
    assertz(pending_wild_draw_four(Pemain, Next, WarnaLama, AngkaLama)),
    retract(discardPile(_)),
    assertz(discardPile([kartu(WarnaBaru, wild_draw_four)])).

efekKartu(mimic) :-
    write('Menelusuri riwayat permainan...'), nl,
    (riwayat_aksi(WarnaAsal, JenisAksi) ->  write('Kartu aksi terakhir yang dimainkan: '), write(WarnaAsal), write('-'), write(JenisAksi), nl,
    write('Kartu Mimic menyalin efek '), write(JenisAksi), nl,

    /* efek yang sama seperti kartu hitam lainnya */
    write('Pilih warna (merah, biru, hijau, kuning): '), read(WarnaBaru),
    termasuk_member(WarnaBaru, [merah, biru, hijau, kuning]), !,

    retract(discardPile(_)),
    asserta(discardPile([kartu(WarnaBaru, mimic)])),

    efekKartu(JenisAksi) ; 
    write('Tidak ada kartu aksi di riwayat! Mimic menjadi wild biasa.'), nl,
    efekKartu(wild)).

tantang :-
    pending_wild_draw_four(Pemain, Next, WarnaLama, AngkaLama),
    giliran(PemainSekarang),
    PemainSekarang == Next, !,
    write('Tantangan dilakukan!'), nl,
    write('Memeriksa kartu, '), write(Pemain), write('...'), nl,
    tangan(Pemain, ListKartu),
    ((cekWarnaDiTangan(WarnaLama, ListKartu) ; cekAngkaDiTangan(AngkaLama, ListKartu)) ->
    write('Tantangan berhasil! '), write(Pemain), write(' terbukti memiliki kartu yang cocok.'), nl,
    write(Pemain), write(' dihukum mengambil 4 kartu acak!'), nl,
    ambil_kartu(Pemain, 4), 
    retractall(pending_wild_draw_four(_, _, _, _))
    ;write('Tantangan gagal! '), write(Pemain), write(' tidak berbohong.'), nl,
    write(Next), write(' dihukum mengambil 6 kartu acak dan gilirannya dilompati!'), nl,
    ambil_kartu(Next, 6),
    retractall(pending_wild_draw_four(_, _, _, _)),
    gantiGiliran),!.

tantang :-
    \+ pending_wild_draw_four(_, _, _, _),
    write('Tidak ada kartu wild_draw_four yang bisa ditantang saat ini!'), nl.

cekEndGame(Pemain) :-
    tangan(Pemain, []), !,
    endGame,
    halt.

cekEndGame(_).
    
cekWarnaDiTangan(WarnaTarget, [kartu(WarnaTarget, _) | _]) :- !.
cekWarnaDiTangan(WarnaTarget, [_ | Sisa]) :-
    cekWarnaDiTangan(WarnaTarget, Sisa).
cekAngkaDiTangan(AngkaTarget, [kartu(_, AngkaTarget)|_]) :- !.
cekAngkaDiTangan(AngkaTarget, [_|Sisa]) :- cekAngkaDiTangan(AngkaTarget, Sisa).
