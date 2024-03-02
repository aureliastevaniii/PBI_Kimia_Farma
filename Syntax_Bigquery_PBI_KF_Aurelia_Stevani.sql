-- Membuat Table Analisis 
-- Nama Tabel transaction_analysis
-- table kf_final_transaction akan diberi alias dengan t (transaksi)
-- table kf_kantor_cabang akan diberi alias dengan b (branch)
-- table kf_product akan diberi alias dengan p (product)

CREATE TABLE kimia_farma.transaction_analysis AS
SELECT
  t.transaction_id,
  t.date,
  b.branch_id,
  b.branch_name,
  b.kota,
  b.provinsi,
  b.rating AS branch_rating,
  t.customer_name,
  p.product_id,
  p.product_name,
  p.price AS actual_price,
  t.discount_percentage,
   --menghitung laba yang didapatkan berdasarkan harga produk 
  CASE
    -- Ketika harga produk kurang dari atau sama dengan Rp 50.000, laba adalah 10% dari harga produk
    WHEN p.price <= 50000 THEN p.price * 0.1
	 -- Ketika harga produk lebih dari Rp 50.000 dan kurang dari atau sama dengan Rp 100.000, laba adalah 15% dari harga produk
    WHEN p.price > 50000 AND p.price <= 100000 THEN p.price * 0.15
	-- Ketika harga produk lebih dari Rp 100.000 dan kurang dari atau sama dengan Rp 300.000, laba adalah 20% dari harga produk
    WHEN p.price > 100000 AND p.price <= 300000 THEN p.price * 0.2
	-- Ketika harga produk lebih dari Rp 300.000 dan kurang dari atau sama dengan Rp 500.000, laba adalah 25% dari harga produk
    WHEN p.price > 300000 AND p.price <= 500000 THEN p.price * 0.25
	 -- Untuk harga produk lebih dari Rp 500.000, laba adalah 30% dari harga produk
    ELSE p.price * 0.3
  END AS persentase_gross_laba,
  
  -- menghitung nett sales atau harga setelah diskon 
  p.price - (p.price * (t.discount_percentage / 100)) AS nett_sales,
  
  -- menghitung nett profit atau keuntungan yang didapatkan 
  (p.price - (p.price * (t.discount_percentage / 100))) * CASE
    WHEN p.price <= 50000 THEN 0.1
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.2
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    ELSE 0.3
  END AS nett_profit,
  t.rating AS transaction_rating
  
FROM
  `kimia_farma.kf_final_transaction` AS t
LEFT JOIN
  `kimia_farma.kf_kantor_cabang` AS b
ON
  t.branch_id = b.branch_id
  
LEFT JOIN
  `kimia_farma.kf_product` AS p
ON
  t.product_id = p.product_id;
