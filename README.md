# FiberTycoon

Tahová strategie o řízení firmy, která staví optickou síť.

## O hře

FiberTycoon je manažerská strategie inspirovaná reálným provozem koordinace výstavby optických sítí v ČR. Hráč řídí firmu, která připojuje domy k optické síti, řeší poruchy, reklamace a hospodaří s omezenými zdroji.

## Ovládání

| Akce | Ovládání |
|------|----------|
| Připojit dům | Levé kliknutí na dům v dosahu rozvaděče |
| Umístit rozvaděč | Pravé kliknutí na prázdné pole |
| Další den | Tlačítko v pravém panelu |
| Opravit poruchu | Kliknutí na červený/žlutý dům |

## Herní mechaniky

- Rozvaděče — domy lze připojit pouze v dosahu rozvaděče (Manhattan vzdálenost <= 4)
- Materiál — každé připojení spotřebuje 50m kabelu a 2 konektory, oprava 20m a 2 konektory
- Týmy — omezený počet týmů, každý může dělat jednu zakázku denně
- Poruchy a reklamace — náhodně vznikají na připojených domech
- Ekonomika — příjem 5 000 Kč/den za připojený dům, pokuty za neřešené zakázky, platy týmů 8 000 Kč/den
- Reputace — klesá za expirované zakázky a neopravené domy, stoupá za včasné opravy

## Upgrady

- Nový tým (150 000 Kč)
- Objednat kabel (40 000 Kč, dodání za 2 dny)
- Objednat konektory (10 000 Kč, dodání za 2 dny)
- Koupit rozvaděč (80 000 Kč, dodání za 3 dny)

## Technologie

- Engine: Godot 4.7 Stable
- Jazyk: GDScript 2.0
- Assety: Kenney Tiny Town (CC0)

## Architektura

Main (Node2D) — kořen scény
- GameManager (Node) — herní logika, ekonomika, týmy
- Map (Node2D) — mapa města, domy, rozvaděče
- UI (CanvasLayer) — pravý panel se statistikami a upgrady

### Soubory

| Soubor | Odpovědnost |
|--------|-------------|
| GameManager.gd | Stav hry, ekonomika, týmy, zakázky |
| Map.gd | Mapa, domy, rozvaděče, klikání |
| ui.gd | UI panel, statistiky, upgrady |
| Job.gd | Model zakázky |
| Team.gd | Model týmu |
| JobManager.gd | Generování a správa zakázek |
| MainMenu.gd | Hlavní menu |
| game_over.gd | Game Over obrazovka |

## Principy Clean Code

- Decoupling — herní logika (GameManager) oddělená od zobrazení (UI, Map)
- Malé funkce — každá funkce má jednu zodpovědnost
- Smysluplná jména — anglické názvy s jasným významem
- Enum místo magic stringů — Job.Type, Team.Skill

## Spuštění

1. Nainstaluj Godot 4.7 z godotengine.org
2. Otevři projekt v Godotu
3. Spusť klávesou F5

## Autor

Jáchym Havlíček — UTB ve Zlíně
