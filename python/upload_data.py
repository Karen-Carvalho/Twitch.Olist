import os
import pandas as pd
import sqlalchemy

#link para extração dos dados 'https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce'

#criando conexao com o banco de dados
str_connection = 'sqlite:///{path}'


#definindo local do projeto
BASE_DIR = os.path.dirnam(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DATA_DIR = os.path.join(BASE_DIR, 'data')

# ler os arquivos
#opção 1
'''
files_names = os.listdir(DATA_DIR)
correct_files = []
for i in files_names:
    if i.endswith(".csv"):
        correct_files.append(i)
'''
#opção 2(mais bonito)
files_names = [i for i in os.listdir(DATA_DIR) if i.endswith('.csv')]

#abrindo conexao com o banco de dados
str_connection = str_connection.format(path=os.path.join(DATA_DIR, 'olist.db'))
connection = sqlalchemy.create_engine(str_connection)

#para cada arquivo é realizado uma incersão no banco de dados
for i in files_names:
    print(i)
    df_tmp = pd.read_csv(os.path.join(DATA_DIR, i))
    table_name = "tb_" + i.strip(".csv").replace("olist_", "").replace("_dataset", "")
    df_tmp.to_sql(table_name, 
                  connection,
                  if_exists='replace',
                  index=False)


# Olist é um ecommerce que vende dentro de outros ecommerce, então os clientes da Olist não são consumidores finais
#por isso precisamos saber se essa base é saudavel, saber se posso melhorar o relacionamento com esse cliente,
# se posso dar desconto para ele...
    