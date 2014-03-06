package com.weaveus.lethee.mapp.sqlite;

import java.util.Date;

public class Todo {
	
	public Integer id;
	public String content;
	public Date createDate;
	public Date dueDate;
	
	public String toString() {
		return "Todo Item: " + id;
	}

}
