package com.wsc.common.model;

import java.util.UUID;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;

import com.wsc.common.file.FileDirectory;
import com.wsc.framework.base.BaseModel;
import com.wsc.framework.utils.BaseUtils;

@JsonIgnoreProperties({"bytes"})
public class FileInfo extends BaseModel {

	private static final long serialVersionUID = -3406433425698409174L;

	private String fileName;
	private String fileType;
	private String saveName;
	private String filePath;
	private String fileNo;
	private String atchNo;
	private String atchGrup;
	private String comment;
	
	private boolean upload = true;
	private boolean exist  = false;
	private long fileSize;
	private byte[] bytes;
	private int index;
	private FileDirectory directory;

	public String getPhysicalRealName() {
		return directory.getRealName(getSaveName());
	}
	public String getPhysicalTempName() {
		return directory.getTempName(getSaveName());
	}
	public String getPhysicalFileName() {
		return directory.getRealName(getFileName());
	}
	public String getPhysicalImageName() {
		return directory.getImageName(getSaveName());
	}
	
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public byte[] getBytes() {
		return bytes;
	}
	public void setBytes(byte[] bytes) {
		this.bytes = bytes;
	}
	public String getSaveName() {
		return saveName;
	}
	public void setSaveName(String saveName) {
		this.saveName = saveName;
	}
	public boolean isUpload() {
		return upload;
	}
	public void setUpload(boolean upload) {
		this.upload = upload;
	}
	public long getFileSize() {
		return fileSize;
	}
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getFileNo() {
		return fileNo;
	}
	public void setFileNo(String fileNo) {
		this.fileNo = fileNo;
	}
	public String getAtchNo() {
		return atchNo;
	}
	public void setAtchNo(String atchNo) {
		this.atchNo = atchNo;
	}
	public String getAtchGrup() {
		return atchGrup;
	}
	public void setAtchGrup(String atchGrup) {
		this.atchGrup = atchGrup;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public int getIndex() {
		return index;
	}
	public void setIndex(int index) {
		this.index = index;
	}

	public boolean isExist() {
		return exist;
	}

	public void setExist(boolean exist) {
		this.exist = exist;
	}
	public FileDirectory getDirectory() {
		return directory;
	}
	public void setDirectory(FileDirectory directory) {
		this.directory = directory;
	}
	public void setAtchDirectory() {
		if (this.atchGrup != null)
			this.directory = FileDirectory.get(this.atchGrup);
	}

	//파일업로드시 고유파일명 생성
	public void setRandomName(String fileType) {
		UUID uuid = UUID.randomUUID();
		//return System.currentTimeMillis() +"_" + uuid.toString() + ".upl";
		/*this.saveName = BaseUtils.formatCurDate("yyyyMMdd") +"_" + uuid.toString() + ".upl";*/
		this.saveName = BaseUtils.formatCurDate("yyyyMMdd") +"_" + uuid.toString() + "."+fileType;
		
	}
}
