package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.File;
import com.example.demo.model.Product;

@Mapper
public interface ProductMapper {
	// 제품 목록
	List<Product> selectProductList(HashMap<String, Object> map);
	
	// 카테고리 목록
	List<Product> selectCategoryList (HashMap<String, Object> map);
	
	// 제품상세정보
	Product selectProduct (HashMap<String, Object> map);
	
	// 제품삭제
	int deleteProduct(HashMap<String, Object> map);
	
	// 게시글 등록
	int insertProduct(HashMap<String, Object> map);
	
	// 파일업로드
	int insertProductFile(HashMap<String, Object> map);
	
	// 첨부파일 목록
	List<File> selectProductFile(HashMap<String, Object> map);
	
	
	
	
	
}
