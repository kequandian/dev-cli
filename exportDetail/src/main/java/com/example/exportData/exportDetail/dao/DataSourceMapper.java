package com.example.exportData.exportDetail.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface DataSourceMapper {

    @Select("SHOW FULL FIELDS FROM ${dbName}.${tableName}")
    List<Map<String, Object>> getDataDetail(@Param("dbName") String dbName,@Param("tableName") String tableName);

    @Select("select table_name,table_comment from information_schema.tables where table_schema = #{dbName}")
    List<Map<String, Object>> getAllDataSourceName(@Param("dbName") String dbName);

}
