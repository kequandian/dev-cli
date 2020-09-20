#!/usr/bin/python3
import pymysql
import yaml
import sys,getopt
initial_info = {
    'host': 'localhost',
    'port': 3306,
    'username': 'root',
    'password': 'root',
    'database': 'test',
    'table': 'user',
    'charset': 'utf8',
    'savepath': 'D:\\Desktop\\db.yml'
}
show_tables_sql = 'show tables'
desc_tables_sql = "select COLUMN_NAME,COLUMN_KEY,COLUMN_TYPE,COLUMN_DEFAULT,IS_NULLABLE,COLUMN_COMMENT from information_schema.columns where table_schema = '%s' and table_name = '%s'"
fields = {}
pages = {'fields': fields}
yml = {'fields': fields}

def usage(argv):
    try:
        opts, args = getopt.getopt(argv,"hd:t:s:")
    except getopt.GetoptError:
        print('dbToCrudless.py -d <database> -t <table> -s <savepath>')
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h","--help"):
            print('dbToCrudless.py -d <database> -t <table> -s <savepath>')
            sys.exit()
        elif opt in ("-d", "--database"):
            initial_info['database'] = arg
        elif opt in ("-t", "--table"):
            initial_info['table'] = arg
        elif opt in ("-s", "--savepath"):
            initial_info['savepath'] = arg
    collect_all_yaml() if (len(sys.argv) == 1) else collect_yaml(initial_info['table'])

def get_connection():
    connection = pymysql.Connect(host=initial_info['host'], port=initial_info['port'],
                                 user=initial_info['username'], passwd=initial_info['password'],
                                 db=initial_info['database'], charset=initial_info['charset'])
    connection.autocommit(True)
    return connection

def collect_yaml(tablename):
    connection = get_connection()
    cursor = connection.cursor()
    desc_table = desc_tables_sql % (initial_info['database'], tablename)
    fields[tablename] = []
    cursor.execute(desc_table)
    for r in cursor.fetchall():
        sql={'sql': {
            'type': r[2],
            'unique': True if (r[1] == 'PRI') else False,
            'notnull': True if (r[4] == 'NO') else False,
            'comment': r[5]
        }}
        if not r[3] is None:
            sql['sql']['default'] = r[3]
        field={r[0]: sql}
        fields[tablename].append(field)
    
def collect_all_yaml():
    connection = get_connection()
    cursor = connection.cursor()  # 获取游标
    cursor.execute(show_tables_sql)  # 查询数据库的表
    for each in cursor.fetchall():
        collect_yaml(each[0])

def write_yaml():
    try:
        f = open(initial_info['savepath'],'w',encoding='utf-8')  #  传入文件路径
        yaml.dump(yml,f,allow_unicode=True)
        f.close()
    except Exception as e:
        print("Reason:", e)

if __name__ == '__main__':
    usage(sys.argv[1:])
    if ('-s' or '--savepath') in sys.argv:
        write_yaml()
    else:
        print(yaml.dump(yml,allow_unicode=True))