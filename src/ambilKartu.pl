/* Implementasi manual findall untuk mengumpulkan fakta kartu*/
cariKartu(_) :-
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

/* Helper mengambil kartu untuk 1 atau lebih kartu */
ambil_kartu(_, 0) :- !.
ambil_kartu(Pemain, Jumlah) :-
Jumlah > 0,
cariKartu(ListKartu),
panjang(ListKartu, HasilPanjang),
MaxRandom is HasilPanjang + 1,
random(1, MaxRandom, IndexRandom),
getElement(IndexRandom, ListKartu, KartuAcak),
/* Update kartu di tangan */
tangan(Pemain, TanganLama),
appendUjung(TanganLama, KartuAcak, TanganBaru),
retract(tangan(Pemain, TanganLama)),
assertz(tangan(Pemain, TanganBaru)),
write(Pemain), write(' mendapatkan kartu: '), write(KartuAcak), nl, 
SisaJumlah is Jumlah - 1,
ambil_kartu(Pemain, SisaJumlah).


/* Aksi ambilKartu */
ambilKartu :- 
giliran(Pemain),
ambil_kartu(Pemain, 1),
gantiGiliran,
giliran(NextPemain),
write('Giliran '), write(NextPemain), write('.'), nl, !.
