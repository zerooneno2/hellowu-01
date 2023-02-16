package kr.co.hellowu;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

@MapperScan("kr.co.hellowu.mapper") 
// 해당 패키지 아래에 있는 파일들을 mapper로 인식하여 @Mapper 어노테이션을 붙입니다
@SpringBootApplication
@EnableScheduling
@EnableAspectJAutoProxy
@EnableAsync
public class HellowApplication {

	public static void main(String[] args) {
		SpringApplication.run(HellowApplication.class, args);
	}
} 
