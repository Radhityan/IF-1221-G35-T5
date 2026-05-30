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
gantiGiliran,
giliran(NextPemain),
write('Giliran '), write(NextPemain), write('.'), nl, !.

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
retractall(status_UNI(_)),
assertz(status_UNI(Pemain)),
/* Memeriksa endGame */
cekEndGame(Pemain),
/* Lanjutan alur permainan */
efekKartu(Jenis),
gantiGiliran,
giliran(NextPemain),
write('Giliran '), write(NextPemain), write('.'), nl, !.