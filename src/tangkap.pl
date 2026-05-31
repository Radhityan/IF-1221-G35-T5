/* Kasus pemain dikenakan wild_draw_four */
tangkap(_) :-
    giliran(Pemain),
    pending_wild_draw_four(_, Pemain, _, _),
    write('Ada kartu wild_draw_four dimainkan! Anda hanya bisa melakukan aksi ambilKartu atau tantang. '), nl, !.

tangkap(Target):-
    uni(Target),
    tangan(Target, Tangan),
    bagiKartu(Target, 2, Tangan),
    retract(uni(Target)).

tangkap(Target):-
    \+uni(Target),
    giliran(Pemain),
    tangan(Pemain, Tangan),
    bagiKartu(Pemain, 2, Tangan).

