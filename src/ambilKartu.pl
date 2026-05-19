:- initialization(consult('utilitasList.pl')).

/* Helper mengambil kartu untuk 1 atau lebih kartu */
ambil_kartu(_, 0) :- !.
ambil_kartu(Pemain, Jumlah) :-
Jumlah > 0,
cariKartu(ListKartu),
panjang(ListKartu, HasilPanjang),
MaxRandom is HasilPanjang + 1
random(1, MaxRandom, IndexRandom),
getElement(IndexRandom, ListKartu, KartuAcak),
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
(discardPile([kartu(Warna, Jenis) | _]), Jenis == draw_two -> ambil_kartu(Pemain, 2)
;discardPile([kartu(Warna, Jenis) | _]), Jenis == wild_draw_four -> ambil_kartu(Pemain, 4)
;ambil_kartu(Pemain, 1)), !.
