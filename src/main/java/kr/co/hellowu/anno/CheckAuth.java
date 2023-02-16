package kr.co.hellowu.anno;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD) // target => 어디에 붙는 어노테이션인지 정의. 메소드 이외에는 에러 발생
@Retention(RetentionPolicy.RUNTIME) // 어느 상황에서 유지가 되는 어노테이션인지 정의
public @interface CheckAuth {

}
