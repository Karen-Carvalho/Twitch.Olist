-- database: c:\Users\Karen\Desktop\projeto data\data\olist.db

-- Use the ▷ button in the top right corner to run the entire file.

SELECT DT_SGMT, COUNT(DISTINCT seller_id)
FROM tb_seller_sgmt
GROUP BY DT_SGMT