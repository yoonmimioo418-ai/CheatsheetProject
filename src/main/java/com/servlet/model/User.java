package com.servlet.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class User {
	
	private int id;
	private String username;
	private String email;
	private String password;
	private String role;
	private String bio;
	private String status;
	private String ban_reason;

}
