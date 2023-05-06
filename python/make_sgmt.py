import os
from time import strptime
import sqlalchemy
from sqlalchemy import Engine
import argparse
import pandas as pd
from datetime import datetime as dt



#definindo local do projeto
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(BASE_DIR, 'data')
SQL_DIR = os.path.join(BASE_DIR, 'sql')

#parser de data para fazer a foto
parser = argparse.ArgumentParser()
parser.add_argument('--date_end', '-e', help='data de fim da estração', default='2018-06-01')
args = parser.parse_args()

date_end = args.date_and
ano = int(date_end.split("-")[0]) - 1
mes = int(date_end.split("-")[1]) 

date_init = f"{ano}-{mes}- 01"


# importa a query
with open(os.path.join(SQL_DIR, 'segmentos.sql')) as query_file:
    query = query_file.read()
    
    
query = query.format( date_init = date_init,
                     date_end = date_end )

    
#abrindo conexao com o banco de dados
str_connection = 'sqlite:///{path}'
str_connection = str_connection.format(path=os.path.join(DATA_DIR, 'olist.db'))
connection = sqlalchemy.create_engine(str_connection)

create_query = f'''
CREATE TABLE tb_seller_sgmt AS 
{query}
;'''

insert_query = f'''
DELETE FROM tb_seller_sgmt WHERE DT_SGMT = '{date_end}';
INSERT INTO AS tb_seller_sgmt  
{query}
;'''


try:
    connection.execute(create_query)
except: 
    for q in insert_query.split(";")[:-1]:
        connection.execute(q)

