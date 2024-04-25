package com.example.exportData.exportDetail;

import com.example.exportData.exportDetail.controler.DataSourceDetailControler;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import javax.annotation.Resource;

@RunWith(SpringRunner.class)
@SpringBootTest
@Ignore
public class exportApplicationTests {

	@Resource
	DataSourceDetailControler dataSourceDetailControler;

	@Test
	public void contextLoads() {
		dataSourceDetailControler.getDbDetail("nft_prod");
	}

}
