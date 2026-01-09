package com.wsc.common.user2;

import java.util.List;
import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.wsc.common.code.CodeService;
import com.wsc.common.security.SessionComponent;
import com.wsc.common.user.GroupService;
import com.wsc.common.user2.User2SecureService;
import com.wsc.common.user2.User2Service;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

@Controller
@RequestMapping("/common/user2")
@SessionAttributes("user2")
public class User2Controller extends BaseController {
	@Autowired
	private User2Service userService;	
	@Autowired
	private GroupService groupService;
	@Autowired
	private User2SecureService userSecureService;
	@Autowired
	private Provider<SessionComponent> sessionProvider;
	@Autowired 	
	private CodeService codeService;
	@Override
	protected BaseService getService() {
		return this.userService;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}

	@RequestMapping(value = "/user2.do")
	public String open(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		String[] codeGrupList =  {"USE_FLAG","WARE_HOUS","CNTY_CODE","TRANS_ZONE","AREA_CODE","PAYM_METH","SALE_GRUP","CURR_UNIT","MAIL_RECV","SHIP_LOC","WARE_HOUS","ORG_AUTH"};
		params.add("codeGrup", BaseUtils.codeArray(codeGrupList));
		Object result = codeService.search("searchCode", params);
		Object result2 = userService.search("selectBmList", params);
		Object result3 = userService.search("selectHeadDealList", params);
		model.addAttribute("result",result);
		model.addAttribute("selectBmList",result2);
		model.addAttribute("selectHeadDealList",result3);
		return super.open(request, model);
	}

	@RequestMapping(value = "/user2/search.json")
	public String search(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		
		if(params.containsKey("h_userIdList") && !"".equals(params.get("h_userIdList").toString())){
			String[] userIdList = params.get("h_userIdList").toString().split(",");
			params.put("userIdList", userIdList);
		}
		
		Object result = searchList(params);
		
		HttpSession session = request.getSession();
		if(session.getAttribute("rows") != null){
			if(params.getRows() != Integer.parseInt((session.getAttribute("rows")).toString())){
				session.setAttribute("rows", params.getRows());
			}
		}else{
			session.setAttribute("rows", params.getRows());
		}
		params.add("rows", session.getAttribute("rows"));
		
		addObject(model, result);
		return "jsonView";
	}

	@RequestMapping(value = "/user2/download.do")
	public String download(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		
		// 파라메타 한글 깨짐 20180202 박민혁
		java.util.Enumeration params1 = request.getParameterNames();
		while (params1.hasMoreElements()){
			String name = (String)params1.nextElement();
			try {
				params.put(name, new String(request.getParameter(name).getBytes("iso-8859-1"), "utf-8"));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if(params.containsKey("h_userIdList") && !"".equals(params.get("h_userIdList").toString())){
			String[] userIdList = params.get("h_userIdList").toString().split(",");
			params.put("userIdList", userIdList);
		}
		
		Object result = userService.search(params);
		
		setExcelParams(model, result);
		
		return "jxlsView";
	}

	@RequestMapping(value = "/user2/download2.do")
	public String download2(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		
		if(params.containsKey("h_userIdList") && !"".equals(params.get("h_userIdList").toString())){
			String[] userIdList = params.get("h_userIdList").toString().split(",");
			params.put("userIdList", userIdList);
		}
		
		Object result = userService.search2(params, "search");
		
		setExcelParams(model, result, "UserList");
		
		return "jxlsView";
	}

	@RequestMapping(value = "/user2/select.json")
	public String select(HttpServletRequest request, Model model) {
		return super.select(request, model);
	}

	@RequestMapping(value = "/user2/save.json")
	public String save(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	
    	List<Map> list = (List<Map>)params.get(ParamsMap.MODEL_LIST);
		
		for (Map t_model : list) {

			ParamsMap m = new ParamsMap();
			
			m.putAll(t_model);
			if(params.get("gsUserId").equals(m.getString("userId"))) {
				sessionProvider.get().saveUserDashType(m.getString("dashType"));
			}
		}
		
		return super.save(request, model);
	}

	@RequestMapping(value = "/user2/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/user2/selectUserType.json")
	public String userType(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);

	    Object result = userService.search("selectUserType",params);

	    System.out.println("params : " + result);
	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/user2/selectUserBm.json")
	public String userBm(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);

	    Object result = userService.search("selectUserBm",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}

	//관리자 자동로그인시 보안키 생성 및 반환
	@RequestMapping(value = "/user2/secure.json")
	public String secure(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request);

        Object result = userSecureService.selectSecure(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/user2/selectCodeName.json")
	public String selectCodeName(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);

	    Object result = userService.search("selectCodeName",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/user2/selectDealerCdf.json")
	public String selectDealerCdf(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);

	    Object result = userService.search("selectDealerCdf",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/user2/selectDealerInfo.json")
	public String selectDealerInfo(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);

	    Object result = userService.search("selectDealerInfo",params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/user2/dashBoardCurrUnit.json")
	public String dashBoardCurrUnit(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
		ParamsMap params = getParams(request);
		HttpSession session = request.getSession();
		
		Object result = userService.search("dashBoardCurrUnit",params);
	    // 모델에 객체를 추가한다.
	    addObject(model, result);
	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/user2/saveDealer.json")
	public String saveDealer(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = userService.saveDealUser(params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	@RequestMapping(value = "/user2/updateDealer.json")
	public String updateDealer(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = userService.updateDealUser(params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	
	@RequestMapping(value = "/user2/selectAuto.json")
	public String selectAuto(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = userService.search("selectAuto", params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}
	
	
	@RequestMapping(value = "/user2/searchType.json")
	public String searchType(HttpServletRequest request, Model model) {
		return super.search(request, model,"searchType");
	}
	
	@RequestMapping(value = "/user2/searchApplList.json")
	public String searchApplList(HttpServletRequest request, Model model) {
		return super.search(request, model,"searchApplList");
	}
	
	
	@RequestMapping(value = "/user2/searchDetail.json")
	public String searchDetail(HttpServletRequest request, Model model) {
		return super.search(request, model,"searchDetail");
	}
	
	
	
	
	
	
}
