package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Emp;


@Mapper
public interface EmpMapper {
	List<Emp> selectEmpList(HashMap<String, Object> map);
	
	int deleteEmp(HashMap<String, Object> map);
}
