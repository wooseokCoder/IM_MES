package com.wsc.common.loader;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.jxls.reader.ReaderBuilder;
import net.sf.jxls.reader.XLSReadStatus;
import net.sf.jxls.reader.XLSReader;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.xml.sax.SAXException;

import com.wsc.common.Consts;
import com.wsc.framework.exception.SystemException;
import com.wsc.framework.model.RecordMap;
import com.wsc.framework.utils.FileUtils;

@Component
@SuppressWarnings({ "unchecked", "rawtypes" })
public class LoaderComponent {

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
	
	//POI 를 이용하여 엑셀파일의 데이터를 로드하기
	public List read(MultipartFile file, LoaderForm form) throws IOException {

		//엑셀 Sheet 읽기
		Sheet sheet = readSheet(file);
		//행,열 바꿈여부
		boolean pivot = form.isPivot();
		//데이터 행번호의 INDEX
		int startNo   = form.getStartNo() - 1;
		//행단위 목록
		List rows = new ArrayList();
		
		int rstart = (pivot ? 0 : startNo);
		int cstart = (pivot ? startNo : 0);
		
		for (int r = rstart; r < sheet.getPhysicalNumberOfRows(); r++) {
			
			Row row = sheet.getRow(r);
			
			if (row == null)
				continue;
			
			for (int c = cstart; c < row.getPhysicalNumberOfCells(); c++) {
				
				Cell cell = row.getCell(c);
				Map model = getCellMap(cell);
				if (pivot)
					addCell(rows, model, c - cstart, r - rstart);
				else
					addCell(rows, model, r - rstart, c - cstart);
			}
		}
		return rows;
	}

	
	//POI 를 이용하여 엑셀파일의 타이틀데이터 로드하기
	public List readTitle(MultipartFile file, LoaderForm form) throws IOException {

		//엑셀 Sheet 읽기
		Sheet sheet = readSheet(file);
		//행,열 바꿈여부
		boolean pivot = form.isPivot();
		//제목 행번호의 INDEX
		int titleNo   = form.getTitleNo() - 1;
		//열단위 목록
		List cols = new ArrayList();
		
		if (pivot) {
			for (int r = 0; r < sheet.getPhysicalNumberOfRows(); r++) {
				Row  row  = sheet.getRow(r);
				Cell cell = row.getCell(titleNo);
				cols.add(getCellMap(cell));
			}
		}
		else {
			Row row = sheet.getRow(titleNo);
			for (int c = 0; c < row.getPhysicalNumberOfCells(); c++) {
				Cell cell = row.getCell(c);
				cols.add(getCellMap(cell));
			}
		}
		return cols;
	}
	
	private void addCell(List rows, Map cell, int r, int c) {
		
		while (rows.size() <= r)
			rows.add(new ArrayList());
		
		List cols = (List)rows.get(r);
		
		while (cols.size() <= c)
			cols.add(getCellMap(null));
		
		cols.set(c, cell);
	}
	
	private Map getCellMap(Cell cell) {
		Map model = new RecordMap();
		
		if (cell == null) {
			model.put("itemType",  Consts.LOADER_CELL_BLANK);
			model.put("itemValue", "");
			return model;
		}
		model.put("itemSeq", cell.getColumnIndex());

		switch (cell.getCellType()) {
			case Cell.CELL_TYPE_FORMULA: 
				model.put("itemType", Consts.LOADER_CELL_FORMULA);
				model.put("itemValue", cell.getNumericCellValue());
				break;
			case Cell.CELL_TYPE_NUMERIC:
				model.put("itemType", Consts.LOADER_CELL_NUMERIC);
				model.put("itemValue", cell.getNumericCellValue());
				break;
			case Cell.CELL_TYPE_STRING:   
				model.put("itemType", Consts.LOADER_CELL_STRING);
				model.put("itemValue", cell.getStringCellValue());
				break;
			case Cell.CELL_TYPE_BLANK:   
				model.put("itemType", Consts.LOADER_CELL_BLANK);
				//model.put("itemValue", cell.getBooleanCellValue());
				model.put("itemValue", "");
				break;
			case Cell.CELL_TYPE_ERROR:     
				model.put("itemType", Consts.LOADER_CELL_ERROR);
				//model.put("itemValue", cell.getErrorCellValue());
				model.put("itemValue", "");
				break;
			default: 
				model.put("itemType", Consts.LOADER_CELL_DEFAULT);
				model.put("itemValue", cell.getStringCellValue());
				break;
		}
		return model;
	}
	
	private Sheet readSheet(MultipartFile file) throws IOException {
		
		if (file == null)
			throw new SystemException("업로드한 파일이 없습니다.");
		
		String filename = file.getOriginalFilename();
		String extension = FileUtils.getFileExtension(filename);
		Workbook workbook = null;
		
		if ("xls".equals(extension)) {
			workbook = new HSSFWorkbook(file.getInputStream());
		}
		else if ("xlsx".equals(extension)) {
			workbook = new XSSFWorkbook(file.getInputStream());
		}
		else {
			throw new SystemException("파일이 형식이 엑셀파일이 아닙니다.");
		}

		if (workbook.getNumberOfSheets() == 0)
			throw new SystemException("엑셀파일에 Sheet가 존재하지 않습니다.");
		
		//sheets 별 처리시 필요함 (현재사용안함)
		//int sheets = workbook.getNumberOfSheets();
		//for (int i = 0; i < sheets; i++) {
		//	Sheet sheet = workbook.getSheetAt(i);
		//}

		//첫번째 Sheet
		return workbook.getSheetAt(0);
	}

/**
 * JXL 라이브러리 이용시 샘플
 * 
import jxl.Cell;
import jxl.CellType;
import jxl.Image;
import jxl.Sheet;
import jxl.Workbook;

public List readJxlExcel(String excelFile, String[] excelKeys, boolean isPicture) {
	
	List list    = null;
	int startRow = 1;
	int imgRow   = 0;
	try {
		Workbook workbook = Workbook.getWorkbook(new File(excelFile));// 엑셀파일
		Sheet sheet = workbook.getSheet(0);

		if (sheet == null || sheet.getRows() <2)
			throw new BusinessException("처리할 데이터가 없습니다.");
		
		if (sheet.getRows() > MAXROW)
			throw new BusinessException("처리할 수 있는 최대 건수는 "+MAXROW+"건입니다.");

		int keyCnt = excelKeys.length;
		
		list = new ArrayList();
		//행 LOOP
		for (int row=startRow; row<sheet.getRows(); row++) {
			
			//KEY가 빈값이면 STOP
			Cell keyCell = sheet.getCell(2, row); 
			if (keyCell == null ||
				keyCell.getContents() == null ||
				"".equals(keyCell.getContents()))
				break;
			
			//열 LOOP
			Map item = new HashMap();
			int col  = 0;
			for (Cell cell: sheet.getRow(row)) {
				col = cell.getColumn();
				//정의된 열수를 넘어가면 STOP
				if (col >= keyCnt)
					break;
				//정의된 열이름이 없으면 SKIP
				if ("".equals(excelKeys[col]))
					continue;
				
				if (cell.getType() == CellType.NUMBER ||
					cell.getType() == CellType.NUMBER_FORMULA)
					item.put(excelKeys[col], CommonUtils.replace(cell.getContents(), ",", ""));
				else
					item.put(excelKeys[col], cell.getContents());
			}
			list.add(item);
		}

		//이미지 미포함시
		if (!isPicture)
			return list;
		
		//이미지 LOOP
		String imgDir = FileManager.getUploadDir("picture"); 
		String imgUrl = FileManager.getUploadUrl("picture");
		int imgCnt = sheet.getNumberOfImages();
		int lstCnt = list.size();
		
		for (int i = 0; i < imgCnt; i++) {
			Image img = sheet.getDrawing(i);
			imgRow = (int)img.getRow();
			
			//데이터행수를 넘어가면 STOP
			if (lstCnt < imgRow)
				break;

			//이미지 사이즈 체크
			if (img == null ||
				img.getImageData() == null ||
				img.getImageData().length == 0)
				continue;
			
			
			//해당 행을 가져온다.
			Map item = (Map)list.get(imgRow-startRow);
			//이미지 파일 생성
			String s = (String)item.get("partNo") + ".png";
			File   f = new File(imgDir + s);
			
			if (f.exists() && f.isFile())
				f.delete();
			
			FileUtils.writeByteArrayToFile(f, img.getImageData());
			item.put("picture", imgUrl+s);
		}

	}
	catch (BusinessException be) {
		throw(be);
	}
	catch (Exception e) {
		e.printStackTrace();
		throw new BusinessException(e.getMessage());
	}
	return list;
}
EMPTY
NUMBER
NUMBER_FORMULA
ERROR
BOOLEAN
DATE
LABEL
BOOLEAN_FORMULA
DATE_FORMULA
STRING_FORMULA
FORMULA_ERROR
*/
	
}
