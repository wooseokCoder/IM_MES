package com.wsc.common.mail;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.xmlbeans.impl.xb.ltgfmt.TestCase.Files;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.wsc.common.board.BoardGroup;
import com.wsc.common.code.CacheComponent;
import com.wsc.common.model.FileInfo;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;
import com.wsc.framework.utils.BaseUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;
import javax.print.attribute.standard.Destination;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/mail")
public class MailController extends BaseController {
	@Value("#{app['default.system.id']}")
	public String systemID;

	@Autowired
	private MailService service;

	@Autowired
	private CacheComponent cache;

	@Autowired
	private Provider<SessionComponent> sessionProvider;

	@Override
	protected BaseService getService() {
		return this.service;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}

	//게시판그룹
	private BoardGroup group;

	private String openBoard(HttpServletRequest request, Model model, String name) {

		//[WSC2.0] [2015.04 LSH] 상단정보 설정
		ParamsMap params = super.initParams(request, model);

		//[2017.05 SJY]권한체크
    	programAuth(request, model);

		//게시판 기본셋팅
		group.bindParams(params, cache);

		model.addAttribute("model", params);

		return super.getView(name);
	}

	@RequestMapping(value = "/mail.do")
	public String open(HttpServletRequest request, Model model) {
		group = BoardGroup.MAIL;
		//2016/12/13 김영진 -- 유저 타입 모델객체에 추가
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = service.search("getUserType", params);
    	//System.out.println("result::::::::::" + result.toString());
    	String sobj = result.toString();
    	sobj = sobj.replace("[", "");
    	sobj = sobj.replace("]", "");

		model.addAttribute("userType", sobj);

		return openBoard(request, model, null);
	}

	@RequestMapping(value = "/internalmail.do")
	public String internalOpen(HttpServletRequest request, Model model) {
		group = BoardGroup.INTERNAL;
		//2016/12/13 김영진 -- 유저 타입 모델객체에 추가
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = service.search("getUserType", params);
    	//System.out.println("result::::::::::" + result.toString());
    	String sobj = result.toString();
    	sobj = sobj.replace("[", "");
    	sobj = sobj.replace("]", "");

		model.addAttribute("userType", sobj);

		return openBoard(request, model, "internalMail");
	}

	@RequestMapping(value = "/internallist.do")
	public String internalListOpen(HttpServletRequest request, Model model) {
		group = BoardGroup.INTERNAL;
		return openBoard(request, model, "internalList");
	}

	@RequestMapping(value = "/address.do")
	public String addrOpen(HttpServletRequest request, Model model) {
		String menuKey = request.getParameter("menuKey");
		//System.out.println("menuKey :::::::::" + menuKey);
		model.addAttribute("menuKey", menuKey);

		return super.open(request, model, "address");
	}

	@RequestMapping(value = "/userlist.do")
	public String userOpen(HttpServletRequest request, Model model) {
		String menuKey = request.getParameter("menuKey");
		//System.out.println("menuKey :::::::::" + menuKey);
		model.addAttribute("menuKey", menuKey);

		return super.open(request, model, "userList");
	}

	//등록,수정화면 오픈
	@RequestMapping(value = "/mailform.do")
	public String openForm(HttpServletRequest request, Model model) {
		return openBoard(request, model, "mailForm");
	}

	//상세조회화면 오픈
	@RequestMapping(value = "/mailview.do")
	public String openView(HttpServletRequest request, Model model) {
		return openBoard(request, model, "mailView");
	}

	//수신상세조회화면 오픈
	@RequestMapping(value = "/mailview2.do")
	public String openView2(HttpServletRequest request, Model model) {
		ParamsMap params = getParams(request);
		String userId = params.getString("gsUserId");
		//System.out.println("userId :::::::::" + userId);
		model.addAttribute("userId", userId);

		return openBoard(request, model, "mailView2");
	}

	//2016/12/13 김영진 조회자 목록 오픈
	@RequestMapping(value = "/views.do")
	public String viewsOpen(HttpServletRequest request, Model model) {
		String bordNo = request.getParameter("bordNo");
		String bordGrup = request.getParameter("bordGrup");
		//System.out.println("menuKey :::::::::" + menuKey);
		model.addAttribute("bordNo", bordNo);
		model.addAttribute("bordGrup", bordGrup);

		return super.open(request, model, "views");
	}

	@RequestMapping(value = "/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
	}

	@RequestMapping(value = "/internalList/search.json")
	public String internalListSearch(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.searchInternalList(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/internal/search.json")
	public String internalUserListSearch(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);

        Object result = service.searchUserList(params);

        HttpSession sessionS = request.getSession();

        if(sessionS.getAttribute("rows") != null){
            if(params.getRows() != Integer.parseInt((sessionS.getAttribute("rows")).toString())){
            	sessionS.setAttribute("rows", params.getRows());
            }
        }else{
        	sessionS.setAttribute("rows", params.getRows());
        }
        params.add("rows", sessionS.getAttribute("rows"));

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/address/search.json")
	public String addrSearch(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
		params.put("bordGrup", group.getCode());

        Object result = service.searchUserAddr(params);

        HttpSession sessionS = request.getSession();

        if(sessionS.getAttribute("rows") != null){
            if(params.getRows() != Integer.parseInt((sessionS.getAttribute("rows")).toString())){
            	sessionS.setAttribute("rows", params.getRows());
            }
        }else{
        	sessionS.setAttribute("rows", params.getRows());
        }
        params.add("rows", sessionS.getAttribute("rows"));

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
		/*ParamsMap params = getParams(request);
		params.put("bordGrup", group.getCode());
		Object result = service.search("userAddress", params);
		model.addAttribute("userAddress",result);

        // 뷰이름을 반환한다.
        return "jsonView";*/
	}

	@RequestMapping(value = "/views/search.json")
	public String viewsListSearch(HttpServletRequest request, Model model) {
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        String strBordNo = params.getString("bordNo");
        String strBordGrup = params.getString("bordGrup");
		String menuKey = request.getParameter("menuKey");
		//System.out.println("menuKey :::::::::" + menuKey);
		model.addAttribute("menuKey", menuKey);
        if(strBordNo == "" || strBordNo == null || strBordNo.equals("")){
        	params.add("bordNo", "Not Parameter");
        }
        if(strBordGrup == "" || strBordGrup == null || strBordGrup.equals("")){
        	params.add("bordGrup", "Not Parameter");
        }

        Object result = service.searchViewsList(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/address/save.json")
	public String addrSave(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

		params.put("bordGrup", group.getCode());

        Object result = service.saveUserAddr(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/delete.json")
	public String delete(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request);

		Object result = service.delete("mailTgtDelete", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/delete2.json")
	public String delete2(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/delete3.json")
	public String delete3(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	Object data = params.get(ParamsMap.MODEL_LIST);
    	if (data instanceof List) {
			List<Map> list = (List<Map>)data;
			for(Map model2 : list) {
		    	//System.out.println(model2.get("bordNo"));
		    	params.add("bordNo", model2.get("bordNo"));
			}
		}

		Object result = service.delete("deleteBoard", params);

		System.out.println(result);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/delete4.json")
	public String delete4(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);
    	System.out.println("bordNo :::::::::"+params.toString());
		Object result = service.delete("deleteTarget", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/download.do")
	public String download(HttpServletRequest request, Model model) {
		return super.download(request, model);
	}

	@RequestMapping(value = "/select.json")
	public String select(HttpServletRequest request, Model model) {

        // 파라메터를 가져온다.
    	ParamsMap params = getParams(request);

		// 상세조회
    	Object result = service.selectView(params);

        // 모델에 객체를 추가한다.
        addObject(model, result);

        // 뷰이름을 반환한다.
        return "jsonView";
	}

	@RequestMapping(value = "/boardaddimage.json")
	public String boardaddimage(MultipartHttpServletRequest request, Model model, HttpSession httpSession) {
		String imageUrl = request.getContextPath()+"/resources/jquery/daumeditor-7.5.9/uploadimage/";
		String defaultPath = httpSession.getServletContext().getRealPath("/");
		String uploadPath = defaultPath+"resources"+File.separator+"jquery"+File.separator+"daumeditor-7.5.9"+File.separator+"uploadimage"+File.separator+"";
		//String uploadPath = "C:\\eclipseBundle\\workspace\\wsc-1.0-Oracle\\src\\main\\webapp\\resources\\jquery\\daumeditor-7.5.9\\uploadimage\\";
		System.out.println(defaultPath+"resources"+File.separator+"jquery"+File.separator+"daumeditor-7.5.9"+File.separator+"uploadimage"+File.separator+"");
		System.out.println("defaultPath::"+uploadPath);
		System.out.println("subContext::"+imageUrl);

		Map<String,Object> fileInfo = new HashMap<String,Object>();

		File dir = new File(uploadPath);
		if (!dir.isDirectory()) {
			dir.mkdirs();
		}
		ParamsMap params = getParams(request, true);

		Iterator<String> iter = request.getFileNames(); //파일타입 입력상자 파라미터 이름


		while(iter.hasNext()) {
			String uploadFileName = iter.next();

			MultipartFile mFile = request.getFile(uploadFileName);

			String originalFileName = mFile.getOriginalFilename(); // 실제 파일명.
			// 파일 확장자
			String strFileExt = originalFileName.substring(originalFileName.lastIndexOf(46) + 1, originalFileName.length());

			// saveFileName : 업로드된 파일명. - Key를 생성.
			String saveFileName = System.currentTimeMillis() + "." + strFileExt ;
			System.out.println("saveFileName::"+saveFileName);

			fileInfo.put("imageurl", imageUrl+saveFileName);
			fileInfo.put("filename", saveFileName);
			fileInfo.put("filesize", mFile.getSize());
			fileInfo.put("imagealign", "C");
			fileInfo.put("originalurl", imageUrl+saveFileName);
			fileInfo.put("thumburl", imageUrl+saveFileName);

			try {
				mFile.transferTo(new File(uploadPath + "/" + saveFileName));

			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}


		model.addAttribute("fileInfo", fileInfo);
		return "jsonView";
	}

	@RequestMapping(value = "/getNo.json")
	public String getNo(HttpServletRequest request, Model model) {
		// 파라메터를 가져온다.
    	ParamsMap params = getParams(request, true);

    	Object result = service.search("mailNo", params);

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}

	/*@RequestMapping(value = "/getFile.json")
	public String getFile(MultipartHttpServletRequest request, Model model, HttpSession httpSession){
    	ParamsMap params = getParams(request, true);
		String uploadPath = path+"/";
		Map<String,Object> fileInfo = new HashMap<String,Object>();
		int i = 0;

		File dir = new File(uploadPath);
		if (!dir.isDirectory()) {
			dir.mkdirs();
		}

    	Iterator<String> iter = request.getFileNames();
	    while(iter.hasNext()){
	    	String uploadFileName = iter.next();
	    	System.out.println("inName::"+uploadFileName);
	    	MultipartFile mFile = request.getFile(uploadFileName);
	    	if(mFile.isEmpty() || mFile == null || mFile.getName().equals("")){
	    		continue;
	    	}
			String originalFileName = mFile.getOriginalFilename(); // 실제 파일명.
			String fileType = mFile.getContentType();
			// 파일 확장자
			String strFileExt = originalFileName.substring(originalFileName.lastIndexOf(46) + 1, originalFileName.length());

			// saveFileName : 업로드된 파일명. - Key를 생성.
			String saveFileName = System.currentTimeMillis() + i + "." + strFileExt ;
			Map<String,Object> fileObj = new HashMap<String,Object>();
			System.out.println("saveFileName::"+saveFileName);
			System.out.println("uploadPath::"+uploadPath);

			fileObj.put("fileName", saveFileName);
			fileObj.put("fileSize", mFile.getSize());
			fileObj.put("filePath", path);
			fileObj.put("fileType", fileType);
			fileObj.put("saveName", originalFileName);

			fileInfo.put(""+i, fileObj);

	    	try{
				mFile.transferTo(new File(uploadPath + "/" + saveFileName));
	    	}catch(IllegalStateException e) {
				e.printStackTrace();
			}catch(IOException e) {
				e.printStackTrace();
			}
	    	i++;
	    }

	    if(i > 0)
	    	model.addAttribute("fileInfo", fileInfo);

		return "jsonView";
	}*/

	@RequestMapping(value = "/save.json")
	public String save(HttpServletRequest request, Model model) {
		//return super.save(request, model);
		// 파라메터를 가져온다.
    	//ParamsMap params = getParams(request, true);

    	//int fileCnt = Integer.parseInt(params.get("fileCnt").toString());
    	/*int fileCnt = params.get("files").toString().length();
    	String fileName = "";
    	String saveName = "";
    	String filePath = "";
    	String fileType = "";
    	String fileSize = "";

    	for(int i = 0; i < fileCnt;i++){
    		fileName += params.get("fileName") + ",";
    		saveName += params.get("saveName") + ",";
    		filePath += params.get("filePath") + ",";
    		fileType += params.get("fileType") + ",";
    		fileSize += params.get("fileSize") + ",";
    	}

    	params.add("fileName", fileName);
    	params.add("saveName", saveName);
    	params.add("filePath", filePath);
    	params.add("fileType", fileType);
    	params.add("fileSize", fileSize);*/

	    //파일 서버에 저장
	    /*Iterator<String> itr = request.getFileNames();
	    if(itr.hasNext()){
	    	MultipartFile mpf = request.getFile(itr.next());
	    	System.out.println(mpf.getOriginalFilename() + " -- upload");
	    	try{

	    	}catch(Exception e){

	    	}
	    }*/

    	//Object result = service.insert("mailSend", params);

	    // 모델에 객체를 추가한다.
	    //addObject(model, result);

	    // 뷰이름을 반환한다.
	    //return "jsonView";
		ParamsMap params = getParams(request);
		if(params.getString("mailType").equals("userlist")){
			String bordText = params.getString("bordText");
			bordText += "<img style='display:none;' width='0' height='0' src='http://192.168.0.64:2020/wsc/common/mail/read.do?bordNo="+params.get("bordNo")+"&userId=${gsUserId}&bordGrup="+ params.getString("bordGrup") +"' />";
			request.setAttribute("bordText2", bordText);
			System.out.println("bordText:::::::::");
		}

		return super.save(request, model);
	}

	@RequestMapping(value = "/read.do")
	public @ResponseBody void read(@RequestParam(value = "bordNo") String bordNo, @RequestParam(value = "userId") String userId, @RequestParam(value = "bordGrup") String bordGrup){// 파라메터를 가져온다.
		//System.out.println("readNo" + bordNo + "\nreadId" + userId);
		ParamsMap params = new ParamsMap();
		params.add("bordNo", bordNo);
		params.add("userId", userId);
		params.add("bordGrup", bordGrup);
		params.add("sysId", systemID);
    	Object result = service.update("updateReadMail", params);
	}

	@RequestMapping(value = "/download2.do")
	public String download2(HttpServletRequest request, Model model) {
		return super.download(request, model, "search" , "MailList");
	}

	@RequestMapping(value = "/download3.do")
	public String download3(HttpServletRequest request, Model model) {
		return super.download(request, model, "searchInternalList" , "InternalList");
	}

	/*@RequestMapping(value = "/send.json")
	public String send(HttpServletRequest request, Model model) throws IOException {
		// 파라메터를 가져온다.
	    ParamsMap params = getParams(request);

	 // 메일 관련 정보
        String host = "smtp.naver.com";
        int port=465;

        Properties props = System.getProperties();

        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.debug", "true");
        props.put("mail.smtp.socketFactory.port", port);
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.socketFactory.fallback", "false");

        Authenticator auth = new SMTPAuthenticatior(smtp_id, smtp_pw);
        Session ses = Session.getInstance(props, auth);

        ses.setDebug(true); //for debug

        if(smtp_read.equals("N")){
	        Message mimeMessage = new MimeMessage(ses);
	        try {
	            // 메일 내용
	        	Address[] recipient = InternetAddress.parse(params.get("mail_to").toString().replaceAll(";", ","));
	            String subject = params.get("mail_subject").toString();
	            String body = "";
	            //body = "<img style='display:none;' width='0' height='0' src='http://192.168.0.64:2020/wsc/common/mail/read.do?bordNo="+params.get("bordNo")+"' />";
	            body = params.get("mail_text").toString();
	            Address[] cc = InternetAddress.parse(params.get("mail_cc").toString().replaceAll(";", ","));

				mimeMessage.setFrom(new InternetAddress(smtp_id + "@naver.com"));
		        mimeMessage.setRecipients(Message.RecipientType.TO, recipient);
		        mimeMessage.addRecipients(Message.RecipientType.CC,cc);
		        mimeMessage.setSubject(subject);
		        mimeMessage.setText(body);
		        //mimeMessage.setContent(body, "text/html; charset=utf-8");

		        MimeBodyPart mbp1 = new MimeBodyPart();
		        mbp1.setContent(body, "text/html; charset=utf-8");

		        Multipart mp = new MimeMultipart();
		        mp.addBodyPart(mbp1);
		        int fileCnt = Integer.parseInt(params.get("fileCnt").toString());
		        if(fileCnt > 0){
				        //fileName = fileSize(fileName);
				        MimeBodyPart[] mbp2 = new MimeBodyPart[fileCnt];
				        FileDataSource[] fds = new FileDataSource[fileCnt];
			        	for(int j = 0; j < Integer.parseInt(params.get("fileCnt").toString()); j++){
			        		String upPath = params.get("filePath"+j).toString() + "/";
			        		String fileName = params.get("fileName"+j).toString();
					        String filePath = upPath + fileName;
			        		mbp2[j] = new MimeBodyPart();
			        		fds[j] = new FileDataSource(filePath);

					        mbp2[j].setDataHandler(new DataHandler(fds[j]));
					        mbp2[j].setFileName(params.get("saveName"+j).toString());
				        	mp.addBodyPart(mbp2[j]);
			        	}

		        }

		        mimeMessage.setContent(mp);

		        Transport.send(mimeMessage);  //메일 발송
			} catch (AddressException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (MessagingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }else{
	        try {
	            // 메일 내용
	        	String[] recipient = params.get("mail_to").toString().replaceAll(";", ",").split(",");
	            String subject = params.get("mail_subject").toString();
	            String[] cc = params.get("mail_cc").toString().replaceAll(";", ",").split(",");
	            int ln = 0;
	            if(cc[0].equals("") || cc[0] == null){
	            	ln = 1;
	            }
	            System.out.println("mail_to ::"+recipient.length);
	            System.out.println("mail_cc ::"+cc.length);

	            String[] sendTo = new String[recipient.length + cc.length];
	            System.arraycopy(recipient, 0, sendTo, 0, recipient.length);
	            System.arraycopy(cc, 0, sendTo, recipient.length, cc.length);
	            System.out.println("sendTo ::"+sendTo.length);
	            System.out.println("length ::"+ln);

	            for(int i = 0; i < sendTo.length-ln; i++){
		            //System.out.println("send ID::"+sendTo[i].toString());

	            	Message mimeMessage = new MimeMessage(ses);
		            String body = "";
		            body = "<img style='display:none;' width='0' height='0' src='http://192.168.0.64:2020/wsc/common/mail/read.do?bordNo="+params.get("bordNo")+"&userId="+sendTo[i]+"' />";
		            body += params.get("bordText").toString();

					mimeMessage.setFrom(new InternetAddress(smtp_id + "@naver.com"));
			        mimeMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(sendTo[i]));
			        //mimeMessage.addRecipients(Message.RecipientType.CC, cc);
			        mimeMessage.setSubject(subject);
			        //mimeMessage.setText(body);
			       // mimeMessage.setContent(body, "text/html; charset=utf-8");

			        MimeBodyPart mbp1 = new MimeBodyPart();
			        mbp1.setContent(body, "text/html; charset=utf-8");

			        Multipart mp = new MimeMultipart();
			        mp.addBodyPart(mbp1);
			        //int fileCnt = Integer.parseInt(params.get("fileCnt").toString());
			        int fileCnt = params.get("files").toString().length();
			        if(fileCnt > 0){
			        	List<Map> files = BaseUtils.getJsonList(params, "files");
			        	List<FileInfo> list = new ArrayList<FileInfo>();
			        	MimeBodyPart[] mbp2 = new MimeBodyPart[fileCnt];
				        FileDataSource[] fds = new FileDataSource[fileCnt];
				        int j = 0;

			        	for (Map map : files) {

			        		String filePath = "C:/" + path + map.get("filePath").toString() + "/" + map.get("saveName").toString();
			        		//String filePath = "C:/" + path + "/" + map.get("saveName").toString();
			        		mbp2[j] = new MimeBodyPart();
			        		fds[j] = new FileDataSource(filePath);

					        mbp2[j].setDataHandler(new DataHandler(fds[j]));
					        mbp2[j].setFileName(map.get("fileName").toString());
				        	mp.addBodyPart(mbp2[j]);

			        		j++;
			    		}
			        }

			        mimeMessage.setContent(mp);

			        Transport.send(mimeMessage);  //메일 발송
	            }
			} catch (AddressException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (MessagingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }

	    Object result = "";

	    // 모델에 객체를 추가한다.
	    addObject(model, result);

	    // 뷰이름을 반환한다.
	    return "jsonView";
	}*/
}
