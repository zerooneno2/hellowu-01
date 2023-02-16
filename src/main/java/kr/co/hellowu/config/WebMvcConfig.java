package kr.co.hellowu.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;


@Configuration
public class WebMvcConfig implements WebMvcConfigurer{
	private static final String BASE_PATH = System.getProperty("os.name").toUpperCase().contains("WINDOW")? "file:///C:":"file:///";
	@Value("${upload.board.image.path}")
	private String uploadBoardImagePath;
	//web root가 아닌 외부 경로에 있는 리소스를 url로 불러올 수 있도록 설정
    //현재 localhost/summernoteImage/1234.jpg
    //로 접속하면 D:/work/image/1234.jpg 파일을 불러온다.
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/summernoteImage/**")
                .addResourceLocations(BASE_PATH+uploadBoardImagePath);
                

    }
    
    
}
