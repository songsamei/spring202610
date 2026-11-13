package com.example.demo.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.User;

@Mapper
public interface UserMapper {
	// 사용자 조회
	 User selectUser(HashMap<String, Object> map);
	 
	 // 회원가입
	 int insertUser(HashMap<String, Object> map);
	 
	 // 비밀번호변경
	 int updateUser(HashMap<String, Object> map);
	 
	 
	 //사용자조회
	 int selectAuth(HashMap<String, Object> map);
	 

}
