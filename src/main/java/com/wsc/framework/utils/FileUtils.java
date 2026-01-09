package com.wsc.framework.utils;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.Assert;

/**
 * File processing utilities.
 *
 * @author comart
 *
 */
public class FileUtils {

    /**
     * Logging output for this class.
     */
    protected static final Log log = LogFactory.getLog(FileUtils.class);

    public static final int BUFFER_SIZE = 4096;

    /**
     * Wrapper of File.mkdirs() for safe.
     * 
     * 
     * @param path
     * @return
     * @see java.io.File#mkdirs()
     */
	public static boolean mkdirs(String path) {
		if (path == null)
			return false;
		File dpath = new File(path);
		
		if (dpath.exists()) {
			return dpath.isDirectory();
		} else {
			return dpath.mkdirs();
		}
	}
	
    /**
	 * Remove file or directory recursively.
	 *
	 * @param path		file or directory path to be removed.
	 */
	public static void rmdir(String path) {
		if (path != null && !"".equals(path))
			rmdir(new File(path));
	}
	
	/**
	 * Remove file or directory recursively.
	 * 
	 * @param f			<code>File</code> object to be removed.
	 */
	public static void rmdir(File f) {
		if (f != null && f.exists()) {
			if (f.isDirectory()) {
				for (File c:f.listFiles()) {
					String nm = c.getName(); 
					if (!".".equals(nm) && !"..".equals(nm))
							rmdir(c);
				}
			}
			f.delete();
		}
	}

	/**
	 * 지정된 파일의 위치를 옮긴다.
	 *
	 * @param fromFile 원본 위치
	 * @param toFile 대상 위치
	 *
	 */
    public static void moveFile(String fromFile, String toFile) {
        if( StringUtils.isNotBlank(toFile)){
        	String replacedPath = replacePathToSlash(toFile);
        	mkdirs(replacedPath.substring(0, replacedPath.lastIndexOf("/")));
        }
        else{
        	throw new RuntimeException("Given target file path is blank. Thus can't move source file.");
        }

        copyFile(fromFile, toFile);
        deleteFile(fromFile);
    }

    /**
     * 파일을 복사한다. 대상 파일이 이미 존재하는 경우, 런타임 예외를 발생시킨다.
     *
     * @param fromFile 원본 파일
     * @param toFile 대상 파일
     */
    public static void copyFile(String fromFile, String toFile) {
    	FileInputStream fis = null;
    	FileOutputStream fos = null;
        try {
        	if(new File(toFile).exists()){ // 대상 파일이 이미 존재하면 예외 처리
        		throw new RuntimeException("Given target file exist already. : " + toFile);
        	}

            //retrieve the file data
        	fis = new FileInputStream(fromFile);
            fos = new FileOutputStream(toFile);

            byte[] buffer = new byte[BUFFER_SIZE];
            int bytesRead = 0;

            while ((bytesRead = fis.read(buffer, 0, BUFFER_SIZE)) != -1) {
                fos.write(buffer, 0, bytesRead);
            }
        } catch (FileNotFoundException fnfe) {
            throw new RuntimeException(fnfe);
        } catch (Exception ioe) {
        	throw new RuntimeException(ioe);
        } finally {
            //close the stream
        	try { fis.close(); } catch(Exception ignored) {}
        	try { fos.close(); } catch(Exception ignored) {}
        }
    }

    /**
     * 파일을 복사한다.
     *
     * @param in byte[] 복사할 원본의 바이너리
     * @param outPathName String 목표 파일명
     * @throws IOException
     */
	public static void copyFile(byte[] in, String outPathName) throws IOException {
		Assert.notNull(in, "No input byte array specified");
		File out = new File(outPathName);
		copyFile(in, out);
	}

	/**
	 * 파일을 복사한다.
	 *
	 * @param in byte[]
	 * @param out File
	 * @throws IOException
	 */
	public static void copyFile(byte[] in, File out) throws IOException {
		Assert.notNull(in, "No input byte array specified");
		Assert.notNull(out, "No output File specified");
		if( out.exists() ){
			throw new RuntimeException("Given target file exist already. : " + out.getPath());
		}
		ByteArrayInputStream inStream = new ByteArrayInputStream(in);

		String replacedPath = replacePathToSlash(out.getPath());
		mkdirs(replacedPath.substring(0, replacedPath.lastIndexOf("/")));

		OutputStream outStream = new BufferedOutputStream(new FileOutputStream(out));
		try {
			copyFile(inStream, outStream);
		} finally {
			try { inStream.close(); } catch(Throwable ignored) {}
			try { outStream.close(); } catch(Throwable ignored) {}
		}
	}

	/**
	 * 파일을 복사한다.
	 *
	 * @param in InputStream
	 * @param out OutputStream
	 * @return
	 * @throws IOException
	 */
	public static int copyFile(InputStream in, OutputStream out) throws IOException {
		Assert.notNull(in, "No InputStream specified");
		Assert.notNull(out, "No OutputStream specified");

		int byteCount = 0;
		byte[] buffer = new byte[BUFFER_SIZE];
		int bytesRead = -1;
		while ((bytesRead = in.read(buffer)) != -1) {
			out.write(buffer, 0, bytesRead);
			byteCount += bytesRead;
		}
		out.flush();
		return byteCount;
	}

	/**
	 * 지정된 파일을 삭제한다.
	 *
	 * @param fullFilePath 파일 위치 문자열
	 */
    public static void deleteFile(String fullFilePath) {
        File file = new File(fullFilePath);

        try {
            if (file.exists()) {
                file.delete();
            }
            else{
            	log.debug("Given path's file do not exist. : " + fullFilePath);
            }
        } catch (SecurityException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 파일이나 디렉터리 명을 "/"(슬래시)기반으로 변경하여 반환.
     *
     * @param path 변경할 패스 문자열
     * @return
     */
    public static String replacePathToSlash(String path){
    	return (StringUtils.isBlank(path)) ?
    			path :
    			path.replaceAll("[\\\\]+", "/").replaceAll("[/]{2,}", "/");
    }

    /**
     * Zip 압축파일 풀기
     * [JAVA UTIL ZIP로   압축풀기용]
     * ntarget - 2011-03-04
     * @param string
     * @param dmMonthPath
     */
    @SuppressWarnings("rawtypes")
	public static void unzipFile(String fromFile, String toPath) {

		// build target directories.
		mkdirs(toPath);

		ZipFile zipFile = null;

		try {
            zipFile 		= new ZipFile(fromFile);
            Enumeration e 	= zipFile.entries();

            while( e.hasMoreElements() ) {
                ZipEntry zipEntry 	= (ZipEntry)e.nextElement();
                String strEntry 	= zipEntry.getName();
                int startIndex 		= 0;
                int endIndex 		= 0;
                boolean isDirectory = false;

                // create sub directory if not exists.
                while(true) {
                    endIndex = strEntry.indexOf("/", startIndex);

                    if(endIndex != -1 ) {
                        String strDirectory	= strEntry.substring(0, endIndex);
                        File fileDirectory 	= new File(toPath + strDirectory);

                        if( fileDirectory.exists() == false ) {
                            fileDirectory.mkdir();
                        }
                        startIndex = endIndex+1;
                    } else {
                        break;
                    }

                    if( endIndex+1 == strEntry.length() ) {
                        isDirectory = true;
                    }
                }

                // Directory가 아니면 파일생성.
                if( isDirectory == false ) {
                    InputStream is = zipFile.getInputStream(zipFile.getEntry(strEntry));
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    byte[] byteBuffer = new byte[1024];
                    byte[] byteData = null;
                    FileOutputStream fos = null;
                    int nLength = 0;

                    while( (nLength=is.read(byteBuffer))>0 ) {
                        baos.write(byteBuffer, 0, nLength);
                    }
                    is.close();

                    byteData = baos.toByteArray();
                    fos = new FileOutputStream(toPath + strEntry);
                    fos.write(byteData);
                    fos.close();
                }
            }
        } catch(IOException e) {
        	e.printStackTrace();
        } finally {
            if( zipFile != null ) {
            	try {
					zipFile.close();
					zipFile = null;
				} catch (IOException e) {
					e.printStackTrace();
				}
            }
        }
	}

    /**
     * Zip 압축파일 풀기
     * [UNIX, LINUX 명령어로 압축풀기용]
     * ntarget - 2011-03-04
     * @param string
     * @param dmMonthPath
     */
	public static void unzipFileUnix(String fromFile, String toPath) {
		String cmd = "";

		if (toPath != null && !"".equals(toPath)) {
			//디렉토리 생성
			FileUtils.mkdirs(toPath);

			cmd = "unzip -o "+ fromFile + " -d " + toPath;
		} else {
			cmd	= "unzip -o "+ fromFile;
		}

		try {
            Runtime rt = Runtime.getRuntime();
            Process procs = rt.exec(cmd);
            procs.waitFor();
        } catch (Exception e) {
            e.printStackTrace();
        }
	}

	public static List<String> readFile(String fileName) {
		List<String> list = null;
		FileReader fr = null;
		BufferedReader br = null;
		try {
			fr = new FileReader(fileName);
			br=new BufferedReader(fr);
			String s = "";
			
			list = new ArrayList<String>();
			//한 행씩 읽기
			while((s=br.readLine()) != null) {
				list.add(s);
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try { br.close(); } catch (Exception ignored) {}
		}
		return list;
	}
	
	public static String getFileName(String filePath, String fileName) {
		
		if (filePath == null)
			filePath = "";
		
		if (filePath.endsWith("/"))
			return replacePathToSlash(filePath) + fileName;
		
		return replacePathToSlash(filePath)+"/"+fileName;
	}
	
	public static String getFilePrefix(String fileName) {
		if (fileName == null)
			return null;
		if (fileName.lastIndexOf(".") < 0)
			return fileName;
		return fileName.substring(0, fileName.lastIndexOf("."));
	}
	
	public static String getFileExtension(String fileName) {
		if (fileName == null)
			return null;
		if (fileName.lastIndexOf(".") < 0)
			return "";
		return fileName.substring(fileName.lastIndexOf(".")+1);
	}
	
	public static String mergePath(String path1, String path2) {
		
		if (path2 == null)
			return path1;
		
		path1 = replacePathToSlash(path1);
		path2 = replacePathToSlash(path2);
		
		String path = path1 + "/" + path2;
		
		return replacePathToSlash(path);
	}
}
