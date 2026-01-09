package com.wsc.common.report;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;

import javax.inject.Provider;
import javax.sql.DataSource;

import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.baroservice.ws.TaxInvoiceTradeLineItem;
import com.wsc.common.dao.CommonDao;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseDao;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.NamedParameterStatement;

@Service
public class DataSearchService extends BaseService {

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

	String NameSpaceId = "DataSearch";

	@Autowired
	private DataSource dataSource;

	@Transactional
	public ParamsMap getFieldTitle(ParamsMap params) {

		ParamsMap result = new ParamsMap();
		Object selectSQL = "";

        JSONObject ColumnData = new JSONObject();

		try {

			// connection 셋팅
			Connection conn = DataSourceUtils.getConnection(dataSource);

			// 선택된 쿼리를 조회
			selectSQL = dao.select("getSqlData", params);

			String sql = (String) selectSQL;

			sql = new String(sql.getBytes("iso-8859-1"), "utf-8");

			NamedParameterStatement p = new NamedParameterStatement(conn, sql);

			// 선택된 쿼리의 파라미터를 조회
			Object selectParam = dao.search("getSqlParameter", params);

			ObjectMapper mapper = new ObjectMapper();
	        try {
	        	String jsonInString = mapper.writeValueAsString(selectParam);
			    String jsonStr ="{\"data\":"+jsonInString+"}";
			    try {
			    	JSONParser jsonParser = new JSONParser();
			        JSONObject jsonObj = (JSONObject) jsonParser.parse(jsonStr);
			        JSONArray parameterArray = (JSONArray) jsonObj.get("data");

					for(int ii=0 ; ii<parameterArray.size() ; ii++){
			            JSONObject tempObj = (JSONObject) parameterArray.get(ii);
			            System.out.println("parameterCode : " + tempObj.get("parameterCode").toString());
			            p.setString(tempObj.get("parameterCode").toString(), "dummy");
					}

		        } catch (ParseException e) {
		            // TODO Auto-generated catch block
		            e.printStackTrace();
		        }

			} catch (IOException e) {
				e.printStackTrace();
			}

			ResultSet rs = p.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCnt = rsmd.getColumnCount(); //컬럼의 수
			for(int i=1 ; i<=columnCnt ; i++){
				JSONObject  jo  = new JSONObject();
				jo.put("id", rsmd.getColumnName(i));
				jo.put("name", rsmd.getColumnLabel(i));
				ColumnData.put(i, jo);
			}

			result.put("ColumnCnt", columnCnt);
			result.put("ColumnData", ColumnData);
			result.put("result", selectParam);

		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}

		return result;
	}

	@Transactional
	public ParamsMap dataSearch(ParamsMap params) {

		ParamsMap result = new ParamsMap();
		Object selectSQL = "";

        JSONObject ColumnName = new JSONObject();

		try {

			// connection 셋팅
			Connection conn = DataSourceUtils.getConnection(dataSource);

			// 선택된 쿼리를 조회
			selectSQL = dao.select("getSqlData", params);

			String sql = (String) selectSQL;

			sql = new String(sql.getBytes("iso-8859-1"), "utf-8");

			NamedParameterStatement p = new NamedParameterStatement(conn, sql);

			// 선택된 쿼리의 파라미터를 조회
			Object selectParam = dao.search("getSqlParameter", params);

			System.out.println("selectSQL : " + sql);

			ObjectMapper mapper = new ObjectMapper();
	        try {
	        	String jsonInString = mapper.writeValueAsString(selectParam);
			    String jsonStr ="{\"data\":"+jsonInString+"}";
			    try {
			    	JSONParser jsonParser = new JSONParser();
			        JSONObject jsonObj = (JSONObject) jsonParser.parse(jsonStr);
			        JSONArray parameterArray = (JSONArray) jsonObj.get("data");

					for(int ii=0 ; ii<parameterArray.size() ; ii++){
			            JSONObject tempObj = (JSONObject) parameterArray.get(ii);
			            System.out.println("parameterCode : " + tempObj.get("parameterCode").toString() + "   :   " + params.get(tempObj.get("parameterCode").toString()).toString());
			            p.setString(tempObj.get("parameterCode").toString(), params.get(tempObj.get("parameterCode").toString()).toString());
					}

		        } catch (ParseException e) {
		            // TODO Auto-generated catch block
		            e.printStackTrace();
		        }

			} catch (IOException e) {
				e.printStackTrace();
			}

			//PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rs = p.executeQuery();

			JSONArray json = new JSONArray();

			while(rs.next())
            {
                JSONObject  jo  = new JSONObject();
                ResultSetMetaData rmd = rs.getMetaData();

                for ( int i=1; i<=rmd.getColumnCount(); i++ )
                {

                	String word = rmd.getColumnLabel(i);
    				System.out.println("라벨 : " + rmd.getColumnLabel(i));

    				System.out.println("rmd : " + rmd.getColumnName(i) + " rs : " + rs.getString(rmd.getColumnLabel(i)));
                    jo.put(rmd.getColumnName(i), rs.getString(rmd.getColumnLabel(i)));

                }

                json.add(jo);

            }

			int page = Integer.parseInt((String) params.get("rows"));
			int count = json.size();
			int total = json.size();
			int pages = (count / page);

			result.put("result", json);
			result.put("page", 1);
			result.put("count", count);
			result.put("total", total);
			result.put("pages", pages);

		} catch (Exception e) {
			// TODO: handle exception
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			e.printStackTrace();
		}

		return result;

	}


}
