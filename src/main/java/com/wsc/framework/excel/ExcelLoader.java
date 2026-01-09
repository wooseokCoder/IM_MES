package com.wsc.framework.excel;

import org.springframework.stereotype.Component;

@Component
public class ExcelLoader {
/*  (현재사용안함 : com.wsc.common.loader.LoaderComponent로 이동처리 : 2015-05-07)
	@Value("#{app['excel.loader']}")
	private String loaderPath;
	
	//설정 XML을 이용하여 엑셀파일의 데이터를 로드하기
	public Map load(MultipartFile file, String config) {

		InputStream xmlstream = null;
		InputStream xlsstream = null;
		try {
			// XLS 리더 설정
			xmlstream = new BufferedInputStream(getClass().getResourceAsStream(loaderPath+config));
		    XLSReader reader = ReaderBuilder.buildFromXML( xmlstream );

		    // 읽을 엑셀파일
		    xlsstream = new BufferedInputStream(file.getInputStream());

		    List<RecordMap> list = new ArrayList<RecordMap>();
		    RecordMap header = new RecordMap();
		    
		    // 읽은 결과값 받을 객체 선언
		    Map beans = new HashMap();
		    beans.put("list"  , list);
		    beans.put("header", header);

		    // 파일읽기 실행
		    XLSReadStatus status = reader.read(xlsstream, beans);
		    
		    if (status.isStatusOK())
		    	return beans;
		    
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (InvalidFormatException e) {
			e.printStackTrace();
		} finally {
			try {
				if (xmlstream != null)
					xmlstream.close();
			} catch(Exception ignored) {}
			try {
				if (xlsstream != null)
					xlsstream.close();
			} catch(Exception ignored) {}
		}
		return null;
	}
*/

}
