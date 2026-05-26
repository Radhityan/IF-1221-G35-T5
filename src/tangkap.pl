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

