# 🏅 Olympic Games Data Engineering & Analytics Project

This project demonstrates the end-to-end design and implementation of a relational Data Warehouse (**PostgreSQL**) for historical Olympic Games data (**1960–2016**), based on a custom Entity-Relationship Diagram (**DrawSQL**). The focus lies on data transformation using **Python (Pandas)**, building a high-performance **Star Schema**, running analytical SQL queries, and connecting the database to **Power BI** for visualization.

---

## 📁 Repository Structure


olympics-data-warehouse/
├── erd/
│   └── star_schema.png           # ERD / DrawSQL diagram of the Star Schema
├── dashboard/
│   └── dashboard.pbix            # Power BI Dashboard
├── etl/
│   ├── Engineering.ipynb         # Python ETL notebook (cleaning, mapping & dimensioning)
│   └── Power_BI_connect.ipynb    # Python data connector for Power BI Desktop
├── sql/
│   ├── DDL.sql                   # DDL: Tables, constraints & ENUM definitions
│   ├── DML.sql                   # DML: Bulk CSV loading via PostgreSQL COPY
│   └── queries/
│       ├── hypothesis1a.sql      # Inclusion of African & Latin American nations
│       ├── hypothesis1b.sql      # Men vs. Women participation comparison
│       ├── hypothesis2.sql       # Physical evolution (Weight, Height, BMI, Ponderal Index)
│       └── hypothesis3.sql       # Medal upgrades (Window Function vs. Self-Join)
└── README.md
```

---

## 🎯 Research Questions & Hypotheses (Business Case)

This Data Warehouse was designed to investigate three data-driven hypotheses across social, sports science, and sports psychology domains:

1. **Inclusion & Globalization in Exclusive Sports (`hypothesis1a.sql` & `hypothesis1b.sql`)**
   * *Question:* When did historically exclusive disciplines (e.g., Sailing, Fencing, Equestrianism, Hockey, Golf) open up to African and Latin American nations as well as female athletes (compared to male participation)?
   * *Relevance:* Highlights trends in emancipation, globalization, and the reduction of socioeconomic barriers in elite sports.

2. **Physical Evolution of Olympic Medalists (`hypothesis2.sql`)**
   * *Question:* How have weight, height, BMI, and Ponderal Index of medal-winning athletes evolved since 1960?
   * *Relevance:* Provides data-backed insights for modern training methodologies, sports science, and talent identification.

3. **Sports Psychology: Silver Regret vs. Bronze Momentum (`hypothesis3.sql`)**
   * *Question:* Are Silver medalists more likely than Bronze medalists to win Gold in the same event at subsequent Olympic Games (4, 8, 12, or 16 years later)?
   * *Relevance:* Explores the psychological impact of finishing with a final loss (Silver) versus a final victory (Bronze) for mental coaching and peak performance strategies.

---

## 🏗️ Database Architecture

Instead of flat, denormalized tables, a structured **Star Schema** was implemented to minimize data redundancy and optimize analytical query performance:

* **Fact Table:** `fact_medal_olympics` (stores metrics such as `age`, `height`, `weight`, `year`, `medal`, along with foreign keys)
* **Dimension Tables:**
  * `dim_country` (`id_co`, `noc`, `country`, `continent` – including custom region mapping for Africa & Latin America)
  * `dim_athlete` (`id_ath`, `name`, `sex`)
  * `dim_olympics` (`id_saol`, `sport`, `event`)

![Star Schema Diagram](erd/star_schema.png)

### 💡 Key Design Decisions
* **Surrogate Keys (`bigint`):** Generated artificial integer primary keys (`id_co`, `id_ath`, `id_saol`) to improve join performance compared to text-based keys (e.g., NOC country codes).
* **PostgreSQL `ENUM` Type (`medal_enum`):** Implemented a custom `ENUM` (`'Gold'`, `'Silver'`, `'Bronze'`, `''`) to enforce data integrity at the database level and optimize storage efficiency.

---

## 🛠️ Data Engineering & Challenges (Lessons Learned)

During the transformation of the raw dataset (`olympics.csv`) into a relational Star Schema for PostgreSQL, several data quality and schema challenges were encountered and resolved within the ETL pipeline:

### 1. Handling Missing Values & Data Types (`Int64` vs. `float`)
* **Issue:** Due to missing values (`NaN`) in columns like `age`, `height`, and `weight`, Pandas automatically cast these fields to `float` (e.g., `180.0`). This caused data type mismatch errors when importing into PostgreSQL (`SMALLINT` / `INTEGER`). Standard NumPy `int` casting also failed because it does not support null values.
* **Solution:** Used Pandas' nullable integer type (**`Int64`**), which preserves true integer values while allowing `NaN` entries.
* **Validation:** Cross-checked row counts of the transformed tables against the original CSV file to ensure no records were lost during type conversion.

### 2. Primary & Foreign Key Integrity (Data Validation)
* **Issue:** Historical `noc` codes can appear with slightly varying country/team names across decades, and athletes compete in multiple events. Initial deduplication and name-based joins created duplicate IDs, causing `Unique Constraint` violations when loading `fact_medal_olympics` in **pgAdmin**.
* **Solution:** 
  * Deduplicated `dim_country` strictly on `subset=["noc"]` and `dim_athlete` on `["name", "sex"]` to prevent Cartesian product row multiplication during `pd.merge`.
  * Regenerated a clean, sequential primary key (`id`) for the fact table using `range(1, len(...) + 1)` after all joins and deduplication steps were completed.

### 3. ETL & Database Schema Consistency
* **Standardized Naming:** Converted all column names and categorical strings (such as `noc` and `continent`) to lowercase (`snake_case`) to avoid case-sensitivity issues in PostgreSQL queries.
* **Schema Alignment:** Synchronized column names (`id_co`, `id_ath`, `id_saol`), data types (`medal_enum`), and column ordering prior to CSV export to match the PostgreSQL/DrawSQL schema 1:1.

### 4. Analytical SQL Method Comparison (`hypothesis3.sql` – Window Function vs. Self-Join)
* **Approach A (`LEAD()` Window Function):** Initially tested `LEAD(medal) OVER (PARTITION BY id_ath, id_saol ORDER BY year)` to compare an athlete's medal with their immediately following appearance in the same event. While concise, this approach skips cases where an athlete participated in between without winning a medal (`''`) and mixes different time intervals.
* **Approach B (`Self-Join` across 4–16 Year Gaps):** Implemented a `Self-Join` (`f1.year + 4/8/12/16 = f2.year`) to isolate exact Olympic cycles and capture true medal upgrades from Silver/Bronze to Gold—even if an athlete missed or went medal-less in an intermediate Olympic year.

---

## 📊 Power BI Data Connector (`etl/Power_BI_connect.ipynb`)

This notebook bridges the PostgreSQL Data Warehouse and **Power BI Desktop** (*Get Data -> Python script*) by executing the analytical SQL files and exposing the results as Pandas DataFrames:

* **Database Connection:** Uses `SQLAlchemy` (`create_engine`) to connect to the local `Olympics` PostgreSQL database (reading credentials securely via environment variables).
* **SQL Execution:** Reads the external query files (`hypothesis1a.sql`, `hypothesis1b.sql`, `hypothesis2.sql`, `hypothesis3.sql`) sequentially using UTF-8 encoding.
* **DataFrame Output:** Executes each query via `pd.read_sql_query()` and stores the results in dedicated DataFrames (`df_chart_1a`, `df_chart_1b`, `df_chart_2`, `df_chart_3`), which Power BI automatically detects as tables for visualization.

---

## 🚀 Setup & Execution

1. **Run ETL Pipeline:**
   Place `olympics.csv` in the project directory and run `etl/Engineering.ipynb` to generate the cleaned dimension and fact CSV files.
2. **Create Database Schema:**
   Execute `sql/DDL.sql` in PostgreSQL (e.g., via pgAdmin) to create the `medal_enum` type and tables.
3. **Load Data (DML):**
   Update the local file paths in `sql/DML.sql` and run the script to bulk-load the CSV files via `COPY`.
4. **Run Analytics & Power BI:**
   Execute the queries in `sql/queries/` directly in PostgreSQL or import them into Power BI Desktop via `etl/Power_BI_connect.ipynb`.
