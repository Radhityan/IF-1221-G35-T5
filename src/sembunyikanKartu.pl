:- initialization(consult('utilitasList.pl')).

sembunyikanKartu(_) :-
giliran(Pemain),
tangan(Pemain, [_]), !, 
write('Gagal! Kartu Anda tinggal 1.'), nl, fail.

sembunyikanKartu(Index) :-
giliran(Pemain),
tangan(Pemain, ListKartu),
panjang(ListKartu, Jumlah),
Jumlah > 1, 
getElement(Index, ListKartu, kartu(Warna, Jenis)),
assertz(sembunyi(Pemain, Index)),
write('Kartu '), write(Warna), write('-'), write(Jenis), write(' berhasil disembunyikan.'), nl, 
next_giliran, !.

