# FiberTycoon — Koncept hry

## Inspirace

Hra vychází z reálných zkušeností koordinátora výstavby optických sítí v ČR. Denní práce zahrnuje přidělování montážních týmů na zakázky, řešení poruch a reklamací, správu materiálu a dodržování smluvních termínů.

## Žánr

Tahová manažerská strategie (tycoon) s prvky resource managementu.

## Hlavní herní smyčka

1. Ráno přijdou nové zakázky a náhodné události
2. Hráč přiřadí týmy, objedná materiál, staví rozvaděče, připojuje domy
3. Klikne Další den
4. Hra zpracuje výsledky — příjmy, pokuty, platy, poruchy

## Inspirační tituly

- Mini Motorways — plánování infrastruktury
- Game Dev Tycoon — řízení firmy
- Two Point Hospital — rozhodování o prioritách
- OpenTTD — budování sítě a ekonomika

## Klíčové designové rozhodnutí

### Tahová vs Real-time

Zvolena tahová strategie — umožňuje promyšlenější rozhodnutí a jednodušší implementaci.

### Dashboard + Mapa

Kombinace obou — mapa vlevo pro vizuální přehled, dashboard vpravo pro statistiky a upgrady.

### Ekonomický tlak

Denní náklady (platy týmů 8 000 Kč/tým) a pokuty za neopravené domy (5 000 Kč/den za poruchu, 3 000 Kč/den za reklamaci) vytváří konstantní tlak na hráče. Musí aktivně rozšiřovat síť aby generoval příjmy (5 000 Kč/den za připojený dům).

### Reklamace jako hlavní mechanika

Poruchy a reklamace spotřebovávají materiál a čas týmů. Neopravené domy snižují reputaci a stojí peníze každý den. Včasná oprava naopak reputaci zvyšuje (+2 za opravu).

### Materiálový systém

Kabel a konektory jsou omezené. Objednávky trvají 2 dny. Hráč musí plánovat dopředu — bez materiálu nemůže připojovat ani opravovat.

### Rozvaděče a dosah

Domy lze připojit pouze v dosahu rozvaděče (Manhattan vzdálenost <= 4). Hráč musí strategicky umisťovat rozvaděče aby pokryl co nejvíce domů.

## Budoucí rozvoj

- Různé typy budov (bytové domy, firmy)
- Subdodavatelé
- Kampanový mód s příběhem
- Multiplayer — konkurenční firmy
