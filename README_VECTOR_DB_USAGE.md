# Návod na používání nástroje pro keyword clustering s vektorovou databází

Tento dokument obsahuje jasné instrukce a doporučené postupy pro efektivní práci s nástrojem na clustering klíčových slov s využitím vektorové databáze.

## Základní scénáře použití

### 1. První analýza klíčových slov (nový projekt)

Když začínáte s novým projektem nebo sadou klíčových slov:

```bash
python main.py --input-file ./data/keywords.csv --output-file ./output/results.xlsx --use-advanced-clustering --save-to-vector-db --vector-db-collection "projekt_nazev"
```

Tento příkaz:
- Načte klíčová slova ze souboru
- Vytvoří embeddingy
- Provede clustering
- Uloží výsledky do Excel souboru
- Uloží výsledky do vektorové databáze pod daným názvem kolekce

### 2. Načtení uložených výsledků z databáze

Když potřebujete znovu načíst dříve uložené výsledky bez přepočítávání clusterů:

```bash
python main.py --input-file ./data/keywords.csv --output-file ./output/loaded_results.xlsx --load-from-vector-db --vector-db-collection "projekt_nazev"
```

Tento příkaz:
- Načte všechna klíčová slova a jejich clustery z vektorové databáze
- Vygeneruje Excel soubor s těmito výsledky
- **Poznámka:** Aktuálně budou načtena VŠECHNA klíčová slova z databáze, ne pouze ta, která jsou v input souboru

### 3. Experimentování s parametry clusteringu

Když chcete vyzkoušet různé parametry bez ukládání do databáze:

```bash
python main.py --input-file ./data/keywords.csv --output-file ./output/experiment.xlsx --use-advanced-clustering --min-cluster-size 5
```

Tento příkaz:
- Vytvoří clustery s upravenými parametry
- Neuloží výsledky do databáze
- Je vhodný pro iterativní experimentování

## Správa verzí analýz

Doporučujeme ukládat různé verze analýz pod unikátními názvy kolekcí:

```bash
# Použití datumu v názvu kolekce
python main.py --input-file ./data/keywords.csv --output-file ./output/results_20240310.xlsx --use-advanced-clustering --save-to-vector-db --vector-db-collection "projekt_20240310"

# Použití popisu v názvu kolekce
python main.py --input-file ./data/keywords.csv --output-file ./output/results_min5.xlsx --use-advanced-clustering --min-cluster-size 5 --save-to-vector-db --vector-db-collection "projekt_min5_clusters"
```

## Doporučený workflow

### Fáze 1: Experimentování a ladění parametrů
1. Spouštějte analýzy bez ukládání do databáze
2. Experimentujte s různými parametry (min_cluster_size, epsilon, atd.)
3. Vyhodnocujte kvalitu clusterů v Excel výstupech

### Fáze 2: Produkční analýza
1. Jakmile najdete vhodné parametry, spusťte finální analýzu s ukládáním do DB
2. Použijte popisný název kolekce pro snadnou identifikaci v budoucnu
3. Archivujte Excel výstup s jasným označením

### Fáze 3: Používání uložených výsledků
1. Pro generování reportů nebo sdílení výsledků používejte načítání z DB
2. Při potřebě nového výstupu není nutné přepočítávat clustery

## Důležité poznámky

1. **Přepisování kolekcí:** Pokud použijete stejný název kolekce vícekrát, druhé spuštění přepíše předchozí výsledky.

2. **Načítání všech dat:** Aktuální implementace při načítání z DB vrací všechna klíčová slova z kolekce, ne jen ta ze vstupního souboru.

3. **Reprodukovatelnost:** Pro zajištění reprodukovatelných výsledků použijte parametr `--random-state 42`.

4. **Velikost batch pro výkonnostní optimalizace:** Pro velké datasety můžete použít parametry `--optimize-for-large-data --max-batch-size 1000 --use-parallel-processing`.

## Příklady použití pro běžné situace

### Měsíční analýza klíčových slov s verzováním

```bash
# Leden 2024
python main.py --input-file ./data/keywords_jan2024.csv --output-file ./output/results_jan2024.xlsx --use-advanced-clustering --save-to-vector-db --vector-db-collection "projekt_jan2024"

# Únor 2024
python main.py --input-file ./data/keywords_feb2024.csv --output-file ./output/results_feb2024.xlsx --use-advanced-clustering --save-to-vector-db --vector-db-collection "projekt_feb2024"
```

### Export dat z dřívější analýzy do nového formátu
```bash
python main.py --input-file ./data/dummy.csv --output-file ./output/export_jan2024.xlsx --load-from-vector-db --vector-db-collection "projekt_jan2024"
```

### Optimalizace pro velký dataset
```bash
python main.py --input-file ./data/large_dataset.csv --output-file ./output/large_results.xlsx --use-advanced-clustering --optimize-for-large-data --use-parallel-processing --max-batch-size 500 --save-to-vector-db --vector-db-collection "large_dataset_v1"
```

## Shrnutí doporučení

1. **Vždy používejte unikátní názvy kolekcí** pro důležité analýzy
2. **Experimentujte bez ukládání do DB**, dokud nejste spokojeni s výsledky
3. **Používejte verzované názvy souborů** pro Excel výstupy
4. **Pro rychlé ověření výsledků** používejte načítání z DB