package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Professor;



@Mapper
public interface ProfessorMapper {
	List<Professor> selectProfessorList();
	// 삭제
	int deleteProfessor(HashMap<String, Object> map);
	
	// 교수 추가
	int insertProfessor(HashMap<String, Object> map);
	
	// 중복 체크 (교수번호로)
	Professor selectProfessor(HashMap<String, Object> map);
	
	// 학과 리스트
	List<Professor> selectDeptList(HashMap<String, Object> map);
}