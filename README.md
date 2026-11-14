# Monday Coffee: SQL Sales Analysis

A MySQL project analysing sales data for **Monday Coffee**, a coffee company selling products online in Indian cities. The goal is to recommend the **top 3 cities** for opening new coffee shops.

This is a project I made while learning SQL.

## Database

Database `monday_coffee` with four related tables:

| Table | Columns |
|---|---|
| `city` | city_id, city_name, population, estimated_rent, city_rank |
| `customers` | customer_id, customer_name, city_id → city |
| `products` | product_id, product_name, price |
| `sales` | sale_id, sale_date, product_id → products, quantity, customer_id → customers, total_amount, rating |

## Activities

1. **Database design**: create the four tables with primary and foreign keys
2. **Data quality and cleaning**: check every column for NULLs, look for duplicate customers, find sales where `total_amount ≠ price × quantity`, and fix them with an `UPDATE … JOIN`
3. **Data integration**: join all four tables into one sales report with customer, city and product details
4. **Analysis and aggregation** per city:
   - total sales, number of transactions, unique customers
   - average order value and average customer rating
   - product demand per city
   - monthly sales trend
5. **Decision making**: rank the cities to pick the top 3 for expansion

## Key results

**Top 3 cities for expansion**

| City | Total sales (₹) | Unique customers | Orders |
|---|---|---|---|
| **Pune** | 5,580,250 | 52 | 970 |
| Chennai | 4,039,500 | 42 | 692 |
| Bangalore | 3,917,200 | 39 | 675 |

These three cities also have the highest average customer ratings (about 4.5/5, compared with about 3.5 elsewhere).

**Recommendation:** Monday Coffee should expand into Pune, Chennai and Bangalore, with Pune as the priority, since it leads on sales, customers and orders. Rent and population should also be considered before choosing exact locations.

## Files

- `Activity.sql`: all SQL queries, organised by activity
- `results.txt`: the output of each query, plus the written recommendation

## SQL skills used

`CREATE TABLE` with primary and foreign keys · `JOIN` across multiple tables · `GROUP BY` / `HAVING` · `SUM`, `COUNT`, `COUNT(DISTINCT)`, `AVG` · `UPDATE … JOIN` for data cleaning · `DATE_FORMAT` for monthly trends · `ORDER BY … LIMIT` for ranking

## Run it

Written for **MySQL**. Run `Activity.sql` in MySQL Workbench or the `mysql` command line. You'll need to load the Monday Coffee dataset (city, customers, products, sales) into the tables after Activity 1 creates them.
