/* mencari sisa kartu setiap pemain */
sisa_Kartu_Pemain([]).
sisa_Kartu_Pemain([Pemain | Sisa]) :-
    tangan(Pemain, Tangan),
    panjang(Tangan, Jumlah),
    Jumlah =:= 1,
    sisa_Kartu_Pemain(Sisa).

godsHand :-
    urutan(SemuaPemain),
    (sisa_Kartu_Pemain(SemuaPemain)
    -> write('Mekanisme God''s Hand tidak dapat dijalankan untuk menjaga keseimbangan permainan!'), nl;   
    random(1, 101, Peluang),
    (Peluang =< 20 -> write('Tuhan telah berkehendak.'), nl,
    panjang(SemuaPemain, TotalPemain),
    LimitPemain is TotalPemain + 1,
    random(1, LimitPemain, IdxKorban),
    getElement(IdxKorban, SemuaPemain, Korban),

    tangan(Korban, TanganKorban),
    panjang(TanganKorban, JmlKartu),
    LimitKartu is JmlKartu + 1,
    random(1, LimitKartu, IdxKartu),
    getElement(IdxKartu, TanganKorban, KartuPindah),
    KartuPindah = kartu(Warna, Jenis),

    hapusElemenList(IdxKorban, SemuaPemain, SisaPemain),
    panjang(SisaPemain, TotalSisa),
    LimitSisa is TotalSisa + 1,
    random(1, LimitSisa, IdxPenerima),
    getElement(IdxPenerima, SisaPemain, Penerima),

    hapusElemenList(IdxKartu, TanganKorban, TanganKorbanBaru),
    retract(tangan(Korban, _)),
    asserta(tangan(Korban, TanganKorbanBaru)),
            
    tangan(Penerima, TanganPenerima),
    asserta(tangan(Penerima, [KartuPindah | TanganPenerima])),
            
    write('Kartu '), write(Warna), write('-'), write(Jenis),
    write(' milik '), write(Korban),
    write(' berpindah ke tangan '), write(Penerima), write('!'), nl;

    write('Tuhan belum berkehendak pada giliran ini...'), nl)),
    gantiGiliran,!.