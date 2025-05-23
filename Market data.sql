-- Step 1: Match price on or before the order date
WITH historical_match AS (
  SELECT 
    o.orderId,
    o.orderDate,
    o.productId,
    o.item_Quantity,
    p.product_price,
    p.product_purchased_price,
    ROW_NUMBER() OVER (
      PARTITION BY o.orderId, o.productId
      ORDER BY p.product_date_price DESC
    ) AS rn
  FROM orders_table o
  LEFT JOIN products_table p
    ON o.productId = p.productId
   AND p.product_date_price <= o.orderDate
),

-- Step 2: Match price after the order date
future_match AS (
  SELECT 
    o.orderId,
    o.orderDate,
    o.productId,
    o.item_Quantity,
    p.product_price AS future_price,
    p.product_purchased_price AS future_purchase_price,
    ROW_NUMBER() OVER (
      PARTITION BY o.orderId, o.productId
      ORDER BY p.product_date_price ASC
    ) AS rn
  FROM orders_table o
  LEFT JOIN products_table p
    ON o.productId = p.productId
   AND p.product_date_price > o.orderDate
),

-- Step 3: One row per order/product for past price
h AS (
  SELECT * FROM historical_match WHERE rn = 1
),

-- Step 4: One row per order/product for future price
f AS (
  SELECT * FROM future_match WHERE rn = 1
)

-- Step 5: Join the two by orderId and productId
SELECT 
  COALESCE(h.orderId, f.orderId) AS orderId,
  COALESCE(h.orderDate, f.orderDate) AS orderDate,
  COALESCE(h.productId, f.productId) AS productId,
  COALESCE(h.item_Quantity, f.item_Quantity) AS item_Quantity,
  COALESCE(h.product_price, f.future_price) AS resolved_product_price,
  COALESCE(h.product_purchased_price, f.future_purchase_price) AS resolved_purchase_price
FROM h
LEFT JOIN f
  ON h.orderId = f.orderId AND h.productId = f.productId

UNION

SELECT 
  COALESCE(h.orderId, f.orderId) AS orderId,
  COALESCE(h.orderDate, f.orderDate) AS orderDate,
  COALESCE(h.productId, f.productId) AS productId,
  COALESCE(h.item_Quantity, f.item_Quantity) AS item_Quantity,
  COALESCE(h.product_price, f.future_price) AS resolved_product_price,
  COALESCE(h.product_purchased_price, f.future_purchase_price) AS resolved_purchase_price
FROM f
LEFT JOIN h
  ON h.orderId = f.orderId AND h.productId = f.productId
WHERE h.orderId IS NULL
