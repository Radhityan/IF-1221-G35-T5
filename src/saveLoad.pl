/* SAVE GAME */

saveGame :-
    giliran(Pemain),
    pending_wild_draw_four(_, Pemain, _, _),
    write('Tidak dapat menyimpan permainan sekarang.'),
    nl,
    write('Anda harus menyelesaikan aksi tantang atau ambilKartu terlebih dahulu.'),
    nl, 
    !.

saveGame :-
    write('Masukkan nama file penyimpanan: '),
    read(Nama),
    name(Nama, NamaX),
    name('.txt', NamaY),
    gabungList(NamaX, NamaY, NamaZ),  /* utilitasList */
    name(NamaFile, NamaZ),
    cekDanSimpan(NamaFile).

/* Cek apakah file sudah ada, minta konfirmasi jika ada */
cekDanSimpan(NamaFile) :-
    file_exists(NamaFile),
    write('File '),
    write(NamaFile),
    write(' sudah ada. Timpa? (y/n): '),
    read(Jawaban),
    tanganiKonfirmasi(Jawaban, NamaFile).

cekDanSimpan(NamaFile) :-
    \+ file_exists(NamaFile),
    lakukanSimpan(NamaFile).

tanganiKonfirmasi(y, NamaFile) :-
    lakukanSimpan(NamaFile).

tanganiKonfirmasi(Jawaban, _) :-
    Jawaban \= y,
    write('Masukkan nama file baru: '),
    read(NamaBaru),
    name(NamaBaru, NamaBaruX),
    name('.txt', NamaExt),
    gabungList(NamaBaruX, NamaExt, NamaBaruZ),  /* utilitasList */
    name(NamaFileBaru, NamaBaruZ),
    cekDanSimpan(NamaFileBaru).

/* Buka file dan tulis semua state */
lakukanSimpan(NamaFile) :-
    open(NamaFile, write, Stream),
    simpanState(Stream),
    close(Stream),
    format('Status permainan berhasil disimpan ke ~w.~n', [NamaFile]).

/* Tulis seluruh state permainan ke file */
simpanState(Stream) :-
    urutan(ListPemain),
    format(Stream, 'urutan:~q.~n', [ListPemain]),

    giliran(Giliran),
    format(Stream, 'giliran:~q.~n', [Giliran]),

    discardPile(Discard),
    format(Stream, 'discardPile:~q.~n', [Discard]),

    simpanSemuaTangan(Stream, ListPemain).

/* Simpan kartu tangan semua pemain secara rekursif */
simpanSemuaTangan(_, []).
simpanSemuaTangan(Stream, [Pemain|Sisa]) :-
    tangan(Pemain, ListKartu),
    format(Stream, 'tangan(~q):~q.~n', [Pemain, ListKartu]),
    simpanSemuaTangan(Stream, Sisa).


/* LOAD GAME */
loadGame :-
    giliran(Pemain),
    pending_wild_draw_four(_, Pemain, _, _),
    write('Tidak dapat memuat permainan sekarang.'),
    nl,
    write('Anda harus menyelesaikan aksi tantang atau ambilKartu terlebih dahulu.'),
    nl, 
    !.

loadGame :-
    write('Masukkan nama file yang akan dimuat: '),
    read(Nama),
    name(Nama, NamaX),
    name('.txt', NamaY),
    gabungList(NamaX, NamaY, NamaZ), /* utilitasList */
    name(NamaFile, NamaZ),
    cekDanMuat(NamaFile).

/* Cek keberadaan file lalu muat */
cekDanMuat(NamaFile) :-
    file_exists(NamaFile),
    muatState(NamaFile),
    format('Status permainan berhasil dimuat dari ~w.~n', [NamaFile]),
    giliran(G),
    format('Melanjutkan giliran ~w.~n', [G]).

cekDanMuat(NamaFile) :-
    \+ file_exists(NamaFile),
    format('Error: File ~w tidak ditemukan.~n', [NamaFile]).

/* Bersihkan semua fakta lama lalu baca file */
muatState(NamaFile) :-
    bersihkanFakta,
    open(NamaFile, read, Stream),
    bacaSemuaTerm(Stream),
    close(Stream).

bersihkanFakta :-
    retractall(urutan(_)),
    retractall(giliran(_)),
    retractall(discardPile(_)),
    retractall(arahPermainan(_)),
    retractall(tangan(_, _)).

bacaSemuaTerm(Stream) :-
    read_term(Stream, Term, []),
    Term \= end_of_file,
    assertTerm(Term),
    bacaSemuaTerm(Stream).

bacaSemuaTerm(Stream) :-
    read_term(Stream, Term, []),
    Term = end_of_file.

/* Petakan setiap term ke fakta dinamis */
assertTerm(urutan:V)        :- asserta(urutan(V)).
assertTerm(giliran:V)       :- asserta(giliran(V)).
assertTerm(discardPile:V)   :- asserta(discardPile(V)).
assertTerm(arahPermainan:V) :- asserta(arahPermainan(V)).
assertTerm(tangan(P):V)     :- asserta(tangan(P, V)).