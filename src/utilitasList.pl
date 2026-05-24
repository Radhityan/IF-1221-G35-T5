/*Implementasi manual hapus list */
hapusElemenList(1, [_|T], T).
hapusElemenList(N, [H|T], [H|HasilTail]) :-
    N > 1,
    N1 is N - 1,
    hapusElemenList(N1, T, HasilTail).

/* Implementasi manual length */
panjang([], 0).
panjang([_|T], Hasil) :-
panjang(T, HasilLama),
Hasil is HasilLama + 1.

/* Implementasi manual append */
appendUjung([], Kartu, [Kartu]).
appendUjung([H|T], Kartu, [H|HasilAppend]) :- 
appendUjung(T, Kartu, HasilAppend).

/* Implementasi manual reverse */
reverseList([],[]).
reverseList([Head|Tail], Reversed):-
    reverseList(Tail,Temp),
    appendUjung(Temp, Head, Reversed).

/* Implementasi manual nth1 */
getElement(1, [H|_], H) :- !.
getElement(Index, [_|T], Element) :-
Index > 1,
NextIndex is Index - 1,
getElement(NextIndex, T, Element).

/* Implementasi manual member */
termasuk_member(X, [X|_]) :- !.
termasuk_member(X, [_|T]) :-
termasuk_member(X, T).

/* Implementasi alternatif panjang untuk skip kartu yang disembunyikan pada cekInfo */
panjang_tidakdisembunyikan(_, [], 0) :- !.
panjang_tidakdisembunyikan(Pemain, [Kartu|Sisa], Jumlah) :-
sembunyi(Pemain, Kartu), !,
panjang_tidakdisembunyikan(Pemain, Sisa, Jumlah).
panjang_tidakdisembunyikan(Pemain, [_|Sisa], Jumlah) :-
panjang_tidakdisembunyikan(Pemain, Sisa, SisaJumlah),
Jumlah is SisaJumlah + 1.