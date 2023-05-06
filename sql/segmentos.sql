-- database: c:\Users\Karen\Desktop\projeto data\data\olist.db

-- Use the ▷ button in the top right corner to run the entire file.

--O comando abaixo me mostra quantas pessoas distintas eu tenho entre a data de 2017 a 2018 mes 6
--SELECT COUNT(DISTINCT T2.seller_id), 
--        MAX(T1.order_approved_at),
--        MIN(T1.order_approved_at)


--quem mais vendeu receita, quantidade de pedidos, quantidade de items,
--quantidade de produtos distintos, quantidade em dias da ultima venda

--DROP TABLE IF EXISTS tb_seller_sgmt;
--CREATE TABLE tb_seller_sgmt AS

        SELECT T1.*,
                CASE WHEN percentual_receita <= 0.5 AND percentual_freq <= 0.5 THEN 'BAIXO V. BAIXO F.'
                        WHEN percentual_receita > 0.5 AND percentual_freq <= 0.5 THEN 'ALTO VALOR'
                        WHEN percentual_receita <= 0.5 AND percentual_freq > 0.5 THEN 'ALTA FREQUENCIA'
                        WHEN percentual_receita < 0.9 OR percentual_freq < 0.9 THEN 'PRODUTIVO'
                        ELSE 'SUPER PRODUTIVO'
                END AS SEGMENTO_VALOR_FREQUENCIA,

                CASE WHEN qnt_dias_base <= 60 THEN 'INICIO'
                        WHEN qnt_dias_ultima_venda <= 300 THEN 'RETENCAO'
                        ELSE 'ATIVO'
                END AS SEGMENTO_VIDA,

                '{date_end}' AS DT_SGMT


        FROM(

                SELECT T1.*,
                        percent_rank() over (order by receita_total asc) as percentual_receita,
                        percent_rank() over (order by qnt_pedidos asc) as percentual_freq

                FROM(

                        SELECT  T2.seller_id, 
                                SUM(T2.price) AS receita_total,
                                COUNT(DISTINCT T1.order_id) AS qnt_pedidos,
                                COUNT(T2.product_id) AS qnt_produtos,   
                                COUNT(DISTINCT T2.product_id) AS qnt_produtos_distintos,
                                MIN(CAST(julianday('{date_end}') - julianday(T1.order_approved_at) AS INT)) AS qnt_dias_ultima_venda,
                                MAX(CAST(julianday('{date_end}') - julianday(data_inicio) AS INT )) AS qnt_dias_base
        

                        FROM tb_orders AS T1

                        LEFT JOIN tb_order_items AS T2
                        ON T1.order_id = T2.order_id

                        LEFT JOIN (
                                SELECT T2.seller_id, 
                                        MIN( DATE( T1.order_approved_at)) AS data_inicio
                                FROM tb_orders AS T1
                                LEFT JOIN tb_order_items AS T2
                                ON T1.order_id = T2.order_id
                                GROUP BY T2.seller_id
                        ) AS T3
                        ON T2.seller_id = T3.seller_id

                        WHERE T1.order_approved_at BETWEEN '{date_init}' AND '{date_end}'

                        GROUP BY T2.seller_id
                ) AS T1
        ) AS T1
        WHERE seller_id IS NOT NULL







