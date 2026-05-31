uni(_) :-
giliran(Pemain),
pending_wild_draw_four(_, Pemain, _, _),
write('Ada kartu wild_draw_four dimainkan! Anda hanya bisa melakukan aksi ambilKartu atau tantang. '), nl, !.

uni(Index) :-
giliran(Pemain),
tangan(Pemain, ListKartu),
panjang(ListKartu, Jumlah),
(Index < 1 ; Index > Jumlah),
write('Indeks kartu tidak valid!'), nl, !.

uni(_) :-
giliran(Pemain),
tangan(Pemain, ListKartu),
panjang(ListKartu, Jumlah), 
Jumlah \= 2,
ambil_kartu(Pemain, 1),
write('UNI tidak valid karena memainkan kartu tidak menyisakan 1 kartu!'), nl, 
gantiGiliran, !.

uni(Index) :-
giliran(Pemain),
tangan(Pemain, ListKartu),
panjang(ListKartu, Jumlah),
Jumlah == 2,
getElement(Index, ListKartu, kartu(Warna, Jenis)),
\+ validasiKartu(Warna, Jenis), !,
write('Kartu '), write(Warna), write('-'), write(Jenis), 
write(' tidak cocok dengan kartu di atas discard pile!'), nl.

uni(Index) :-
giliran(Pemain),
tangan(Pemain, ListKartu),
panjang(ListKartu, Jumlah),
Jumlah == 2, !,
getElement(Index, ListKartu, kartu(Warna, Jenis)),
validasiKartu(Warna, Jenis), !,
write(Pemain), write(' memainkan kartu: '), write(Warna), write('-'), write(Jenis), write('.'), nl,
write(Pemain), write(' menyerukan UNI!'), nl, nl,
/* Penggunaan alur mainkanKartu agar mencetak message yang benar */
retract(discardPile(_)),
asserta(discardPile([kartu(Warna, Jenis)])),
hapusElemenList(Index, ListKartu, ListKartuBaru),
retract(tangan(Pemain, ListKartu)),
asserta(tangan(Pemain, ListKartuBaru)),
(retract(sembunyi(Pemain, kartu(Warna, Jenis))) -> true; true),
/* Mengamankan status UNI */
assertz(status_UNI(Pemain)),
/* Memeriksa endGame */
cekEndGame(Pemain),
/* Lanjutan alur permainan */
efekKartu(Jenis),
gantiGiliran, !.

/* Kasus pemain dikenakan wild_draw_four */
tangkap(_) :-
    giliran(Pemain),
    pending_wild_draw_four(_, Pemain, _, _),
    write('Ada kartu wild_draw_four dimainkan! Anda hanya bisa melakukan aksi ambilKartu atau tantang. '), nl, !.

tangkap(Target) :-
    urutan(ListPemain),
    \+termasuk_member(Target, ListPemain), !,
    write('Error! '), write(Target), write(' bukan termasuk pemain saat ini.'), nl.
    
tangkap(Target) :-
    giliran(Pemain),
    Target == Pemain, !,
    write('Error! tidak bisa menargetkan diri sendiri'), nl.

tangkap(Target):-
    giliran(Pemain),
    status_UNI(Target),
    tangan(Target, KartuTarget),
    panjang(KartuTarget, Jumlah),
    Jumlah == 1,
    write('Gagal menangkap! '), write(Target), write(' sudah dalam status UNI!'), nl,
    write(Pemain), write(' Mendapatkan satu kartu hukuman.'), nl,
    ambil_kartu(Pemain, 1), !.

tangkap(Target):-
    giliran(Pemain),
    \+status_UNI(Target),
    tangan(Target, KartuTarget),
    panjang(KartuTarget, Jumlah),
    Jumlah \= 1,
    write('Gagal menangkap! '), write(Target), write(' memiliki sisa kartu lebih dari 1!'), nl,
    write(Pemain), write(' Mendapatkan satu kartu hukuman.'), nl,
    ambil_kartu(Pemain, 1), !.

tangkap(Target):-
    \+status_UNI(Target),
    tangan(Target, KartuTarget),
    panjang(KartuTarget, Jumlah),
    Jumlah == 1,
    write('Berhasil menangkap! '), write(Target), write(' tidak berstatus UNI!'), nl,
    write(Target), write(' Mendapatkan dua kartu hukuman.'), nl,
    ambil_kartu(Target, 2),
    gantiGiliran, !.