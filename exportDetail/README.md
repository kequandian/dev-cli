## 数据库设计文档生成说明：

### 使用说明：

- 配置application.yml：

```java
spring:
  datasource:
    url: jdbc:mysql://sqlUrl:3306/dbName?autoReconnect=true&useSSL=false&useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&zeroDateTimeBehavior=convertToNull
    username: root
    password: zb2014@888
```

- 调用api：

```http
POST http://localhost:8080/dataSource/getDbDetail/{dbName}
```



