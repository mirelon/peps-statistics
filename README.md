# README

Vyhodnocovanie logopedického testu PEPS-C 2015, ktorého output je v textových súboroch. Tie sa zálohujú na Dropboxe. Táto aplikácia cez Dropbox API získava informácie o klientoch a o výsledkoch pre jednotlivé subtesty. Pomocou príkazu

    rails db:seed
    
sa stiahnú všetky dáta a uložia do Postgres databázy. K nej exisuje administračné rozhranie ActiveAdmin, v ktorom sa budú v budúcnosti automaticky počítať štatistiky.
