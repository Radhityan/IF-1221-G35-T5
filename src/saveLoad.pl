/* Deklarasi Dynamic */
:- dynamic urutanPemain/1.
:- dynamic giliran/1.
:- dynamic discardTop/1.
:- dynamic warnaTop/1.
:- dynamic kartuPemain/2.
:- dynamic arahPermainan/1.
:- dynamic statusUni/1.

/* Save Game */
saveGame:-
    write("Masukkan nama file penyimpanan: "),
    read_term(Nama, []),
    name(Nama, NamaX),
    name('.txt', NamaY),
    appendUjung(NamaX, NamaY, NamaZ), /* aplikasi append dari aksi.pl */
    name(NamaFile, NamaZ),
    open(NamaFile, write, Stream),
    saveState(Stream),
    close(Stream),
    write("Status permainan berhasil disimpan ke ", NamaFile).

saveState(Stream):-
    urutanPemain(Pemain),
    format(Stream, "urutan_pemain: ", [Pemain]),
    giliran(Giliran),
    format(Stream, "giliran: ", [Giliran]),
    discardTop(Discard),
    format(Stream, "discard_top: ", [Discard]),
    warnaTop(Warna),
    format(Stream, "warna_aktif: ", [Warna]),
    arahPermainan(Arah),
    format(Stream, "arah_permainan: ", [Arah]),
    statusUni(Uni),
    format(Stream, "status_UNI: ", [UNI]),
    kartuPemain(Kartu),
    saveKartu(Stream, Kartu).

saveKartu(_, []).
saveKartu(Stream, [Pemain|Sisa]):-
    listKartu(Pemain, ListKartu),
    format(Stream, "kartu(): ", [Pemain, ListKartu]),
    saveKartu(Stream, Sisa).

/* Load Game */
loadGame:-
    write("Masukkan nama file yang akan dimuat: "),
    read_term(Nama, []),
    name(Nama, NamaX),
    name('.txt', NamaY),
    appendUjung(NamaX, NamaY, NamaZ),
    name(NamaFile, NamaZ),
    cekFile(NamaFile).

cekFile(NamaFile):-
    \+ file_exist(NamaFile),
    loadState(NamaFile).

loadState:- 
    rectract(urutanPemain(_)),
    rectract(giliran(_)),
    rectract(discardTop(_)),
    rectract(warnaTop(_)),
    rectract(arahPermainan(_)),
    rectract(statusUni(_)),
    rectract(kartuPemain(_,_)).