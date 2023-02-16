package kr.co.hellowu.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class ProfileImageConfig implements WebMvcConfigurer{
	private static final String BASE_PATH = System.getProperty("os.name").toUpperCase().contains("WINDOW")? "file:///C:":"file:///"; // file:/ => 하드디스크로부터 시작
	
	/*
	 * xml에서 어떤 폴더의 경로로 접근 하는 상황 등 경우에 따라서는 단순히 String으로 Path를 지정하는게 아닌,
	 * 
	 * file 프로토컬로 경로를 지정해줘야 되는 경우가 있는데,
	 * 
	 * 기본양식은 "file:///usr/local/tomcat8/myapp/application.properties" 의 꼴로 참조하게 된다.
	 * 
	 * ///로 접근하면 절대경로를 표현하기 위해 최상위 루트부터 시작하게된다.
	 * 
	 * 이 때, 현재 경로를 참조하기 위해서는 "file:./application.properties" 으로 접근하면 된다.
	 */
	@Value("${upload.user.image.path}")
	private String uploadUserImagePath;

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/images/user-images/**") // url 매핑
				.addResourceLocations(BASE_PATH+uploadUserImagePath); // 실제 저장 주소
	}
	
}
