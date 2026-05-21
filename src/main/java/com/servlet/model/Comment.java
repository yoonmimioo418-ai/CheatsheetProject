package com.servlet.model;



import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Comment {
	
	private int id;
	private int cheatsheetId;
	private int userId;
	private String commentText;
	private String username;
	private String createdAt;

}
