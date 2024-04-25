package com.example.exportData.exportDetail.controler;

import com.example.exportData.exportDetail.service.DataSourceDetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/dataSource")
public class DataSourceDetailControler {

    @Autowired
    private DataSourceDetailService dataSourceDetailService;

//    @RequestMapping("/getDbDetail")
    @PostMapping("/getDbDetail/{dbName}")
    public String getDbDetail(@PathVariable String dbName){
        try {
            List<Map<String,Object>> list = this.dataSourceDetailService.getAllDataSourceName(dbName);
            dataSourceDetailService.toWord(list , dbName);
        } catch (Exception e) {
            e.printStackTrace();
            return "生成数据库表设计文档失败";
        }
        return "生成数据库表设计文档成功";
    }
}
