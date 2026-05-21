package com.servlet.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Cheatsheet {
	private int id;
    private String title;
    private String content;
    private String categoryName;
    private Integer categoryId;
    private Integer userId;
    private String username;
    private int favCount;
    
}
