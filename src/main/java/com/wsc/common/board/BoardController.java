package com.wsc.common.board;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.inject.Provider;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.wsc.common.Consts;
import com.wsc.common.code.CacheComponent;
import com.wsc.common.security.SessionComponent;
import com.wsc.framework.base.BaseController;
import com.wsc.framework.base.BaseService;
import com.wsc.framework.model.ParamsMap;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/common/board")
public class BoardController extends BaseController {
	
	@Autowired 
	private BoardService service;
	
	@Autowired 
	private CacheComponent cache;
	
	@Autowired 
	private Provider<SessionComponent> sessionProvider;
	
	
	@Value("#{app['file.upload.path']}")
	private String fileImagePath;
	
	@Value("#{app['file.upload.defaultpath']}")
	private String defaultPath;

	@Override
	protected BaseService getService() {
		return this.service;
	}
	@Override
	protected SessionComponent getSessionComponent() {
		return this.sessionProvider.get();
	}

	//게시판그룹
	private BoardGroup group = BoardGroup.GENERAL;
	
	private String openBoard(HttpServletRequest request, Model model, String name) {
		
		//[WSC2.0] [2015.04 LSH] 상단정보 설정
		ParamsMap params = super.initParams(request, model);
		
		//게시판 기본셋팅
		group.bindParams(params, cache);
		
		model.addAttribute("model", params);
		
		return super.getView(name);
	}
	
	//관리화면 오픈
	@RequestMapping(value = "/board.do")
	public String open(HttpServletRequest request, Model model) {
		return openBoard(request, model, null);
	}
	
	//등록,수정화면 오픈
	@RequestMapping(value = "/form.do")
	public String openForm(HttpServletRequest request, Model model) {
		return openBoard(request, model, "boardForm");
	}
	
	//상세조회화면 오픈
	@RequestMapping(value = "/view.do")
	public String openView(HttpServletRequest request, Model model) {
		return openBoard(request, model, "boardView");
	}
	
	//2016/12/13 김영진 조회자 목록 오픈
	@RequestMapping(value = "/views.do")
	public String addrOpen(HttpServletRequest request, Model model) {
		String bordNo = request.getParameter("bordNo");
		String bordGrup = request.getParameter("bordGrup");
		//System.out.println("menuKey :::::::::" + menuKey);
		model.addAttribute("bordNo", bordNo);
		model.addAttribute("bordGrup", bordGrup);
		
		return super.open(request, model, "views");
	}

	@RequestMapping(value = "/views/search.json")
	public String internalListSearch(HttpServletRequest request, Model model) {
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

	@RequestMapping(value = "/search.json")
	public String search(HttpServletRequest request, Model model) {
		return super.search(request, model);
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

	@RequestMapping(value = "/save.json")
	public String save(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}

	@RequestMapping(value = "/delete.json")
	public String delete(HttpServletRequest request, Model model) {
		return super.save(request, model);
	}
	
	@RequestMapping(value = "/boardaddimage.json")
	public String boardaddimage(MultipartHttpServletRequest request, Model model, HttpSession httpSession) {
		//String imageUrl = request.getContextPath()+"/resources/jquery/daumeditor-7.5.9/uploadimage/";
		//String defaultPath = "/home/lsta/app";
		//String uploadPath = defaultPath+"resources"+File.separator+"jquery"+File.separator+"daumeditor-7.5.9"+File.separator+"uploadimage"+File.separator+"";
		String imageUrl = fileImagePath+"/UPLOADIM/";
		//String defaultPath = httpSession.getServletContext().getRealPath("/");
		String realPath =fileImagePath+"/UPLOADIM/";
		/*String uploadPath = defaultPath+"resources"+File.separator+"jquery"+File.separator+"daumeditor-7.5.9"+File.separator+"uploadimage"+File.separator+"";*/
		String uploadPath = defaultPath+realPath;
		//String uploadPath = "C:\\eclipseBundle\\workspace\\wsc-1.0-Oracle\\src\\main\\webapp\\resources\\jquery\\daumeditor-7.5.9\\uploadimage\\";
		//System.out.println(defaultPath+"resources"+File.separator+"jquery"+File.separator+"daumeditor-7.5.9"+File.separator+"uploadimage"+File.separator+"");
		//System.out.println("defaultPath::"+uploadPath);
		//System.out.println("subContext::"+imageUrl);
		
		Map<String,Object> fileInfo = new HashMap<String,Object>();
		
		File dir = new File(uploadPath);
		if (!dir.isDirectory()) {
			dir.mkdirs();
		}
		
		Iterator<String> iter = request.getFileNames(); //파일타입 입력상자 파라미터 이름


		while(iter.hasNext()) {
			String uploadFileName = iter.next();
			
			MultipartFile mFile = request.getFile(uploadFileName);
			
			String originalFileName = mFile.getOriginalFilename(); // 실제 파일명.
			// 파일 확장자
			String strFileExt = originalFileName.substring(originalFileName.lastIndexOf(46) + 1, originalFileName.length());

			// saveFileName : 업로드된 파일명. - Key를 생성.
			String saveFileName = System.currentTimeMillis() + "." + strFileExt ;
			System.out.println("strFileExt::"+strFileExt);
			if(strFileExt.toUpperCase().equals("JPG") || strFileExt.toUpperCase().equals("PNG") || strFileExt.toUpperCase().equals("BMP") || strFileExt.toUpperCase().equals("GIF") || strFileExt.toUpperCase().equals("JPEG") ){
				fileInfo.put("imageurl", imageUrl+saveFileName);
				fileInfo.put("filename", saveFileName);
				fileInfo.put("filesize", mFile.getSize());
				fileInfo.put("imagealign", "C");
				fileInfo.put("originalurl", imageUrl+saveFileName);
				fileInfo.put("thumburl", imageUrl+saveFileName);
			}else {
				System.out.println("saveFileName::"+saveFileName);
				fileInfo.put("strFileExt", "N");
	        }
			
			try {
				if(strFileExt.toUpperCase().equals("JPG") || strFileExt.toUpperCase().equals("PNG") || strFileExt.toUpperCase().equals("BMP") || strFileExt.toUpperCase().equals("GIF") || strFileExt.toUpperCase().equals("JPEG") ){
					System.out.println("a1::"+uploadPath);
					System.out.println("a2::"+saveFileName);
					mFile.transferTo(new File(uploadPath + saveFileName));
				}
				
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		
		model.addAttribute("fileInfo", fileInfo);
		return "jsonView";
	}
	
	@RequestMapping(value = "/alterTop.json")
	public String alterTop(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.search("alterTop", params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/alterBottom.json")
	public String alterBottom(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.search("alterBottom", params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/referemceTop.json")
	public String referemceTop(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.search("referemceTop", params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/referemceBottom.json")
	public String referemceBottom(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.search("referemceBottom", params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/noticeTop.json")
	public String noticeTop(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.search("noticeTop", params);
        
        // 모델에 객체를 추가한다.
        addObject(model, result);
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/searchBordDetail.json")
	public String searchBordDetail(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.search("searchBordDetail", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/searchbordindexb17.json")
	public String searchBordIndexB17(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        System.out.println("fileImagePath:"+fileImagePath);
        Object result = service.search("searchBordIndexB17", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/searchbordindexb99.json")
	public String searchBordIndexB99(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        
        Object result = service.search("searchBordIndexB99", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/searchbordindexb19.json")
	public String searchBordIndexB19(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        System.out.println("fileImagePath:"+fileImagePath);
        Object result = service.search("searchBordIndexB19", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/searchbordimg.json")
	public String searchBordImg(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        params.put("fileImagePath",fileImagePath);
        Object result = service.search("searchBordImg", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	/**
	 * 파일업로드 (업로드전)
	 * @param request
	 * @param response
	 * @param dir
	 * @param uploadedFileName
	 * @param caption
	 * @throws UnsupportedEncodingException
	 *//*
	@RequestMapping(value="/download/{dir}/{uploadFileName}/{caption}")
	public void download(HttpServletRequest request,HttpServletResponse response, 
			 	@PathVariable("dir") String dir ,
			 	@PathVariable("uploadFileName") String uploadedFileName ,
			 	@PathVariable("caption") String caption 
			) throws UnsupportedEncodingException {
		response.setCharacterEncoding("UTF-8");
		// 파라메터를 가져온다.
		InputStream inputStream = null;
		ParamsMap params = getParams(request);
		
		try {		    
			String filePathToBeServed = Utils.createStoredFolder(uploadpath+dir);
	        File file = new File(filePathToBeServed+File.separator + uploadedFileName);
	        inputStream = new FileInputStream(file);
	        
	        response.setContentType(Utils.mimeTypeOf(caption));
	        response.setHeader("Content-Disposition", "attachment;fileName=\""+Utils.getEncodedFileName(request,caption)+"\""); 
	        response.setHeader("Content-Transfer-Encoding", "binary");
	        response.setContentLengthLong(file.length());
	        IOUtils.copy(inputStream, response.getOutputStream());
	        
		}catch(ClientAbortException e){
		}catch(IOException e){
	    } catch (Exception e){
	        //e.printStackTrace();
	    }finally {
	    	try {
	    		inputStream.close(); 
	    		response.getOutputStream().flush();
		    	response.getOutputStream().close();
    		} catch(Exception ignored) {
    			//ignored.printStackTrace();
    		}
	    }

	}*/
	
	//트랙터 상태값 조회
	@RequestMapping(value = "/searchbordtc.json")
	public String searchBordTc(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.search("searchBordTc", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/searchbordagtc.json")
	public String searchBordAgTc(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.search("searchBordAgTc", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/searchbordagtc04.json")
	public String searchBordAgTc04(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.search("searchBordAgTc04", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	
	//차트 데이터 조회
	@RequestMapping(value = "/searchChartBizPlan.json")
	public String searchChartBizPlan(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.search("searchChartBizPlan", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	//Daily Sales Report 조회
	@RequestMapping(value = "/searchDailySalesReport.json")
	public String searchDailySalesReport(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.search("searchDailySalesReport", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	//Dashboard Dealer Info. 조회
	@RequestMapping(value = "/getDashDealInfo.json")
	public String getDashDealInfo(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.select("getDashDealInfo", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
	
	@RequestMapping(value = "/searchBordRts04.json")
	public String searchBordRts04(HttpServletRequest request, Model model) {
    	
        // 파라메터를 가져온다.
        ParamsMap params = getParams(request);
        Object result = service.search("searchBordRts04", params);

        // 모델에 객체를 추가한다.
        addObject(model, result);
        
        // 뷰이름을 반환한다.
        return "jsonView";
	}
}
