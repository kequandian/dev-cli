package com.example.exportData.exportDetail.service;

import com.lowagie.text.DocumentException;

import java.io.FileNotFoundException;
import java.util.List;
import java.util.Map;

public interface DataSourceDetailService {

    List<Map<String, Object>> getDataSourceDetail(String tableName , String dbName);

    List<Map<String, Object>> getAllDataSourceName(String dbName);

    void toWord(List<Map<String, Object>> listAll , String dbName) throws FileNotFoundException, DocumentException;
}
