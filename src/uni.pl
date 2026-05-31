uni(_) :-
giliran(Pemain),
tangan(Pemain, ListKartu),
panjang(ListKartu, Jumlah), 
Jumlah \= 2,
ambilKartu(Pemain, 1),
write('UNI tidak valid karena memainkan kartu tidak menyisakan 1 kartu!'), nl, 
gantiGiliran,
giliran(NextPemain),
write('Giliran '), write(NextPemain), write('.'), nl, !.

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