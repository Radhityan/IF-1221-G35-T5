/*I mplemenrasi manual hapus list */
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
    appendUjung(Temp,[Head],Reversed).

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
:- dynamic (list_kartu)/1.

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