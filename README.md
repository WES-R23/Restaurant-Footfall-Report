# Restaurant-Footfall-Report
Footfall and walk-in analysis for a city centre restaurant — weather correlation, seasonal trends and payday uplift using MySQL and Excel


# Restaurant Footfall & Walk-In Analysis

*A real-world analysis project using operational data from a city centre restaurant, examining how weather, day of week, seasonality and calendar events influence walk-in footfall.*

---

## Project Overview
This project analyses walk-in cover data spanning approximately two years, cross-referenced against daily weather readings, calendar events and booking patterns. The goal was to identify reliable trends the business could act on for staffing, inventory management and planning decisions.

---

**Headline findings:**
- Bad weather days averaged 41.9 more walk-ins than good weather days
- September is consistently the quietest month — 1.6 to 1.8 standard deviations below average
- November is the strongest month for walk-ins overall
- Wednesday is the slowest day of the week
- Payday Fridays consistently outperform standard Fridays

---

## Files
- `raw_data.xlsx` — source data including daily bookings, sales and York weather readings
- `eda.xlsx` — engineered fact and dimension tables, statistical breakdowns and analysis workings
- `footfall_eda.sql` — MySQL queries covering all core EDA including weather banding, seasonal analysis, payday uplift and calendar event impact
- `Footfall_Report.docx` — final business report with findings, statistical context and operational recommendations

---

## Database Schema
The analysis used a star schema built in MySQL with the following structure:
- `fact_bookings` — daily cover counts including walk-ins, advance and same-day bookings
- `fact_sales` — daily gross and net sales figures
- `dim_weather` — daily weather readings including temperature, rainfall and wind
- `dim_date` — date dimension with day name, month, week, payday flag and weekend flag
- `dim_calendar_event` — local events mapped to date keys to assess footfall impact
- `stg_*` tables — staging layer used for raw ingestion and transformation prior to fact loading

---

## Key Analysis
- Weather correlation — walk-ins segmented by temperature band and rainfall band, with best and worst weather days compared directly
- Seasonal trends — monthly averages with standard deviation scoring to identify genuine outliers vs random variation
- Day of week patterns — average walk-ins by day to identify structural slow and busy periods
- Payday uplift — Friday walk-ins split by payday vs standard to quantify the effect
- Calendar event impact — average covers during local events compared to baseline

---

## Statistical Methods
Standard deviation was used to measure how far each month and day sits from the overall average, confirming September's underperformance as a genuine structural pattern rather than random variation. Significance testing confirmed that both temperature and precipitation have a statistically reliable effect on walk-ins — not noise.

---

## Tools Used
- **MySQL** — star schema design, staging to fact transformation, EDA queries
- **Excel** — supplementary statistical analysis and data validation
- **Word** — final business report
