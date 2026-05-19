/* Implementasi manual length */
panjang([], 0).
panjang([_|T], Hasil) :-
panjang(T, HasilLama),
Hasil is HasilLama + 1.

/* Implementasi manual append */
appendUjung([], Kartu, [Kartu]).
appendUjung([H|T], Kartu, [H|HasilAppend]) :- 
appendUjung(T, Kartu, HasilAppend).

/* Implementasi manual nth0 */
getElement([H|_], 1, H) :- !.
getElement([_|T], Index, Element) :-
Index > 1,
NextIndex is Index - 1,
getElement(T, NextIndex, Element).

/* Implementasi manual member */
termasuk_member(X, [X|_]) :- !.
termasuk_member(X, [_|T]) :-
termasuk_member(X, T).

/* Implementasi manual findall untuk mengumpulkan fakta kartu*/
:- dynamic list_kartu/1.

cariKartu(Hasil) :-
retractall(list_kartu(_)),
assertz(list_kartu([])),
kartu(Warna, Jenis),
update_list(kartu(Warna, Jenis)),
fail.

cariKartu(Hasil) :- list_kartu(Hasil), !.

update_list(Kartu) :-
retract(list_kartu(List)),
ListBaru = [Kartu|List],
assertz(list_kartu(ListBaru)).

/* Aksi ambilKartu */
ambilKartu :- 
turn(Pemain),
cariKartu(ListKartu),
panjang(ListKartu, HasilPanjang),
MaxRandom is HasilPanjang + 1.
random(1, MaxRandom, IndexRandom),
getElement(ListKartu, IndexRandom, KartuAcak),
tangan(Pemain, TanganLama),
appendUjung(TanganLama, KartuAcak, TanganBaru),
retract(tangan(Pemain, TanganLama)),
assertz(tangan(Pemain, TanganBaru)),
write(Pemain), write(' mendapatkan kartu: '), write(KartuAcak), nl, !.

/* Aksi-Aksi Pendukung*/
/* Aksi lihatCommand */

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
turn(Pemain),
tangan(Pemain, ListKartu),
write('Berikut kartu yang anda miliki.'), nl,
print_daftar_kartu(ListKartu, 1, Pemain),
!.

print_daftar_kartu([], _, _) :- !.
print_daftar_kartu([kartu(Warna, Jenis) | T], Index, Pemain) :-
write(Index), write('. '),
write(Warna), write('-'), write(Jenis),
cek_sembunyi(Pemain, Index), nl,
NextIndex is Index + 1,
print_daftar_kartu(T, NextIndex, Pemain).

cek_sembunyi(Pemain, Index) :- 
sembunyi(Pemain, Index),
write(' (disembunyikan)'), !.
cek_sembunyi(_, _) :- !.

/* Aksi cekInfo */

cekInfo :- discard_pile([kartu(Warna, Jenis) | _]),
write('Kartu discard top: '), write(Warna), write('-'), write(Jenis), nl, nl, 
urutan_pemain(ListPemain),
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
panjang(ListKartu, Jumlah),
write('Nama pemain '), write(Index), write(': '), write(Nama), nl,
write('Jumlah kartu : '), write(Jumlah), nl, nl,
NextIndex is Index + 1, 
print_detail_pemain(T, NextIndex).

