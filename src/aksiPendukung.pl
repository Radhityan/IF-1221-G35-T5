/* Aksi-Aksi Pendukung*/
/* Aksi lihatCommand */

lihatCommand :-
\+ giliran(_), !, fail.

lihatCommand :-
giliran(Pemain),
pending_wild_draw_four(_, Pemain, _, _), !,
write('Aksi utama yang tersedia:'), nl,
write('1. ambilKartu'), nl, 
write('2. tantang'), nl,
write('Aksi pendukung yang tersedia:'), nl,
write('1. lihatCommand'), nl,
write('2. lihatKartu'), nl,
write('3. cekInfo'), nl.

lihatCommand :-
write('Aksi utama yang tersedia:'), nl, 
write('1. mainkanKartu'), nl,
write('2. ambilKartu'), nl, 
write('3. tantang'), nl,
write('4. uni'), nl,
write('5. tangkap'), nl, nl,
write('Aksi pendukung yang tersedia:'), nl,
write('1. lihatCommand'), nl,
write('2. lihatKartu'), nl,
write('3. cekInfo'), nl.

/* Aksi lihatKartu */

lihatKartu :- 
giliran(Pemain),
tangan(Pemain, ListKartu),
write('Berikut kartu yang anda miliki.'), nl,
print_daftar_kartu(ListKartu, 1, Pemain),
!.

print_daftar_kartu([], _, _) :- !.
print_daftar_kartu([kartu(Warna, Jenis) | T], Index, Pemain) :-
write(Index), write('. '),
write(Warna), write('-'), write(Jenis),
cek_sembunyi(Pemain, kartu(Warna, Jenis)), nl,
NextIndex is Index + 1,
print_daftar_kartu(T, NextIndex, Pemain).

cek_sembunyi(Pemain, Kartu) :- 
sembunyi(Pemain, Kartu),
write(' (disembunyikan)'), !.
cek_sembunyi(_, _) :- !.

/* Aksi cekInfo */

cekInfo :- discardPile([kartu(Warna, Jenis) | _]),
write('Kartu discard top: '), write(Warna), write('-'), write(Jenis), nl, nl, 
urutan(ListPemain),
write('Urutan pemain: '),
print_list_urutan(ListPemain), nl, nl,
print_detail_pemain(ListPemain, 1), !.

print_list_urutan([H]) :- 
write(H), !.
print_list_urutan([H|T]) :- 
write(H),
write(' - '),
print_list_urutan(T).

print_detail_pemain([], _).
print_detail_pemain([Nama|T], Index) :-
tangan(Nama, ListKartu),
/* panjang(ListKartu, Jumlah), */
panjang_tidakdisembunyikan(Nama, ListKartu, Jumlah),
write('Nama pemain '), write(Index), write(': '), write(Nama), nl,
write('Jumlah kartu : '), write(Jumlah), nl, nl,
NextIndex is Index + 1, 
print_detail_pemain(T, NextIndex).

