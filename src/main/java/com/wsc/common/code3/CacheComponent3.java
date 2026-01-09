package com.wsc.common.code3;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.inject.Provider;

import org.apache.commons.collections.map.LinkedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;

import com.wsc.common.Consts;
import com.wsc.common.model.Code;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseComponent;
import com.wsc.framework.exception.ServiceException;
import com.wsc.framework.model.ParamsMap;

@Component
@SuppressWarnings("unchecked")
public class CacheComponent3 extends BaseComponent {
	
	public static final String ROOT       = Consts.ROOT_CODE;
	public static final String SYS_ID     = "sysId";
	public static final String CODE_CD    = "codeCd";
	public static final String CODE_GROUP = "codeGrup";
	
	@Autowired
	private Code3Service codeService;
	
	@Autowired
	private MessageSource messageSource;
	
	@Autowired
	private Provider<SessionComponent> sessionProvider;
	
	@Override
	protected MessageSource getMessageSource() {
		return this.messageSource;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}
	
	private LinkedMap _getCodeSet(ParamsMap params) {
		Map<String, LinkedMap> m = codeService.searchCodes(params.getString("sysId"));
		return m.get(params.get(CODE_GROUP));
	}
	
	/**
	 * @param params.sysId    필수조건 (시스템 아이디)
	 *        params.codeGrup 필수조건 (코드 그룹)
	 */
	public List<Code> getCodeList(ParamsMap params) {
		
		if (params == null)
			throw new ServiceException( getMessage("error.code.params") );
		if (params.containsKey(SYS_ID) == false)
			throw new ServiceException( getMessage("error.code.params.systemId") );
		if (params.containsKey(CODE_GROUP) == false)
			throw new ServiceException( getMessage("error.code.params.codeGrup") );
		
		LinkedMap map = _getCodeSet(params);
		
		if (map == null)
			return null;
		
		List<Code> codes = new ArrayList<Code>();
		Iterator<String> it = map.keySet().iterator();
		
		while(it.hasNext()) {
			
			Code c = (Code) map.get(it.next());
			
			//개별조건 처리
			if (c.equalCode(params))
				codes.add(c);
		}
		return codes;
	}
	
	public List<Code> getCodeList(String sysId, String group) {
		
		ParamsMap params = new ParamsMap();
		params.put(SYS_ID ,    sysId);
		params.put(CODE_GROUP, group);
		
		return getCodeList(params);
	}
	/**
	 * @param params.sysId    필수조건 (시스템 아이디)
	 *        params.codeGrup 필수조건 (코드 그룹)
	 *        params.codeCd   필수조건 (코드)
	 */
	public Code getCode(ParamsMap params) {
		
		if (params == null)
			throw new ServiceException( getMessage("error.code.params") );
		if (params.containsKey(SYS_ID) == false)
			throw new ServiceException( getMessage("error.code.params.systemId") );
		if (params.containsKey(CODE_GROUP) == false)
			throw new ServiceException( getMessage("error.code.params.codeGrup") );
		if (params.containsKey(CODE_GROUP) == false)
			throw new ServiceException( getMessage("error.code.params.codeCd") );
		
		LinkedMap map = _getCodeSet(params);
		
		if (map == null)
			return null;
		
		return (Code)map.get(params.get(CODE_CD));
	}
	
	public Code getCode(String sysId, String group, String code) {
		
		ParamsMap params = new ParamsMap();
		params.put(SYS_ID,     sysId);
		params.put(CODE_GROUP, group);
		params.put(CODE_CD,    code);
		
		return getCode(params);
	}

	
	public Code getCodeGroup(String sysId, String group) {
		
		ParamsMap params = new ParamsMap();
		params.put(SYS_ID,     sysId);
		params.put(CODE_GROUP, ROOT);
		params.put(CODE_CD,    group);
		
		return getCode(params);
	}

}
