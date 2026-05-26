/* Kasus sisa 1 kartu */
sembunyikanKartu(_) :-
giliran(Pemain),
tangan(Pemain, [_]), !, 
write('Gagal! Kartu Anda tinggal 1.'), nl.

/* Kasus berhasil */
sembunyikanKartu(Index) :-
giliran(Pemain),
tangan(Pemain, ListKartu),
panjang(ListKartu, Jumlah),
Jumlah > 1, 
Index > 0, 
Index =< Jumlah,
getElement(Index, ListKartu, kartu(Warna, Jenis)),
\+sembunyi(Pemain, kartu(Warna, Jenis)),
assertz(sembunyi(Pemain, kartu(Warna, Jenis))),
write('Kartu '), write(Warna), write('-'), write(Jenis), write(' berhasil disembunyikan.'), nl, 
gantiGiliran, 
giliran(NextPemain),
write('Giliran '), write(NextPemain), write('.'), nl, !.

/* Kasus kartu sudah pernah disembunyikan */
sembunyikanKartu(Index) :-
giliran(Pemain),
tangan(Pemain, ListKartu),
panjang(ListKartu, Jumlah),
Index > 0, 
Index =< Jumlah,
getElement(Index, ListKartu, kartu(Warna, Jenis)),
sembunyi(Pemain, kartu(Warna, Jenis)),
write('Gagal! Kartu tersebut sudah disembunyikan.'), nl.

/* Kasus index tidak valid */
sembunyikanKartu(_) :-
giliran(Pemain),
tangan(Pemain, ListKartu),
panjang(ListKartu, Jumlah),
write('Indeks tidak valid! Kamu hanya memiliki '), write(Jumlah), write(' kartu.'), nl.



