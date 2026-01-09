package com.wsc.common.model;

import com.wsc.framework.base.BaseConstants;
import com.wsc.framework.base.BaseModel;
import com.wsc.framework.utils.BaseUtils;

public class Group extends BaseModel {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2948250969936467356L;
	
	private String groupId;    // 사용자그룹ID
	private String groupName;  // 사용자그룹명
	
    public void setDefault() {
    	setGroupId   (BaseConstants.DEFAULT_GROUP_ID);
    	setGroupName (BaseConstants.DEFAULT_GROUP_NAME);
    }
    
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	public String getGroupName() {
		return groupName;
	}
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	//관리자인지 확인
	public boolean isAdmin() {
		return BaseUtils.exist(BaseConstants.ADMIN_GROUPS, groupId);
	}

}
