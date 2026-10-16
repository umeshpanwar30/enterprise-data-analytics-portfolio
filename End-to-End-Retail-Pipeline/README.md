# AI-Era End-to-End Retail Data Pipeline & Executive Analytics Engine

A production-ready data engineering and analytics pipeline that bypasses static file handling to stream live transactional metrics directly from a PostgreSQL Data Warehouse into Power BI via a high-performance FastAPI microservice.

## 🚀 Key Architectural Pillars
- **Relational Data Warehouse (SQL):** Built an optimized database tier with multi-table relational integrity constraint mappings.
- **Dynamic Wrangler Layer (Python/FastAPI):** Engineered an asynchronous API engine executing business logic, financial equations, and automated data curation loops.
- **Business Intelligence Front-End (Power BI):** Developed a dynamic dashboard pulling live stream JSON records into tabular modeling sheets for executive reporting.

## 🧠 Core Business Logic Implemented
- **Automated Financial Audits:** Vectorized data transformations tracking real-time Gross Revenue, Discounts, Net Revenue, and Profit Margins.
- **Leakage Protection Routing:** Implemented strict enterprise rules forcing active variables to zero out automatically whenever an item triggers a `Returned` flag.

## 🛠️ Tech Stack & Drivers
- **Database:** PostgreSQL (via `pg8000` pure-python driver execution)
- **Backend:** FastAPI & Uvicorn ASGI Server Server (Python 3.14 compatible)
- **Transformation Engine:** Pandas Core Matrices
- **Reporting BI:** Power BI Desktop Web Data Connectors
