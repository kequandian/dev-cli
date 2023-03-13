#!/usr/bin/python3
# -*- coding:utf-8 -*-
# 这个工具用于输出系统数据库为客户数据字典文档
#
import pymysql
import openpyxl
import sys
import codecs
import os
sys.stdout = codecs.getwriter("utf-8")(sys.stdout.detach())
# initial_info = {
#     'host': '192.168.3.239',
#     'port': 3306,
#     'username': 'root',
#     'password': 'root',
#     'database': 'alliance',
#     'charset': 'utf8',
#     'savepath': '/var/tmp/',
# }
initial_info = {
    'host': os.environ['HOST'],
    'port': os.environ['PORT'],
    'username': os.environ['USERNAME'],
    'password': os.environ['PASSWORD'],
    'database': os.environ['DATABASE'],
    'charset': 'utf8',
    'savepath': '/var/tmp/'
}

table_head = ('字段名', '数据类型', '备注')
show_tables_sql = 'show tables'
desc_tables_sql = "select COLUMN_NAME,DATA_TYPE,ifnull(ifnull(CHARACTER_MAXIMUM_LENGTH,NUMERIC_PRECISION),''), COLUMN_COMMENT from information_schema.columns where table_schema = '%s' and table_name = '%s'"
ignore_field = ['text','bigint']

def get_connection():
    connection = pymysql.Connect(host=initial_info['host'], port=int(initial_info['port']),
                                 user=initial_info['username'], passwd=initial_info['password'],
                                 db=initial_info['database'], charset=initial_info['charset'])
    connection.autocommit(True)
    return connection


def write_excel(save_path, content):  # content List<List<String>> content 仅仅一个sheet
    wb = openpyxl.Workbook()
    sheet = wb.active
    sheet.title = '%s数据库' % initial_info['database']
    for i in range(0, len(content)):
        for j in range(0, len(content[i])):
            sheet.cell(row=i + 1, column=j + 1, value=str(content[i][j]))
    wb.save(save_path)


if __name__ == '__main__':
    connection = get_connection()
    cursor = connection.cursor()  # 获取游标
    cursor.execute(show_tables_sql)  # 查询数据库的表
    list = []
    for each in cursor.fetchall():
        tablename = each[0]
        desc_table = desc_tables_sql % (initial_info['database'], tablename)
        cursor.execute(desc_table)
        table_t = (str(tablename + "表"), '', '')
        list.append(table_t)
        list.append(table_head)
        for r in cursor.fetchall():
            result = (r[0],str(r[1] + ('(' + r[2] + ')' if (r[1] not in ignore_field and r[2] != '') else '')),r[3]);
            list.append(result)
        list.append(('', '', ''))

    try:
        write_excel( initial_info['savepath'] + initial_info['database'] + '.xls', list)
    except Exception as e:
        print("Reason:", e)
