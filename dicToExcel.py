#!/usr/bin/python3
#-*- coding:utf-8 -*-
#这个工具用于输出系统数据库为客户数据字典文档
#
import pymysql
import openpyxl

initial_info = {
	'host':'120.78.88.79',
	'port':3306,
	'username':'root',
	'password':'zb2014',
	'database':'am',
	'charset' :'utf8',
	'savepath':'D:\\Desktop\\am.xlsx',
	'table_head':('字段名','数据类型','备注')
}
show_tables_sql='show tables'
desc_tables_sql="select COLUMN_NAME,DATA_TYPE, COLUMN_COMMENT from information_schema.columns where table_schema = '%s' and table_name = '%s'"

def get_connection():
	connection = pymysql.Connect(host=initial_info['host'],port=initial_info['port'],user=initial_info['username'],passwd=initial_info['password'],db=initial_info['database'],charset=initial_info['charset'])
	connection.autocommit(True)
	return connection
	
def write_excel(save_path,content): #content List<List<String>> content 仅仅一个sheet
	wb=openpyxl.Workbook()
	sheet=wb.active
	sheet.title='%s数据库' % initial_info['database']
	for i in range(0,len(content)):
		for j in range(0,len(content[i])):
			sheet.cell(row=i+1,column=j+1,value=str(content[i][j]))
	wb.save(save_path)

if __name__ == '__main__':
	connection = get_connection()
	cursor = connection.cursor()#获取游标
	cursor.execute(show_tables_sql)#查询数据库的表
	list = []
	for each in cursor.fetchall():
		tablename = each[0]
		desc_table = desc_tables_sql % (initial_info['database'],tablename)
		cursor.execute(desc_table)
		table_t = (str(tablename+"表"),'','')
		list.append(table_t)
		list.append(initial_info['table_head'])
		for desc_message in cursor.fetchall():
			list.append(desc_message)
		list.append(('','',''))
		
	try:
		write_excel(initial_info['savepath'],list)
	except Exception as e:
		print("Reason:",e)	

