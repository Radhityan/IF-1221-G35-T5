:- initialization(consult('utilitasList.pl')).

uni(_) :-
giliran(Pemain),
tangan(Pemain, ListKartu),
panjang(ListKartu, Jumlah), 
Jumlah > 2,
ambilKartu,
write('UNI tidak valid karena memainkan kartu tidak menyisakan 1 kartu!'), nl, !.

uni(Index) :-
giliran(Pemain),
tangan(Pemain, ListKartu),
panjang(ListKartu, Jumlah),
Jumlah == 2, 
getElement(Index, ListKartu, kartu(Warna, Jenis)),
validasi(Warna, Jenis),
mainkanKartu(Index),
giliran(NextPemain),
write(Pemain), write(' memainkan kartu: '), write(Warna), write('-'), write(Jenis), nl,
write(Pemain), write(' menyerukan UNI!'), nl, nl,
write('Giliran'), write(NextPemain), nl.