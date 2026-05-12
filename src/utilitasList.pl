ambilElemenList(1, [H|_], H).
ambilElemenList(N, [_|T], Elemen) :-
    N > 1,
    N1 is N - 1,
    ambilElemenList(N1, T, Elemen).

hapusElemenList(1, [_|T], T).
hapusElemenList(N, [H|T], [H|HasilTail]) :-
    N > 1,
    N1 is N - 1,
    hapusElemenList(N1, T, HasilTail).