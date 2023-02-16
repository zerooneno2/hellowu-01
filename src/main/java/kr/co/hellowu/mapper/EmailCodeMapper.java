package kr.co.hellowu.mapper;

import kr.co.hellowu.vo.EmailCodeVO;

public interface EmailCodeMapper {
	int insertEmailCode(EmailCodeVO emailCodeVO);
	int deleteEmailCode(EmailCodeVO emailCodeVO);
	EmailCodeVO selectEmailCode(EmailCodeVO emailCodeVO);
}
