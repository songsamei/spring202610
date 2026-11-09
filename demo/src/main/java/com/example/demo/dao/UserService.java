package com.example.demo.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.demo.common.Message;
import com.example.demo.mapper.UserMapper;
import com.example.demo.model.User;

import jakarta.servlet.http.HttpSession;

@Service
public class UserService {
	@Autowired
	UserMapper userMapper;
	
	// 3 비밀번호 해시 객체 생성
	@Autowired
	PasswordEncoder passwordEncoder;
	
	@Autowired
	HttpSession session;

	public HashMap<String, Object> login(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		
		try {
			User user = userMapper.selectUser(map);
			if(user != null) {
				// 아이디는 검색 성공
				// 비밀번호 해시 값 비교
				boolean login =  passwordEncoder.matches((String) map.get("pwd"), user.getPwd());
				if(login) {
					session.setAttribute("sessionId", user.getUserId());
					session.setAttribute("sessionName", user.getUserName());
					session.setAttribute("sessionRole", user.getRole());
					
					if(user.getRole().equals("A")) {
						resultMap.put("url", "/product/list.do");
					} else {
						resultMap.put("url", "/board/list.do");
					}
					
//					session.setMaxInactiveInterval(0); 세선 유지 시간
//					session.invalidate(); 세션 모든 정보 삭제
					
					
					resultMap.put("loginFlg", true);
					resultMap.put("message", user.getUserName() + "님 환영합니다.");
				}else {
					resultMap.put("loginFlg", false);
					resultMap.put("message", Message.LOGIN_FAIL);
				}
				
			}else {
				// 아이디가 없는경우
				
			}
			resultMap.put("result", "success");
			
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.err.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> addUser(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap();
		
		try {
			String hashPwd = passwordEncoder.encode((String) map.get("pwd"));
			System.out.println("해시 전 패스워드 => " + map.get("pwd"));
			System.out.println("해시 후 패스워드 => " + hashPwd);
			
			map.put("hashPwd", hashPwd);
			int result = userMapper.insertUser(map);
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.DB_ERR);
			System.err.println(e.getMessage());
		}
		return resultMap;
	}
	

	
}
