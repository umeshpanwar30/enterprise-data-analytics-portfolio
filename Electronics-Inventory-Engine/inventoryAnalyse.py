from fastapi import FastAPI, HTTPException
import pandas as pd
import numpy as np
from sqlalchemy import create_engine

app = FastAPI(title="B2B Electronics Logistics & Warehouse Inventory Engine")

# Relational Data Warehouse Pipeline Connection
db_url = "postgresql+pg8000://postgres:1nd14ltd@localhost:5432/Data sAnalytics"

try:
    engine = create_engine(db_url)
    print("[SUCCESS] SQLAlchemy Engine successfully connected to Warehouse Storage!")
except Exception as e:
    print(f"[ERROR] Engine Binding Interrupted: {e}")

@app.get("/api/v1/inventory/warehouse-stream")
def get_warehouse_operations_analytics():
    try:

        #below the steps to extract the data from the database first.

        # Step A: Ingesting Raw Data from Electronics Inventory
        inv_query = "SELECT * FROM electronics_inventory;"
        df_inv = pd.read_sql(inv_query, engine)
        
        # Step B: Ingesting Raw Data from Supply Orders
        supply_query = "SELECT * FROM supply_orders;"
        df_supply = pd.read_sql(supply_query, engine)
        
        if df_inv.empty:
            raise HTTPException(status_code=404, detail="Warehouse core tracking tables are completely empty.")

        # --------------------------------------------------------------------------
        # PANDAS-HEAVY DATA WRANGLING & OPERATIONS ANALYTICS LOGIC (The Brains)
        # --------------------------------------------------------------------------
        
        # 1. Financial Valuation Loops: Calculate Capital Tied-Up in Stock
        df_inv['total_inventory_cost_gbp'] = df_inv['current_stock'] * df_inv['cost_price']
        df_inv['potential_gross_revenue_gbp'] = df_inv['current_stock'] * df_inv['retail_price']
        
        # 2. Automated Safety Alarms: Check if current stock has dropped below limits
        # If Current Stock <= Safety Stock -> Trigger 'CRITICAL RE-ORDER', else 'HEALTHY'
        df_inv['stock_health_status'] = np.where(
            df_inv['current_stock'] <= df_inv['safety_stock_level'], 
            "CRITICAL RE-ORDER", 
            "HEALTHY"
        )
        
        # 3. Supply Chain Lead Time Aggregations: Calculate Supplier Fulfillment Speeds
        if not df_supply.empty:
            # Parse dates to calculate numerical differences
            df_supply['order_date'] = pd.to_datetime(df_supply['order_date'])
            df_supply['delivery_date'] = pd.to_datetime(df_supply['delivery_date'])
            
            # Calculate Lead Time (Days elapsed to fulfill delivery)
            df_supply['supplier_lead_time_days'] = (df_supply['delivery_date'] - df_supply['order_date']).dt.days
            
            # Group by item_id to find average supply delays and total pending transits
            df_supply_summary = df_supply.groupby('item_id').agg(
                avg_supplier_lead_time_days=('supplier_lead_time_days', 'mean'),
                total_units_on_the_way=('quantity_ordered', lambda x: df_supply.loc[x.index, 'quantity_ordered'].where(df_supply.loc[x.index, 'delivery_date'].isna()).sum())
            ).reset_index()
            
            # Merge calculations cleanly back into the main inventory dataset
            df_master = pd.merge(df_inv, df_supply_summary, on='item_id', how='left')
        else:
            df_master = df_inv.copy()
            df_master['avg_supplier_lead_time_days'] = np.nan
            df_master['total_units_on_the_way'] = 0

        # Fill any empty/null tracking metrics cleanly to prevent front-end errors
        df_master['avg_supplier_lead_time_days'] = df_master['avg_supplier_lead_time_days'].fillna(-1)
        df_master['total_units_on_the_way'] = df_master['total_units_on_the_way'].fillna(0).astype(int)

        # Convert the dynamic calculated frame directly into the API JSON string payload
        return df_master.to_dict(orient="records")
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Logistics Engine Halted: {str(e)}")
