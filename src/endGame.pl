hitung_poin(kartu(_, Jenis), Poin) :- 
(termasuk_member(Jenis, [skip, revers, draw_two]) -> Poin = 10
; termasuk_member(Jenis, [wild, wild_draw_four, mimic]) -> Poin = 20
; Poin = Jenis), !.

hitung_total([], 0).
hitung_total([Kartu|Sisa], TotalPoin) :-
hitung_poin(Kartu, Poin),
hitung_total(Sisa, PoinSisa),
TotalPoin is Poin + PoinSisa.

peringkat_tinggi(pemain(_, Poin1, _), pemain(_, Poin2, _)) :- Poin1 < Poin2.
peringkat_tinggi(pemain(_, Poin, Jumlah1), pemain(_, Poin, Jumlah2)) :- Jumlah1 =< Jumlah2.

sort_leaderboard([], []).
sort_leaderboard([Pemain|Sisa], Sorted) :-
sort_leaderboard(Sisa, SortedSisa),
insert_pemain(Pemain, SortedSisa, Sorted).

insert_pemain(X, [], [X]) :- !.
insert_pemain(X, [Y|T], [X, Y|T]) :- 
peringkat_tinggi(X, Y), !.
insert_pemain(X, [Y|T], [Y|Nt]) :- 
insert_pemain(X, T, Nt).

endGame :- 
urutan(ListPemain),
kumpulkan_data(ListPemain, Data),
sort_leaderboard(Data, Leaderboard),
write('Permainan selesai!'), nl,
print_perhitungan_sisa(Leaderboard), nl,
write('Urutan pemenang:'), nl,
print_pemenang(Leaderboard, 1), !.

kumpulkan_data([], []).
kumpulkan_data([Nama|T], [pemain(Nama, Poin, Jumlah)|Sisa]) :-
tangan(Nama, ListKartu),
panjang(ListKartu, Jumlah),
hitung_total(ListKartu, Poin),
kumpulkan_data(T, Sisa).

print_perhitungan_sisa([]).
print_perhitungan_sisa([pemain(Nama, Poin, _)|T]) :-
write(Nama), write(': total sisa kartu = '), write(Poin), write(' poin'), nl,
print_perhitungan_sisa(T).

print_pemenang([], _).
print_pemenang([pemain(Nama, Poin, _)|T], Rank) :-
write(Rank), write('. '), write(Nama), write(' ('), write(Poin), write(' poin)'), nl,
NextRank is Rank + 1,
print_pemenang(T, NextRank).