from fastapi import FastAPI, HTTPException
import pandas as pd
import numpy as np
from sqlalchemy import create_engine

app = FastAPI(title="Retail Data Pipeline")

db_url = "postgresql+pg8000://postgres:1nd14ltd@localhost:5432/StudentZone"

try:
    engine = create_engine(db_url)
    print("[SUCCESS] SQLAlchemy Database Engine Initialized Successfully!")
except Exception as e:
    print(f"[ERROR] Engine Initialization Failed: {e}")

@app.get("/data-analyst-stream")
def get_cleaned_sales_data():
    try:
        query = """
            SELECT o.order_id, u.full_name, u.tier, o.order_date, o.order_status,
                   p.product_name, p.category, p.cost_price, p.retail_price,
                   oi.quantity, oi.discount_applied
            FROM order_items oi
            JOIN products p ON oi.product_id = p.product_id
            JOIN orders o ON oi.order_id = o.order_id
            JOIN users u ON o.user_id = u.user_id;
        """
        
        # Ingesting raw database records directly into Pandas DataFrame
        df = pd.read_sql(query, engine)
        
        if df.empty:
            raise HTTPException(status_code=404, detail="Database tables are empty. Insert data via pgAdmin first.")

        # 2. THE REAL ANALYST WORK: DATA WRANGLING & CLEANING VIA PANDAS
        df['order_date'] = pd.to_datetime(df['order_date']).dt.strftime('%Y-%m-%d')
        df['gross_revenue'] = df['quantity'] * df['retail_price']
        df['discount_amount'] = df['gross_revenue'] * (df['discount_applied'] / 100)
        df['net_revenue'] = df['gross_revenue'] - df['discount_amount']
        df['total_cost'] = df['quantity'] * df['cost_price']
        df['net_revenue'] = np.where(df['order_status'] == 'Returned', 0.00, df['net_revenue'])
        df['net_profit'] = np.where(df['order_status'] == 'Returned', 0.00, df['net_revenue'] - df['total_cost'])
        
        return df.to_dict(orient="records")
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Data Pipeline Interrupted: {str(e)}")
