package com.wsc.common.report;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;

import javax.inject.Provider;
import javax.sql.DataSource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

@Service
public class DataManagementService extends BaseService {

	@Autowired
	private CommonDao dao;

	@Autowired
	private MessageSource messageSource;

	@Autowired
	private Provider<SessionComponent> sessionProvider;

	@Override
	protected BaseDao getDao() {
		return this.dao;
	}

	@Override
	protected MessageSource getMessageSource() {
		return this.messageSource;
	}

	@Override
	protected SessionComponent getSessionComponent() {
		return sessionProvider.get();
	}

	public List searchAll(Object params) {
		return super.search(getNameSpace()+".searchAll", params);
	}

	String NameSpaceId = "DataManagement";

	@Autowired
	private DataSource dataSource;

	@Transactional
	public ParamsMap getFieldTitle(ParamsMap params) {

		ParamsMap result = new ParamsMap();
		Object selectObj = "";

        JSONObject ColumnName = new JSONObject();

		try {

			Connection conn = DataSourceUtils.getConnection(dataSource);

			System.out.println("conn :  " + conn);

			String sql = "SELECT * FROM SYS_USER WHERE USER_ID = '1'";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCnt = rsmd.getColumnCount(); //컬럼의 수
			for(int i=1 ; i<=columnCnt ; i++){
				ColumnName.put(i, rsmd.getColumnName(i));
			}
//			System.out.println(columnCnt);
//			if(rs.next()){
//			  for(int i=1 ; i<=columnCnt ; i++){
//				  ColumnName.put(i, rsmd.getColumnName(i));
//				  //ColumnData.put(i, rs.getString(rsmd.getColumnName(i)));
//			  }
//			}

			result.put("ColumnName", ColumnName);

		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}

		return result;
	}

	@Transactional
	public Object save(ParamsMap params) {
		Object result = "";

		try {

			Object obj = JSONValue.parseWithException(params.get("rows").toString());
			JSONArray array = (JSONArray)obj;
			JSONObject jobj = null;

			for(int i=0; i < array.size(); i++){
				jobj = (JSONObject)array.get(i);

				params.add("jobNo", jobj.get("jobNo"));
				params.add("jobType1", jobj.get("jobType1"));
				params.add("jobType2", jobj.get("jobType2"));
				params.add("jobDesc", jobj.get("jobDesc"));
				params.add("authType", jobj.get("authType"));
				params.add("authGroups", jobj.get("authGroups"));
				params.add("authUsers", jobj.get("authUsers"));
				params.add("authFunc", jobj.get("authFunc"));
				params.add("useYn", jobj.get("useYn"));
				params.add("remk", jobj.get("remk"));

				if(jobj.get("oper").equals("I")){
					dao.insert(NameSpaceId+"insert", params);
				}else if(jobj.get("oper").equals("U")){
					dao.insert(NameSpaceId+"update", params);
				}else{
					dao.delete(NameSpaceId+"delete", params);
				}
			}

		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}
		return result;
	}

	@Transactional
	public Object saveDetl(ParamsMap params) {
		Object result = "";

		try {

			Object obj = JSONValue.parseWithException(params.get("rows").toString());
			JSONArray array = (JSONArray)obj;
			JSONObject jobj = null;

			for(int i=0; i < array.size(); i++){
				jobj = (JSONObject)array.get(i);

				params.add("jobNo", jobj.get("jobNo"));
				params.add("parameterCode", jobj.get("parameterCode"));
				params.add("parameterName", jobj.get("parameterName"));
				params.add("parameterSeq", jobj.get("parameterSeq"));
				params.add("parameterType", jobj.get("parameterType"));
				params.add("parameterLength", jobj.get("parameterLength"));
				params.add("parameterDesc", jobj.get("parameterDesc"));
				params.add("parameterInitVal", jobj.get("parameterInitVal"));

				if(jobj.get("oper").equals("I")){
					dao.insert(NameSpaceId+"insertDetl", params);
				}else if(jobj.get("oper").equals("U")){
					dao.insert(NameSpaceId+"updateDetl", params);
				}else{
					dao.delete(NameSpaceId+"deleteDetl", params);
				}
			}

		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}
		return result;
	}

	@Transactional
	public Object saveSql(ParamsMap params) {
		Object result = "";

		try {
			dao.update("updateSql", params);
		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}
		return result;
	}

}
