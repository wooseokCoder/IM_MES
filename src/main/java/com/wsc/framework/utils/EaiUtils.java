package com.wsc.framework.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import com.inspien.service.client.Context;
import com.wm.app.b2b.client.ServiceException;
import com.wm.app.b2b.util.GenUtil;
import com.wm.data.IData;
import com.wm.data.IDataCursor;
import com.wm.data.IDataFactory;

public class EaiUtils {
	public static void Cont() {
        // Connect to server - edit for alternate server
        String  server = "lgceapr1:5520";
        Context context = null;

        // Set username and password for protected services
        String username = null;
        String password = null;

        try {
            //context.connect(server, username, password); //--baek 주석처리
        	context = new Context();
			context.connect("DEV"); //--baek 추가
			context.setTableGenerationType(2); //--baek 추가
			System.out.println("context,"+context);
        } catch (ServiceException e) {
            System.out.println("\n\tCannot connect to server \""+server+"\"");
        } catch (Exception e) {
        	e.printStackTrace();
        }
        
       try
        {
        // Collect inputs (top-level only)
	    IData inputDocument = getInputs();
        
            // *** Invoke the Service and Disconnect ***
            IData outputDocument = invoke(context, inputDocument);
            context.disconnect();
            System.out.println("\n********* Successful invoke **********");

            // *** Access the Results ***
            System.out.println("\n************* Inputs *****************");
            GenUtil.printRec(inputDocument, "Input");
            
            System.out.println("\n************* Outputs *****************");
            GenUtil.printRec(outputDocument, "Output");
            
        } catch (IOException e) {
            System.err.println(e);
        } catch (ServiceException e) {
            System.err.println(e);
        }
	}
	
    
    // *** Collect Inputs *** //
    public static IData getInputs() throws IOException, ServiceException {
       return Input_getInputs();
    }


    public static IData Output_getInputs()
         throws IOException, ServiceException
    {
         IData out = IDataFactory.create();
         IDataCursor idc = out.getCursor();
         idc.insertAfter("E_RESULT", getString("E_RESULT"));
         idc.insertAfter("E_MESSAGE", getString("E_MESSAGE"));

         IData[] OutDoc = new IData[1];
         OutDoc[0] = SD_OrderConfirmList_docs_ET_ZSDS021_getInputs();
         idc.insertAfter("OutDoc", OutDoc);
         idc.destroy();
         return out;
    }

    public static IData SD_OrderConfirmList_docs_ET_ZSDS021_getInputs()
         throws IOException, ServiceException
    {
         IData out = IDataFactory.create();
         IDataCursor idc = out.getCursor();
         idc.insertAfter("VBELN", getString("VBELN"));
         idc.insertAfter("POSNR", getString("POSNR"));
         idc.insertAfter("ETENR", getString("ETENR"));
         idc.insertAfter("MATNR", getString("MATNR"));
         idc.insertAfter("ARKTX", getString("ARKTX"));
         idc.insertAfter("KWMENG", getString("KWMENG"));
         idc.insertAfter("BMENG", getString("BMENG"));
         idc.insertAfter("VRKME", getString("VRKME"));
         idc.insertAfter("NETWR", getString("NETWR"));
         idc.insertAfter("WAERK", getString("WAERK"));
         idc.insertAfter("ZZCOLOR_BASE", getString("ZZCOLOR_BASE"));
         idc.insertAfter("BSTNK", getString("BSTNK"));
         idc.insertAfter("KUNNR", getString("KUNNR"));
         idc.insertAfter("NAME1", getString("NAME1"));
         idc.insertAfter("KUNAG", getString("KUNAG"));
         idc.insertAfter("NAME2", getString("NAME2"));
         idc.insertAfter("AUDAT", getString("AUDAT"));
         idc.insertAfter("EDATU", getString("EDATU"));
         idc.insertAfter("NETPR", getString("NETPR"));
         idc.insertAfter("NETPR2", getString("NETPR2"));
         idc.insertAfter("CUOBJ", getString("CUOBJ"));
         idc.insertAfter("VALUE1", getString("VALUE1"));
         idc.insertAfter("VALUE2", getString("VALUE2"));
         idc.destroy();
         return out;
    }

    public static IData Input_getInputs() throws IOException, ServiceException
    {
         IData out = IDataFactory.create();
         IDataCursor idc = out.getCursor();
         idc.insertAfter("I_DATE_GUBN", getString("I_DATE_GUBN"));
         idc.insertAfter("I_FR_DATE", getString("I_FR_DATE"));
         idc.insertAfter("I_KUNNR", getString("I_KUNNR"));
         idc.insertAfter("I_TO_DATE", getString("I_TO_DATE"));
         idc.destroy();
         return out;
    }

    public static String getString(String name)
         throws IOException, ServiceException
    {
         System.out.print(name + " =");
         return "INPUT";
    }

    public static String[] getStringArray(String name)
         throws IOException, ServiceException
    {
         int size;
         String tmp;
         System.out.print(name + ": how large? ");
         tmp = "INPUT";
         size = Integer.parseInt(tmp);

         String[] strArray = new String[size];

         for(int i = 0; i < size; i++){
	     strArray[i] = getString(name +"[" + i + "]");
         }

         return strArray;
    }

    public static String[][] getStringTable(String name)
         throws IOException, ServiceException
    {
         int rows = 0, cols = 0;
         String tmp;
         System.out.print(name + ": how many rows? ");
         tmp = "INPUT";
         rows = Integer.parseInt(tmp);

         System.out.print(name + ": how many cols? ");
         tmp = "INPUT";
         cols = Integer.parseInt(tmp);

         String[][] strTable = new String[rows][cols];

         for(int i = 0; i < rows; i++){
             for(int j = 0; j < cols; j++){
                  strTable[i][j] = getString(name+"["+i+"]["+j+"]");
             }
         }

         return strTable;
    }

    public static IData invoke(
        Context context, IData inputDocument)
        throws IOException, ServiceException
    {
         IData out = context.invoke("SD.TaxList", "OrderConfirmList_SrcES_TgtSP", inputDocument);
         IData outputDocument = out;
         return outputDocument;
    }
}
