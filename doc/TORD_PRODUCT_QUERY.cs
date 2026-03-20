using System;
using System.Data;
using System.Diagnostics;
using System.Text;
using BizExecute;

namespace DORD;

public class TORD_PRODUCT_QUERY
{
	public static DataTable TORD_PRODUCT_QUERY1(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append("  SELECT  ");
				stringBuilder.Append("  P.PLT_CODE ");
				stringBuilder.Append(" ,P.PROD_CODE ");
				stringBuilder.Append(" ,SAP.ORDER_NO + '-' + convert(nvarchar(5),SAP.ORDER_LINE) AS SAP_CODE ");
				stringBuilder.Append(" ,P.PROD_SEND_FLAG ");
				stringBuilder.Append(" ,P.REV_SEND_FLAG ");
				stringBuilder.Append(" ,P.PROD_MONTH ");
				stringBuilder.Append(" ,P.PROD_STATE ");
				stringBuilder.Append(" ,P.PROD_TYPE ");
				stringBuilder.Append(" ,P.PROD_GOLE ");
				stringBuilder.Append(" ,P.SALE_MONTH ");
				stringBuilder.Append(" ,M.MODEL_TYPE_SAP ");
				stringBuilder.Append(" ,P.MODEL_TYPE ");
				stringBuilder.Append(" ,P.MODEL_SERISE ");
				stringBuilder.Append(" ,P.MODEL_NO ");
				stringBuilder.Append(" ,P.MODEL_TON ");
				stringBuilder.Append(" ,P.INOUT_FLAG ");
				stringBuilder.Append(" ,P.SHIP_COUNTRY ");
				stringBuilder.Append(" ,P.ORDER_FLAG ");
				stringBuilder.Append(" ,P.ORDER_FLAG2 ");
				stringBuilder.Append(" ,P.GAORDER_NO ");
				stringBuilder.Append(" ,P.GAORDER_LINE ");
				stringBuilder.Append(" ,P.JINORDER_NO ");
				stringBuilder.Append(" ,P.JINORDER_LINE ");
				stringBuilder.Append(" ,ISNULL(P.ORDER_NO,'') AS ORDER_NO ");
				stringBuilder.Append(" ,ISNULL(P.ORDER_LINE,'') AS ORDER_LINE ");
				stringBuilder.Append(" ,P.PROD_HOGI ");
				stringBuilder.Append(" ,P.PART_CODE ");
				stringBuilder.Append(" ,P.ST_CODE ");
				stringBuilder.Append(" ,P.CVND_CONTENTS ");
				stringBuilder.Append(" ,P.PROD_SEND_DATE ");
				stringBuilder.Append(" ,P.DUE_DATE ");
				stringBuilder.Append(" ,P.INDUE_DATE ");
				stringBuilder.Append(" ,P.DUE_SEND ");
				stringBuilder.Append(" ,P.ORD_DATE ");
				stringBuilder.Append(" ,P.PROD_WEEK ");
				stringBuilder.Append(" ,P.MAIN_PROD ");
				stringBuilder.Append(" ,P.LAST_MONTH ");
				stringBuilder.Append(" ,P.NEXT_MONTH ");
				stringBuilder.Append(" ,P.YEAR_WEEK ");
				stringBuilder.Append(" ,P.MONTH_WEEK ");
				stringBuilder.Append(" ,P.INDUE_WEEK ");
				stringBuilder.Append(" ,P.INDUE_MONTH_WEEK ");
				stringBuilder.Append(" ,P.SHIP_PLAN_DATE ");
				stringBuilder.Append(" ,P.PLAN_RATE ");
				stringBuilder.Append(" ,P.PLAN_EMP_RATE ");
				stringBuilder.Append(" ,P.SCOMMENT ");
				stringBuilder.Append(" ,P.OLD_ORDER_NO ");
				stringBuilder.Append(" ,P.OLD_ORDER_LINE ");
				stringBuilder.Append(" ,P.APRTS_DATE ");
				stringBuilder.Append(" ,P.CTRL_DATE ");
				stringBuilder.Append(" ,P.PLAZA_DATE ");
				stringBuilder.Append(" ,P.OLD_ORDER_NO ");
				stringBuilder.Append(" ,P.OLD_ORDER_LINE ");
				stringBuilder.Append(" ,P.REG_DATE ");
				stringBuilder.Append(" ,P.REG_EMP ");
				stringBuilder.Append(" ,P.MDFY_DATE ");
				stringBuilder.Append(" ,P.MDFY_EMP ");
				stringBuilder.Append(" ,SAP.ORDER_NO AS SAP_ORDER_NO ");
				stringBuilder.Append(" ,SAP.ORDER_LINE AS SAP_ORDER_LINE ");
				stringBuilder.Append(" ,SAP.DUE_DATE AS SAP_DUE_DATE ");
				stringBuilder.Append(" ,SAP.PART_CODE AS SAP_PART_CODE ");
				stringBuilder.Append(" ,SAP.PART_NAME AS SAP_PART_NAME ");
				stringBuilder.Append(" ,SAP.CUSTOMER ");
				stringBuilder.Append(" ,SAP.DELIVERY ");
				stringBuilder.Append(" ,SAP.BUSINESS_EMP ");
				stringBuilder.Append(" ,E.EMP_NAME AS BUSINESS_EMP_NAME ");
				stringBuilder.Append(" ,SAP.ORDER_QTY ");
				stringBuilder.Append(" ,SAP.ORDER_AMT ");
				stringBuilder.Append(" ,SAP.UNIT_COST ");
				stringBuilder.Append(" ,SAP.CURR_UNIT ");
				stringBuilder.Append(" ,SAP.ORDER_INPUT ");
				stringBuilder.Append(" ,SAP.SHIP_DATE ");
				stringBuilder.Append(" ,SAP.DENY_REASON ");
				stringBuilder.Append(" ,SAP.SHIP_DATE ");
				stringBuilder.Append(" ,P.SIM_FLAG ");
				stringBuilder.Append(" ,SAP.PLANTS ");
				stringBuilder.Append(" , (SELECT SUM(ST_TIME) FROM TORD_ST_PROC WHERE PLT_CODE = P.PLT_CODE AND PART_CODE = P.PART_CODE AND ST_CODE = P.ST_CODE) AS ST_TIME");
				stringBuilder.Append(" , (SELECT SUM(ST_TIME) FROM TORD_ST_PROC WHERE PLT_CODE = P.PLT_CODE AND PART_CODE = P.PART_CODE AND ST_CODE = P.ST_CODE) - ISNULL(LAST_MONTH,0) - ISNULL(NEXT_MONTH,0) AS NOW_MONTH");
				stringBuilder.Append(" ,ISNULL(P.PLN_SAP_SEND_FLAG,'0') AS  PLN_SAP_SEND_FLAG");
				stringBuilder.Append(" ,CASE WHEN SPC.ORDER_NO IS NULL AND SPC2.ORDER_NO IS NULL THEN '0' ELSE '1' END AS IS_SPEC");
				stringBuilder.Append(" ,CASE WHEN SPC.ORDER_NO IS NULL  AND SPC2.ORDER_NO IS NULL THEN '0' ELSE '1' END AS IS_SPEC2");
				stringBuilder.Append("  FROM TORD_PRODUCT P ");
				stringBuilder.Append("  LEFT JOIN IF_SAP_SHIPINFO SAP WITH(NOLOCK) ");
				stringBuilder.Append("  ON P.ORDER_NO = SAP.ORDER_NO ");
				stringBuilder.Append("  AND P.ORDER_LINE = SAP.ORDER_LINE ");
				stringBuilder.Append(" LEFT JOIN TSTD_EMPLOYEE E");
				stringBuilder.Append(" ON SAP.BUSINESS_EMP = E.EMP_CODE");
				stringBuilder.Append("  LEFT JOIN TSTD_MODEL M ");
				stringBuilder.Append("  ON P.PLT_CODE = M.PLT_CODE ");
				stringBuilder.Append("  AND P.MODEL_TYPE = M.MODEL_TYPE ");
				stringBuilder.Append("  AND P.MODEL_SERISE = M.MODEL_SERISE ");
				stringBuilder.Append("  AND P.MODEL_NO = M.MODEL_NO ");
				stringBuilder.Append("  LEFT JOIN (SELECT ORDER_NO FROM IF_SAP_SPEC WITH(NOLOCK) GROUP BY ORDER_NO) SPC ");
				stringBuilder.Append("  ON P.ORDER_NO = SPC.ORDER_NO ");
				stringBuilder.Append("  LEFT JOIN (SELECT ORDER_NO FROM IF_SAP_SPEC_HEADER WITH(NOLOCK) GROUP BY ORDER_NO) SPC2 ");
				stringBuilder.Append("  ON P.ORDER_NO = SPC2.ORDER_NO ");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_NO", "P.ORDER_NO = @ORDER_NO "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LINE", "P.ORDER_LINE = @ORDER_LINE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LIKE", "P.ORDER_NO LIKE '%' + @ORDER_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_HOGI", "P.PROD_HOGI = @PROD_HOGI "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@DATA_FLAG", "P.DATA_FLAG = @DATA_FLAG "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_PROD_MONTH, @E_PROD_MONTH", "P.PROD_MONTH BETWEEN @S_PROD_MONTH AND @E_PROD_MONTH "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_REG_DATE, @E_REG_DATE", "ISNULL(SAP.CRE_DATE,CONVERT(nvarchar(8),P.REG_DATE,112)) BETWEEN @S_REG_DATE AND @E_REG_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_DUE_DATE, @E_DUE_DATE", "P.DUE_DATE BETWEEN @S_DUE_DATE AND @E_DUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_INDUE_DATE, @E_INDUE_DATE", "P.INDUE_DATE BETWEEN @S_INDUE_DATE AND @E_INDUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_ORD_DATE, @E_ORD_DATE", "P.ORD_DATE BETWEEN @S_ORD_DATE AND @E_ORD_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_SHIP_DATE, @E_SHIP_DATE", "SAP.SHIP_DATE BETWEEN @S_SHIP_DATE AND @E_SHIP_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_DEL_DATE, @E_DEL_DATE", "CONVERT(nvarchar(8),P.DEL_DATE,112) BETWEEN @S_DEL_DATE AND @E_DEL_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_CODE", "P.PROD_CODE = @PROD_CODE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@HOGI_LIKE", "P.PROD_HOGI LIKE '%' + @HOGI_LIKE + '%'"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PART_LIKE", "P.PART_CODE LIKE '%' + @PART_LIKE + '%'"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@IS_NONE_SHIP", " SAP.SHIP_DATE IS NULL "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PLANTS", "SAP.PLANTS IN @PLANTS ", UTIL.SqlCondType.IN));
					stringBuilder2.Append(" ORDER BY  P.PROD_CODE ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY1_1(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append("  SELECT  ");
				stringBuilder.Append("  P.PLT_CODE ");
				stringBuilder.Append(" ,P.PROD_CODE ");
				stringBuilder.Append(" ,SAP.ORDER_NO + '-' + convert(nvarchar(5),SAP.ORDER_LINE) AS SAP_CODE ");
				stringBuilder.Append(" ,P.PROD_SEND_FLAG ");
				stringBuilder.Append(" ,P.REV_SEND_FLAG ");
				stringBuilder.Append(" ,P.PROD_MONTH ");
				stringBuilder.Append(" ,P.PROD_STATE ");
				stringBuilder.Append(" ,P.PROD_TYPE ");
				stringBuilder.Append(" ,P.PROD_GOLE ");
				stringBuilder.Append(" ,P.SALE_MONTH ");
				stringBuilder.Append(" ,M.MODEL_TYPE_SAP ");
				stringBuilder.Append(" ,P.MODEL_TYPE ");
				stringBuilder.Append(" ,P.MODEL_SERISE ");
				stringBuilder.Append(" ,P.MODEL_NO ");
				stringBuilder.Append(" ,P.MODEL_TON ");
				stringBuilder.Append(" ,P.INOUT_FLAG ");
				stringBuilder.Append(" ,P.SHIP_COUNTRY ");
				stringBuilder.Append(" ,P.ORDER_FLAG ");
				stringBuilder.Append(" ,P.ORDER_FLAG2 ");
				stringBuilder.Append(" ,P.GAORDER_NO ");
				stringBuilder.Append(" ,P.GAORDER_LINE ");
				stringBuilder.Append(" ,P.JINORDER_NO ");
				stringBuilder.Append(" ,P.JINORDER_LINE ");
				stringBuilder.Append(" ,P.ORDER_NO ");
				stringBuilder.Append(" ,P.ORDER_LINE ");
				stringBuilder.Append(" ,P.PROD_HOGI ");
				stringBuilder.Append(" ,P.PART_CODE ");
				stringBuilder.Append(" ,P.ST_CODE ");
				stringBuilder.Append(" ,P.CVND_CONTENTS ");
				stringBuilder.Append(" ,P.PROD_SEND_DATE ");
				stringBuilder.Append(" ,P.DUE_DATE ");
				stringBuilder.Append(" ,P.INDUE_DATE ");
				stringBuilder.Append(" ,P.DUE_SEND ");
				stringBuilder.Append(" ,P.ORD_DATE ");
				stringBuilder.Append(" ,P.PROD_WEEK ");
				stringBuilder.Append(" ,P.MAIN_PROD ");
				stringBuilder.Append(" ,P.LAST_MONTH ");
				stringBuilder.Append(" ,P.NEXT_MONTH ");
				stringBuilder.Append(" ,P.YEAR_WEEK ");
				stringBuilder.Append(" ,P.MONTH_WEEK ");
				stringBuilder.Append(" ,P.INDUE_WEEK ");
				stringBuilder.Append(" ,P.INDUE_MONTH_WEEK ");
				stringBuilder.Append(" ,P.SHIP_PLAN_DATE ");
				stringBuilder.Append(" ,P.PLAN_RATE ");
				stringBuilder.Append(" ,P.PLAN_EMP_RATE ");
				stringBuilder.Append(" ,P.SCOMMENT ");
				stringBuilder.Append(" ,P.APRTS_DATE ");
				stringBuilder.Append(" ,P.CTRL_DATE ");
				stringBuilder.Append(" ,P.PLAZA_DATE ");
				stringBuilder.Append(" ,P.REG_DATE ");
				stringBuilder.Append(" ,P.REG_EMP ");
				stringBuilder.Append(" ,P.MDFY_DATE ");
				stringBuilder.Append(" ,P.MDFY_EMP ");
				stringBuilder.Append(" ,SAP.ORDER_NO AS SAP_ORDER_NO ");
				stringBuilder.Append(" ,SAP.ORDER_LINE AS SAP_ORDER_LINE ");
				stringBuilder.Append(" ,SAP.DUE_DATE AS SAP_DUE_DATE ");
				stringBuilder.Append(" ,SAP.PART_CODE AS SAP_PART_CODE ");
				stringBuilder.Append(" ,SAP.PART_NAME AS SAP_PART_NAME ");
				stringBuilder.Append(" ,SAP.CUSTOMER ");
				stringBuilder.Append(" ,SAP.DELIVERY ");
				stringBuilder.Append(" ,SAP.BUSINESS_EMP ");
				stringBuilder.Append(" ,SAP.ORDER_QTY ");
				stringBuilder.Append(" ,SAP.ORDER_AMT ");
				stringBuilder.Append(" ,SAP.UNIT_COST ");
				stringBuilder.Append(" ,SAP.CURR_UNIT ");
				stringBuilder.Append(" ,SAP.ORDER_INPUT ");
				stringBuilder.Append(" ,SAP.SHIP_DATE ");
				stringBuilder.Append(" ,SAP.DENY_REASON ");
				stringBuilder.Append(" ,SAP.SHIP_DATE ");
				stringBuilder.Append(" , (SELECT SUM(ST_TIME) FROM TORD_ST_PROC WHERE PLT_CODE = P.PLT_CODE AND PART_CODE = P.PART_CODE AND ST_CODE = P.ST_CODE) AS ST_TIME");
				stringBuilder.Append(" , (SELECT SUM(ST_TIME) FROM TORD_ST_PROC WHERE PLT_CODE = P.PLT_CODE AND PART_CODE = P.PART_CODE AND ST_CODE = P.ST_CODE) - ISNULL(LAST_MONTH,0) - ISNULL(NEXT_MONTH,0) AS NOW_MONTH");
				stringBuilder.Append(" ,ISNULL(P.PLN_SAP_SEND_FLAG,'0') AS  PLN_SAP_SEND_FLAG");
				stringBuilder.Append(" ,CASE WHEN SPC.ORDER_NO IS NULL THEN '0' ELSE '1' END AS IS_SPEC");
				stringBuilder.Append(" ,CASE WHEN SPC.ORDER_NO IS NULL THEN '0' ELSE '1' END AS IS_SPEC2");
				stringBuilder.Append("  FROM TORD_PRODUCT P ");
				stringBuilder.Append("  JOIN IF_SAP_SHIPINFO SAP ");
				stringBuilder.Append("  ON P.ORDER_NO = SAP.ORDER_NO ");
				stringBuilder.Append("  AND P.ORDER_LINE = SAP.ORDER_LINE ");
				stringBuilder.Append("  LEFT JOIN TSTD_MODEL M ");
				stringBuilder.Append("  ON P.PLT_CODE = M.PLT_CODE ");
				stringBuilder.Append("  AND P.MODEL_TYPE = M.MODEL_TYPE ");
				stringBuilder.Append("  AND P.MODEL_SERISE = M.MODEL_SERISE ");
				stringBuilder.Append("  AND P.MODEL_NO = M.MODEL_NO ");
				stringBuilder.Append("  LEFT JOIN (SELECT ORDER_NO FROM IF_SAP_SPEC GROUP BY ORDER_NO) SPC ");
				stringBuilder.Append("  ON P.ORDER_NO = SPC.ORDER_NO ");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_NO", "P.ORDER_NO = @ORDER_NO "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LINE", "P.ORDER_LINE = @ORDER_LINE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LIKE", "P.ORDER_NO LIKE '%' + @ORDER_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_HOGI", "P.PROD_HOGI = @PROD_HOGI "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@DATA_FLAG", "P.DATA_FLAG = @DATA_FLAG "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_PROD_MONTH, @E_PROD_MONTH", "P.PROD_MONTH BETWEEN @S_PROD_MONTH AND @E_PROD_MONTH "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_REG_DATE, @E_REG_DATE", "ISNULL(SAP.CRE_DATE,CONVERT(nvarchar(8),P.REG_DATE,112)) BETWEEN @S_REG_DATE AND @E_REG_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_DUE_DATE, @E_DUE_DATE", "P.DUE_DATE BETWEEN @S_DUE_DATE AND @E_DUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_INDUE_DATE, @E_INDUE_DATE", "P.INDUE_DATE BETWEEN @S_INDUE_DATE AND @E_INDUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_ORD_DATE, @E_ORD_DATE", "P.ORD_DATE BETWEEN @S_ORD_DATE AND @E_ORD_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_SHIP_DATE, @E_SHIP_DATE", "SAP.SHIP_DATE BETWEEN @S_SHIP_DATE AND @E_SHIP_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_DEL_DATE, @E_DEL_DATE", "CONVERT(nvarchar(8),P.DEL_DATE,112) BETWEEN @S_DEL_DATE AND @E_DEL_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_CODE", "P.PROD_CODE = @PROD_CODE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@HOGI_LIKE", "P.PROD_HOGI LIKE '%' + @HOGI_LIKE + '%'"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PART_LIKE", "P.PART_CODE LIKE '%' + @PART_LIKE + '%'"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@IS_NONE_SHIP", " SAP.SHIP_DATE IS NULL "));
					stringBuilder2.Append(" ORDER BY  P.PROD_CODE ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY1_2(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append("  SELECT  ");
				stringBuilder.Append("  P.PLT_CODE ");
				stringBuilder.Append(" ,'' AS PROD_CODE ");
				stringBuilder.Append(" ,SAP.ORDER_NO + '-' + convert(nvarchar(5),SAP.ORDER_LINE) AS SAP_CODE ");
				stringBuilder.Append(" ,P.PROD_SEND_FLAG ");
				stringBuilder.Append(" ,P.REV_SEND_FLAG ");
				stringBuilder.Append(" ,P.PROD_MONTH ");
				stringBuilder.Append(" ,P.PROD_STATE ");
				stringBuilder.Append(" ,P.PROD_TYPE ");
				stringBuilder.Append(" ,P.PROD_GOLE ");
				stringBuilder.Append(" ,P.SALE_MONTH ");
				stringBuilder.Append(" ,P.MODEL_TYPE ");
				stringBuilder.Append(" ,P.MODEL_SERISE ");
				stringBuilder.Append(" ,P.MODEL_NO ");
				stringBuilder.Append(" ,P.MODEL_TON ");
				stringBuilder.Append(" ,P.INOUT_FLAG ");
				stringBuilder.Append(" ,P.SHIP_COUNTRY ");
				stringBuilder.Append(" ,P.ORDER_FLAG ");
				stringBuilder.Append(" ,P.ORDER_FLAG2 ");
				stringBuilder.Append(" ,P.GAORDER_NO ");
				stringBuilder.Append(" ,P.GAORDER_LINE ");
				stringBuilder.Append(" ,P.JINORDER_NO ");
				stringBuilder.Append(" ,P.JINORDER_LINE ");
				stringBuilder.Append(" ,SAP.ORDER_NO ");
				stringBuilder.Append(" ,CONVERT(int,SAP.ORDER_LINE) ORDER_LINE ");
				stringBuilder.Append(" ,P.PROD_HOGI ");
				stringBuilder.Append(" ,SAP.PART_CODE ");
				stringBuilder.Append(" ,P.ST_CODE ");
				stringBuilder.Append(" ,P.CVND_CONTENTS ");
				stringBuilder.Append(" ,P.PROD_SEND_DATE ");
				stringBuilder.Append(" ,SAP.DUE_DATE ");
				stringBuilder.Append(" ,P.INDUE_DATE ");
				stringBuilder.Append(" ,P.DUE_SEND ");
				stringBuilder.Append(" ,P.ORD_DATE ");
				stringBuilder.Append(" ,P.PROD_WEEK ");
				stringBuilder.Append(" ,P.MAIN_PROD ");
				stringBuilder.Append(" ,P.LAST_MONTH ");
				stringBuilder.Append(" ,P.NEXT_MONTH ");
				stringBuilder.Append(" ,P.YEAR_WEEK ");
				stringBuilder.Append(" ,P.MONTH_WEEK ");
				stringBuilder.Append(" ,P.INDUE_WEEK ");
				stringBuilder.Append(" ,P.INDUE_MONTH_WEEK ");
				stringBuilder.Append(" ,P.SHIP_PLAN_DATE ");
				stringBuilder.Append(" ,P.SCOMMENT ");
				stringBuilder.Append(" ,P.OLD_ORDER_NO ");
				stringBuilder.Append(" ,P.OLD_ORDER_LINE ");
				stringBuilder.Append(" ,P.APRTS_DATE ");
				stringBuilder.Append(" ,P.CTRL_DATE ");
				stringBuilder.Append(" ,P.PLAZA_DATE ");
				stringBuilder.Append(" ,P.REG_DATE ");
				stringBuilder.Append(" ,P.REG_EMP ");
				stringBuilder.Append(" ,P.MDFY_DATE ");
				stringBuilder.Append(" ,P.MDFY_EMP ");
				stringBuilder.Append(" ,SAP.ORDER_NO AS SAP_ORDER_NO ");
				stringBuilder.Append(" ,SAP.ORDER_LINE AS SAP_ORDER_LINE ");
				stringBuilder.Append(" ,SAP.DUE_DATE AS SAP_DUE_DATE ");
				stringBuilder.Append(" ,SAP.PART_CODE AS SAP_PART_CODE ");
				stringBuilder.Append(" ,SAP.PART_NAME AS SAP_PART_NAME ");
				stringBuilder.Append(" ,SAP.CUSTOMER ");
				stringBuilder.Append(" ,SAP.DELIVERY ");
				stringBuilder.Append(" ,SAP.BUSINESS_EMP ");
				stringBuilder.Append(" ,E.EMP_NAME AS BUSINESS_EMP_NAME ");
				stringBuilder.Append(" ,SAP.ORDER_QTY ");
				stringBuilder.Append(" ,SAP.ORDER_AMT ");
				stringBuilder.Append(" ,SAP.UNIT_COST ");
				stringBuilder.Append(" ,SAP.CURR_UNIT ");
				stringBuilder.Append(" ,SAP.ORDER_INPUT ");
				stringBuilder.Append(" ,SAP.SHIP_DATE ");
				stringBuilder.Append(" ,SAP.DENY_REASON ");
				stringBuilder.Append(" ,SAP.SHIP_DATE ");
				stringBuilder.Append(" ,P.SIM_FLAG ");
				stringBuilder.Append(" ,'0' AS IS_SPEC ");
				stringBuilder.Append(" ,CASE WHEN SPC.ORDER_NO IS NULL THEN '0' ELSE '1' END AS IS_SPEC2");
				stringBuilder.Append(" ,ISNULL(P.PLN_SAP_SEND_FLAG,'0') AS  PLN_SAP_SEND_FLAG");
				stringBuilder.Append(" ,SAP.PLANTS ");
				stringBuilder.Append("  FROM TORD_PRODUCT P ");
				stringBuilder.Append("  RIGHT JOIN IF_SAP_SHIPINFO SAP ");
				stringBuilder.Append("  ON  P.ORDER_NO = SAP.ORDER_NO ");
				stringBuilder.Append("  AND P.ORDER_LINE = SAP.ORDER_LINE ");
				stringBuilder.Append(" LEFT JOIN TSTD_EMPLOYEE E");
				stringBuilder.Append(" ON SAP.BUSINESS_EMP = E.EMP_CODE");
				stringBuilder.Append("  LEFT JOIN (SELECT ORDER_NO FROM IF_SAP_SPEC WITH(NOLOCK) GROUP BY ORDER_NO) SPC ");
				stringBuilder.Append("  ON SAP.ORDER_NO = SPC.ORDER_NO ");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE 1=1 ");
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_NO", "SAP.ORDER_NO = @ORDER_NO "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LINE", "SAP.ORDER_LINE = @ORDER_LINE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LIKE", "SAP.ORDER_NO LIKE '%' + @ORDER_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@DATA_FLAG", "SAP.DATA_FLAG = @DATA_FLAG "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_REG_DATE, @E_REG_DATE", "SAP.CRE_DATE BETWEEN @S_REG_DATE AND @E_REG_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_DUE_DATE, @E_DUE_DATE", "SAP.DUE_DATE BETWEEN @S_DUE_DATE AND @E_DUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_INDUE_DATE, @E_INDUE_DATE", "P.INDUE_DATE BETWEEN @S_INDUE_DATE AND @E_INDUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_ORD_DATE, @E_ORD_DATE", "P.ORD_DATE BETWEEN @S_ORD_DATE AND @E_ORD_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_SHIP_DATE, @E_SHIP_DATE", "SAP.SHIP_DATE BETWEEN @S_SHIP_DATE AND @E_SHIP_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_CODE", "P.PROD_CODE = @PROD_CODE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@HOGI_LIKE", "P.PROD_HOGI LIKE '%' + @HOGI_LIKE + '%'"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PART_LIKE", "SAP.PART_CODE LIKE '%' + @PART_LIKE + '%'"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PART_CODE_PROD", "LEFT(SAP.PART_CODE,1) = @PART_CODE_PROD"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PLANTS", "SAP.PLANTS IN @PLANTS ", UTIL.SqlCondType.IN));
					stringBuilder2.Append(" AND (SAP.ORDER_NO + '-' + convert(nvarchar(5), SAP.ORDER_LINE))  NOT IN(SELECT ISNULL(ORDER_NO,'') +'-' + ISNULL(convert(nvarchar(5), ORDER_LINE), '')  FROM TORD_PRODUCT WHERE DATA_FLAG = '0') ");
					stringBuilder2.Append(" ORDER BY  SAP.ORDER_NO + '-' + convert(nvarchar(5),SAP.ORDER_LINE) ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY2(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT P.PLT_CODE");
				stringBuilder.Append(" , P.PROD_CODE");
				stringBuilder.Append(" , P.ORDER_NO");
				stringBuilder.Append(" , P.ORDER_LINE");
				stringBuilder.Append(" , P.MODEL_TYPE");
				stringBuilder.Append(" , P.PROD_MONTH");
				stringBuilder.Append(" , P.PROD_GOLE");
				stringBuilder.Append(" , P.PROD_HOGI");
				stringBuilder.Append(" , SAP.CUSTOMER");
				stringBuilder.Append(" , P.MODEL_SERISE");
				stringBuilder.Append(" , P.MODEL_NO");
				stringBuilder.Append(" , P.PROD_SEND_DATE");
				stringBuilder.Append(" , SAP.DUE_DATE AS SAP_DUE_DATE");
				stringBuilder.Append(" , P.DUE_DATE");
				stringBuilder.Append(" , P.ORD_DATE");
				stringBuilder.Append(" , P.INDUE_DATE");
				stringBuilder.Append(" , P.SHIP_PLAN_DATE");
				stringBuilder.Append(" , M.PROD_TYPE");
				stringBuilder.Append(" , NULL AS DUE_YN");
				stringBuilder.Append(" , (SELECT MIN(PLN_START_TIME) FROM TSHP_WORKORDER WHERE PLT_CODE = P.PLT_CODE AND PROD_CODE = P.PROD_CODE) AS FIRST_ORDER_DATE ");
				stringBuilder.Append(" , (SELECT MAX(PLN_START_TIME) FROM TSHP_WORKORDER WHERE PLT_CODE = P.PLT_CODE AND PROD_CODE = P.PROD_CODE) AS LAST_ORDER_DATE ");
				stringBuilder.Append(" , P.SIM_FLAG");
				stringBuilder.Append(" , SAP.PLANTS");
				stringBuilder.Append(" , (SELECT SUM(ISNULL(PROC_RATE,0)) FROM TSHP_WORKORDER W");
				stringBuilder.Append(" LEFT JOIN TSTD_ST_GROUP SG");
				stringBuilder.Append(" ON W.PLT_CODE = SG.PLT_CODE");
				stringBuilder.Append(" AND W.PART_CODE = SG.PART_CODE");
				stringBuilder.Append(" AND SG.USE_FLAG = '1'");
				stringBuilder.Append(" AND SG.DATA_FLAG = '0'");
				stringBuilder.Append(" LEFT JOIN TSTD_ST_PROC SP");
				stringBuilder.Append(" ON SG.PLT_CODE = SP.PLT_CODE");
				stringBuilder.Append(" AND SG.ST_CODE = SP.ST_CODE");
				stringBuilder.Append(" AND W.PROC_CODE = SP.PROC_CODE");
				stringBuilder.Append(" AND SP.DATA_FLAG = '0'");
				stringBuilder.Append(" WHERE W.PLT_CODE = P.PLT_CODE AND W.PROD_CODE = P.PROD_CODE AND W.WO_FLAG = '4' AND W.DATA_FLAG = '0') AS WORK_RATE");
				stringBuilder.Append(" , P.SCOMMENT ");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" JOIN IF_SAP_SHIPINFO SAP ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE ");
				stringBuilder.Append(" LEFT JOIN (SELECT PLT_CODE, PROD_TYPE, MODEL_TYPE FROM TSTD_MODEL");
				stringBuilder.Append(" WHERE P_SCODE IS NULL");
				stringBuilder.Append(" AND DATA_FLAG = '0') M");
				stringBuilder.Append(" ON P.PLT_CODE = M.PLT_CODE");
				stringBuilder.Append(" AND P.MODEL_TYPE = M.MODEL_TYPE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_NO", "P.ORDER_NO = @ORDER_NO "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LINE", "P.ORDER_LINE = @ORDER_LINE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LIKE", "P.ORDER_NO LIKE '%' + @ORDER_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@DATA_FLAG", "P.DATA_FLAG = @DATA_FLAG "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_INDUE_DATE, @E_INDUE_DATE", "P.INDUE_DATE BETWEEN @S_INDUE_DATE AND @E_INDUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_DUE_DATE, @E_DUE_DATE", "P.DUE_DATE BETWEEN @S_DUE_DATE AND @E_DUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_ORD_DATE, @E_ORD_DATE", "P.ORD_DATE BETWEEN @S_ORD_DATE AND @E_ORD_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_PROD_MONTH, @E_PROD_MONTH", "P.PROD_MONTH BETWEEN @S_PROD_MONTH AND @E_PROD_MONTH "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_SHIP_DATE, @E_SHIP_DATE", "SAP.SHIP_DATE BETWEEN @S_SHIP_DATE AND @E_SHIP_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_CODE", "P.PROD_CODE = @PROD_CODE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@MODEL_LIKE", "P.MODEL_NO LIKE '%' + @MODEL_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@CUSTOMER_LIKE", "SAP.CUSTOMER LIKE '%' + @CUSTOMER_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@HOGI_LIKE", "P.PROD_HOGI LIKE '%' + @HOGI_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PLANTS", "SAP.PLANTS IN @PLANTS ", UTIL.SqlCondType.IN));
					stringBuilder2.Append(" ORDER BY  P.PROD_CODE ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY3(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT P.PLT_CODE");
				stringBuilder.Append(" , P.PROD_CODE");
				stringBuilder.Append(" , P.ORDER_NO");
				stringBuilder.Append(" , P.ORDER_LINE");
				stringBuilder.Append(" , P.MODEL_TYPE");
				stringBuilder.Append(" , P.PROD_MONTH");
				stringBuilder.Append(" , P.PROD_GOLE");
				stringBuilder.Append(" , P.PROD_HOGI");
				stringBuilder.Append(" , SAP.CUSTOMER");
				stringBuilder.Append(" , P.MODEL_SERISE");
				stringBuilder.Append(" , P.MODEL_NO");
				stringBuilder.Append(" , P.PROD_SEND_DATE");
				stringBuilder.Append(" , SAP.DUE_DATE AS SAP_DUE_DATE");
				stringBuilder.Append(" , P.DUE_DATE");
				stringBuilder.Append(" , P.ORD_DATE");
				stringBuilder.Append(" , P.INDUE_DATE");
				stringBuilder.Append(" , P.SHIP_PLAN_DATE");
				stringBuilder.Append(" , NULL AS DUE_YN");
				stringBuilder.Append(" , (SELECT MIN(PLN_START_TIME) FROM TSHP_WORKORDER WHERE PLT_CODE = P.PLT_CODE AND PROD_CODE = P.PROD_CODE) AS FIRST_ORDER_DATE ");
				stringBuilder.Append(" , (SELECT MAX(PLN_START_TIME) FROM TSHP_WORKORDER WHERE PLT_CODE = P.PLT_CODE AND PROD_CODE = P.PROD_CODE) AS LAST_ORDER_DATE ");
				stringBuilder.Append(" , (SELECT MIN(ACT_START_TIME) FROM TSHP_WORKORDER WHERE PLT_CODE = P.PLT_CODE AND PROD_CODE = P.PROD_CODE) AS ACT_START_TIME ");
				stringBuilder.Append(" , (SELECT MAX(ACT_END_TIME) FROM TSHP_WORKORDER WHERE PLT_CODE = P.PLT_CODE AND PROD_CODE = P.PROD_CODE) AS ACT_END_TIME ");
				stringBuilder.Append(" , NULL AS WORK_RATE");
				stringBuilder.Append(" , P.SCOMMENT ");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO SAP ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE ");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_NO", "P.ORDER_NO = @ORDER_NO "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LINE", "P.ORDER_LINE = @ORDER_LINE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LIKE", "P.ORDER_NO LIKE '%' + @ORDER_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@DATA_FLAG", "P.DATA_FLAG = @DATA_FLAG "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_INDUE_DATE, @E_INDUE_DATE", "P.INDUE_DATE BETWEEN @S_INDUE_DATE AND @E_INDUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_DUE_DATE, @E_DUE_DATE", "P.DUE_DATE BETWEEN @S_DUE_DATE AND @E_DUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_ORD_DATE, @E_ORD_DATE", "P.ORD_DATE BETWEEN @S_ORD_DATE AND @E_ORD_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_PROD_MONTH, @E_PROD_MONTH", "P.PROD_MONTH BETWEEN @S_PROD_MONTH AND @E_PROD_MONTH "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_SHIP_DATE, @E_SHIP_DATE", "SAP.SHIP_DATE BETWEEN @S_SHIP_DATE AND @E_SHIP_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_CODE", "P.PROD_CODE = @PROD_CODE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@MODEL_LIKE", "P.MODEL_NO LIKE '%' + @MODEL_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@CUSTOMER_LIKE", "SAP.CUSTOMER LIKE '%' + @CUSTOMER_LIKE + '%' "));
					stringBuilder2.Append(" ORDER BY  P.PROD_CODE ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY4(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT P.PLT_CODE");
				stringBuilder.Append(" , P.PROD_CODE");
				stringBuilder.Append(" , P.ORDER_NO");
				stringBuilder.Append(" , P.ORDER_LINE");
				stringBuilder.Append(" , P.MODEL_TYPE");
				stringBuilder.Append(" , P.PROD_MONTH");
				stringBuilder.Append(" , P.PROD_GOLE");
				stringBuilder.Append(" , P.PROD_HOGI");
				stringBuilder.Append(" , SAP.CUSTOMER");
				stringBuilder.Append(" , P.MODEL_SERISE");
				stringBuilder.Append(" , P.MODEL_NO");
				stringBuilder.Append(" , P.PROD_SEND_DATE");
				stringBuilder.Append(" , SAP.DUE_DATE AS SAP_DUE_DATE");
				stringBuilder.Append(" , P.DUE_DATE");
				stringBuilder.Append(" , P.ORD_DATE");
				stringBuilder.Append(" , P.INDUE_DATE");
				stringBuilder.Append(" , P.SHIP_PLAN_DATE");
				stringBuilder.Append(" , NULL AS DUE_YN");
				stringBuilder.Append(" , (SELECT MIN(PLN_START_TIME) FROM TSHP_WORKORDER WHERE PLT_CODE = P.PLT_CODE AND PROD_CODE = P.PROD_CODE) AS FIRST_ORDER_DATE ");
				stringBuilder.Append(" , (SELECT MAX(PLN_START_TIME) FROM TSHP_WORKORDER WHERE PLT_CODE = P.PLT_CODE AND PROD_CODE = P.PROD_CODE) AS LAST_ORDER_DATE ");
				stringBuilder.Append(" , (SELECT MIN(ACT_START_TIME) FROM TSHP_WORKORDER WHERE PLT_CODE = P.PLT_CODE AND PROD_CODE = P.PROD_CODE) AS ACT_START_TIME ");
				stringBuilder.Append(" , (SELECT MAX(ACT_END_TIME) FROM TSHP_WORKORDER WHERE PLT_CODE = P.PLT_CODE AND PROD_CODE = P.PROD_CODE) AS ACT_END_TIME ");
				stringBuilder.Append(" , NULL AS WORK_RATE");
				stringBuilder.Append(" , P.SCOMMENT ");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO SAP ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE ");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_NO", "P.ORDER_NO = @ORDER_NO "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LINE", "P.ORDER_LINE = @ORDER_LINE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LIKE", "P.ORDER_NO LIKE '%' + @ORDER_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@DATA_FLAG", "P.DATA_FLAG = @DATA_FLAG "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_INDUE_DATE, @E_INDUE_DATE", "P.INDUE_DATE BETWEEN @S_INDUE_DATE AND @E_INDUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_DUE_DATE, @E_DUE_DATE", "P.DUE_DATE BETWEEN @S_DUE_DATE AND @E_DUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_ORD_DATE, @E_ORD_DATE", "P.ORD_DATE BETWEEN @S_ORD_DATE AND @E_ORD_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_PROD_MONTH, @E_PROD_MONTH", "P.PROD_MONTH BETWEEN @S_PROD_MONTH AND @E_PROD_MONTH "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_SHIP_DATE, @E_SHIP_DATE", "SAP.SHIP_DATE BETWEEN @S_SHIP_DATE AND @E_SHIP_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_CODE", "P.PROD_CODE = @PROD_CODE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@MODEL_LIKE", "P.MODEL_NO LIKE '%' + @MODEL_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@CUSTOMER_LIKE", "SAP.CUSTOMER LIKE '%' + @CUSTOMER_LIKE + '%' "));
					stringBuilder2.Append(" ORDER BY  P.PROD_CODE ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY5(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" P.PLT_CODE");
				stringBuilder.Append(" ,P.PROD_MONTH");
				stringBuilder.Append(" ,COUNT(*) AS PROD_QTY ");
				stringBuilder.Append(" ,M.PROD_TYPE ");
				stringBuilder.Append(" ,CASE WHEN M.PROD_TYPE = 'E' THEN '전동' ");
				stringBuilder.Append("      WHEN M.PROD_TYPE = 'P' THEN '유압' ");
				stringBuilder.Append("      END AS PROD_TYPE_NAME ");
				stringBuilder.Append(" ,SUM(ISNULL(ST.ST_TIME,0)) AS ST_TIME");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append("  JOIN IF_SAP_SHIPINFO SAP ");
				stringBuilder.Append("  ON P.ORDER_NO = SAP.ORDER_NO ");
				stringBuilder.Append("  AND P.ORDER_LINE = SAP.ORDER_LINE ");
				stringBuilder.Append(" LEFT JOIN (SELECT PLT_CODE, ST_CODE, SUM(ST_TIME) AS ST_TIME FROM TORD_ST_PROC GROUP BY PLT_CODE, ST_CODE) ST");
				stringBuilder.Append(" ON ST.PLT_CODE = P.PLT_CODE");
				stringBuilder.Append(" AND ST.ST_CODE = P.ST_CODE");
				stringBuilder.Append(" LEFT JOIN TSTD_MODEL M ");
				stringBuilder.Append(" ON P.PLT_CODE = M.PLT_CODE ");
				stringBuilder.Append(" AND P.MODEL_TYPE = M.MODEL_TYPE ");
				stringBuilder.Append(" AND P.MODEL_SERISE = M.MODEL_SERISE ");
				stringBuilder.Append(" AND P.MODEL_NO = M.MODEL_NO ");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_PROD_MONTH, @E_PROD_MONTH", "P.PROD_MONTH BETWEEN @S_PROD_MONTH AND @E_PROD_MONTH "));
					stringBuilder2.Append(" GROUP BY  P.PLT_CODE,P.PROD_MONTH ,M.PROD_TYPE ");
					stringBuilder2.Append("  ,CASE WHEN M.PROD_TYPE = 'E' THEN '전동' ");
					stringBuilder2.Append("      WHEN M.PROD_TYPE = 'P' THEN '유압' END ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY6(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT A.PLT_CODE");
				stringBuilder.Append(" ,'전체' AS CUSTOMER");
				stringBuilder.Append(" ,COUNT(A.PROD_CODE) AS WO_CNT");
				stringBuilder.Append(" FROM TORD_PRODUCT A");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO P");
				stringBuilder.Append(" ON A.ORDER_NO = P.ORDER_NO");
				stringBuilder.Append(" AND A.ORDER_LINE = P.ORDER_LINE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE A.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LIKE", "A.ORDER_NO LIKE '%' + @ORDER_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@CVND_LIKE", "P.CUSTOMER LIKE '%' + @CVND_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_PROD_MONTH,@E_PROD_MONTH", "A.PROD_MONTH BETWEEN @S_PROD_MONTH AND @E_PROD_MONTH "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_INDUE_DATE,@E_INDUE_DATE", "A.INDUE_DATE BETWEEN @S_INDUE_DATE AND @E_INDUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_DUE_DATE,@E_DUE_DATE", "A.DUE_DATE BETWEEN @S_DUE_DATE AND @E_DUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_SAP_DUE_DATE,@E_SAP_INDUE_DATE", "P.DUE_DATE BETWEEN @S_SAP_DUE_DATE AND @E_SAP_INDUE_DATE "));
					stringBuilder2.Append(" GROUP BY A.PLT_CODE");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY7(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT A.PLT_CODE");
				stringBuilder.Append(" ,ISNULL(P.CUSTOMER,'기타') AS CUSTOMER");
				stringBuilder.Append(" ,COUNT(A.PROD_CODE) AS WO_CNT");
				stringBuilder.Append(" FROM TORD_PRODUCT A");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO P");
				stringBuilder.Append(" ON A.ORDER_NO = P.ORDER_NO");
				stringBuilder.Append(" AND A.ORDER_LINE = P.ORDER_LINE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE A.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_PROD_MONTH,@E_PROD_MONTH", "A.PROD_MONTH BETWEEN @S_PROD_MONTH AND @E_PROD_MONTH "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_INDUE_DATE,@E_INDUE_DATE", "A.INDUE_DATE BETWEEN @S_INDUE_DATE AND @E_INDUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_DUE_DATE,@E_DUE_DATE", "A.DUE_DATE BETWEEN @S_DUE_DATE AND @E_DUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_SAP_DUE_DATE,@E_SAP_INDUE_DATE", "P.DUE_DATE BETWEEN @S_SAP_DUE_DATE AND @E_SAP_INDUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LIKE", "A.ORDER_NO LIKE '%' + @ORDER_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@CVND_LIKE", "P.CUSTOMER LIKE '%' + @CVND_LIKE + '%' "));
					stringBuilder2.Append(" GROUP BY A.PLT_CODE,P.CUSTOMER ");
					stringBuilder2.Append(" ORDER BY CASE WHEN P.CUSTOMER IS NULL THEN 9 ELSE 1 END, P.CUSTOMER ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY8(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT P.PLT_CODE");
				stringBuilder.Append(" , P.PROD_CODE");
				stringBuilder.Append(" , P.ORDER_NO");
				stringBuilder.Append(" , P.ORDER_LINE");
				stringBuilder.Append(" , P.MODEL_TYPE");
				stringBuilder.Append(" , P.MODEL_SERISE");
				stringBuilder.Append(" , P.MODEL_NO");
				stringBuilder.Append(" , P.PROD_MONTH");
				stringBuilder.Append(" , P.PROD_GOLE");
				stringBuilder.Append(" , P.PROD_HOGI");
				stringBuilder.Append(" , SAP.CUSTOMER");
				stringBuilder.Append(" , P.PROD_SEND_DATE");
				stringBuilder.Append(" , SAP.DUE_DATE AS SAP_DUE_DATE");
				stringBuilder.Append(" , P.DUE_DATE");
				stringBuilder.Append(" , P.ORD_DATE");
				stringBuilder.Append(" , P.INDUE_DATE");
				stringBuilder.Append(" , P.SHIP_PLAN_DATE");
				stringBuilder.Append(" , (SELECT MIN(ACT_START_TIME) FROM TSHP_WORKORDER WHERE PLT_CODE = P.PLT_CODE AND PROD_CODE = P.PROD_CODE AND DATA_FLAG = 0) AS ACT_START_TIME ");
				stringBuilder.Append(" , (SELECT MAX(ACT_END_TIME) FROM TSHP_WORKORDER WHERE PLT_CODE = P.PLT_CODE AND PROD_CODE = P.PROD_CODE AND DATA_FLAG = 0) AS ACT_END_TIME ");
				stringBuilder.Append(" , (SELECT SUM(ISNULL(PROC_RATE,0)) FROM TSHP_WORKORDER W");
				stringBuilder.Append(" LEFT JOIN TSTD_ST_GROUP SG");
				stringBuilder.Append(" ON W.PLT_CODE = SG.PLT_CODE");
				stringBuilder.Append(" AND W.PART_CODE = SG.PART_CODE");
				stringBuilder.Append(" AND SG.USE_FLAG = '1'");
				stringBuilder.Append(" AND SG.DATA_FLAG = '0'");
				stringBuilder.Append(" LEFT JOIN TSTD_ST_PROC SP");
				stringBuilder.Append(" ON SG.PLT_CODE = SP.PLT_CODE");
				stringBuilder.Append(" AND SG.ST_CODE = SP.ST_CODE");
				stringBuilder.Append(" AND W.PROC_CODE = SP.PROC_CODE");
				stringBuilder.Append(" AND SP.DATA_FLAG = '0'");
				stringBuilder.Append(" WHERE W.PLT_CODE = P.PLT_CODE AND W.PROD_CODE = P.PROD_CODE AND W.WO_FLAG = '4' AND W.DATA_FLAG = '0') AS WORK_RATE");
				stringBuilder.Append(" , P.SCOMMENT ");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO SAP ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE ");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_NO", "P.ORDER_NO = @ORDER_NO "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LINE", "P.ORDER_LINE = @ORDER_LINE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LIKE", "P.ORDER_NO LIKE '%' + @ORDER_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@DATA_FLAG", "P.DATA_FLAG = @DATA_FLAG "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_INDUE_DATE, @E_INDUE_DATE", "P.INDUE_DATE BETWEEN @S_INDUE_DATE AND @E_INDUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_DUE_DATE, @E_DUE_DATE", "P.DUE_DATE BETWEEN @S_DUE_DATE AND @E_DUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_SAP_DUE_DATE,@E_SAP_INDUE_DATE", "SAP.DUE_DATE BETWEEN @S_SAP_DUE_DATE AND @E_SAP_INDUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_ORD_DATE, @E_ORD_DATE", "P.ORD_DATE BETWEEN @S_ORD_DATE AND @E_ORD_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_PROD_MONTH, @E_PROD_MONTH", "P.PROD_MONTH BETWEEN @S_PROD_MONTH AND @E_PROD_MONTH "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_SHIP_DATE, @E_SHIP_DATE", "SAP.SHIP_DATE BETWEEN @S_SHIP_DATE AND @E_SHIP_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_CODE", "P.PROD_CODE = @PROD_CODE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@MODEL_LIKE", "P.MODEL_NO LIKE '%' + @MODEL_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@CUSTOMER_LIKE", "SAP.CUSTOMER LIKE '%' + @CUSTOMER_LIKE + '%' "));
					if (dtParam.Columns.Contains("CUSTOMER"))
					{
						if (row["CUSTOMER"].ToString() == "기타")
						{
							stringBuilder2.Append(" AND SAP.CUSTOMER IS NULL ");
						}
						else
						{
							stringBuilder2.Append(UTIL.GetWhere(row, "@CUSTOMER", "SAP.CUSTOMER = @CUSTOMER "));
						}
					}
					stringBuilder2.Append(" ORDER BY  P.PROD_CODE ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY9(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT P.PLT_CODE");
				stringBuilder.Append(" , SAP.PLANTS");
				stringBuilder.Append(" , P.PROD_CODE");
				stringBuilder.Append(" , P.ORDER_NO");
				stringBuilder.Append(" , P.ORDER_LINE");
				stringBuilder.Append(" , P.MODEL_TYPE");
				stringBuilder.Append(" , P.PROD_MONTH");
				stringBuilder.Append(" , P.PROD_GOLE");
				stringBuilder.Append(" , P.PROD_HOGI");
				stringBuilder.Append(" , SAP.CUSTOMER");
				stringBuilder.Append(" , P.MODEL_SERISE");
				stringBuilder.Append(" , P.MODEL_NO");
				stringBuilder.Append(" , P.PROD_SEND_DATE");
				stringBuilder.Append(" , SAP.DUE_DATE AS SAP_DUE_DATE");
				stringBuilder.Append(" , P.DUE_DATE");
				stringBuilder.Append(" , P.ORD_DATE");
				stringBuilder.Append(" , P.INDUE_DATE");
				stringBuilder.Append(" , P.SHIP_PLAN_DATE");
				stringBuilder.Append(" , M.PROD_TYPE");
				stringBuilder.Append(" , NULL AS DUE_YN");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" JOIN IF_SAP_SHIPINFO SAP WITH(NOLOCK) ON P.ORDER_NO = SAP.ORDER_NO AND P.ORDER_LINE = SAP.ORDER_LINE ");
				stringBuilder.Append(" LEFT JOIN (SELECT PLT_CODE, PROD_TYPE, MODEL_TYPE FROM TSTD_MODEL");
				stringBuilder.Append(" WHERE P_SCODE IS NULL");
				stringBuilder.Append(" AND DATA_FLAG = '0') M");
				stringBuilder.Append(" ON P.PLT_CODE = M.PLT_CODE");
				stringBuilder.Append(" AND P.MODEL_TYPE = M.MODEL_TYPE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_NO", "P.ORDER_NO = @ORDER_NO "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LINE", "P.ORDER_LINE = @ORDER_LINE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LIKE", "P.ORDER_NO LIKE '%' + @ORDER_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@DATA_FLAG", "P.DATA_FLAG = @DATA_FLAG "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_INDUE_DATE, @E_INDUE_DATE", "P.INDUE_DATE BETWEEN @S_INDUE_DATE AND @E_INDUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_DUE_DATE, @E_DUE_DATE", "P.DUE_DATE BETWEEN @S_DUE_DATE AND @E_DUE_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_ORD_DATE, @E_ORD_DATE", "P.ORD_DATE BETWEEN @S_ORD_DATE AND @E_ORD_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_PROD_MONTH, @E_PROD_MONTH", "P.PROD_MONTH BETWEEN @S_PROD_MONTH AND @E_PROD_MONTH "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_SHIP_DATE, @E_SHIP_DATE", "SAP.SHIP_DATE BETWEEN @S_SHIP_DATE AND @E_SHIP_DATE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_CODE", "P.PROD_CODE = @PROD_CODE "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@MODEL_LIKE", "P.MODEL_NO LIKE '%' + @MODEL_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@CUSTOMER_LIKE", "SAP.CUSTOMER LIKE '%' + @CUSTOMER_LIKE + '%' "));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PLANTS", "SAP.PLANTS IN @PLANTS ", UTIL.SqlCondType.IN));
					stringBuilder2.Append(" ORDER BY  P.INDUE_DATE, P.PROD_TYPE, P.PROD_CODE ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY10(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT A.PLT_CODE, A.DAY_DATE, LEFT(A.DAY_DATE, 6) AS MONTH_DATE, A.PROD_TYPE, SUM(A.PLN_QTY) AS PLN_QTY, SUM(A.ACT_QTY) AS ACT_QTY FROM");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT P.PLT_CODE, PIL.INDUE_DATE AS DAY_DATE, M.PROD_TYPE, COUNT(PIL.PROD_CODE) AS PLN_QTY, 0 AS ACT_QTY");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN TSTD_MODEL M");
				stringBuilder.Append(" ON P.PLT_CODE = M.PLT_CODE");
				stringBuilder.Append(" AND P.MODEL_TYPE = M.MODEL_TYPE");
				stringBuilder.Append(" AND P.MODEL_SERISE = M.MODEL_SERISE");
				stringBuilder.Append(" AND P.MODEL_NO = M.MODEL_NO");
				stringBuilder.Append(" LEFT JOIN (");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" PLT_CODE");
				stringBuilder.Append(" ,PROD_CODE");
				stringBuilder.Append(" ,SUBSTRING(INDUE_DATE,1,6) AS MONTH_DATE");
				stringBuilder.Append(" ,MIN(INDUE_DATE) AS INDUE_DATE");
				stringBuilder.Append(" FROM TORD_PRODUCT_INDUE_LOG");
				stringBuilder.Append(" WHERE DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE, SUBSTRING(INDUE_DATE,1,6)");
				stringBuilder.Append(" ) PIL");
				stringBuilder.Append(" ON P.PLT_CODE = PIL.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = PIL.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(PIL.INDUE_DATE, 6) BETWEEN @S_DATE AND @E_DATE");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY P.PLT_CODE, PIL.INDUE_DATE, M.PROD_TYPE");
				stringBuilder.Append(" UNION ALL");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ,CONVERT(VARCHAR(8), MIN(W.ACT_END_TIME), 112)");
				stringBuilder.Append(" ,M.PROD_TYPE");
				stringBuilder.Append(" ,0 AS PLN_QTY");
				stringBuilder.Append(" ,1 AS ACT_QTY");
				stringBuilder.Append(" FROM TSHP_WORKORDER W");
				stringBuilder.Append(" LEFT JOIN TORD_PRODUCT P");
				stringBuilder.Append(" ON W.PLT_CODE = P.PLT_CODE");
				stringBuilder.Append(" AND W.PROD_CODE = P.PROD_CODE");
				stringBuilder.Append(" LEFT JOIN TSTD_MODEL M");
				stringBuilder.Append(" ON P.PLT_CODE = M.PLT_CODE");
				stringBuilder.Append(" AND P.MODEL_TYPE = M.MODEL_TYPE");
				stringBuilder.Append(" AND P.MODEL_SERISE = M.MODEL_SERISE");
				stringBuilder.Append(" AND P.MODEL_NO = M.MODEL_NO");
				stringBuilder.Append(" WHERE LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 6) BETWEEN @S_DATE AND @E_DATE");
				stringBuilder.Append(" AND W.PLANTS = '3603'");
				stringBuilder.Append(" AND W.PROC_CODE IN ('NAM-10', 'NAM-20', 'ENA-10', 'ENA-20', 'HNA-10', 'HNA-20')");
				stringBuilder.Append(" AND W.WO_FLAG = '4'");
				stringBuilder.Append(" AND W.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ,M.PROD_TYPE");
				stringBuilder.Append(" ) A");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE A.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(" GROUP BY A.PLT_CODE, A.DAY_DATE, A.PROD_TYPE");
					stringBuilder2.Append(" ORDER BY A.PROD_TYPE, A.DAY_DATE");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString(), row).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY15(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT P.MODEL_TYPE ");
				stringBuilder.Append(" ,SUBSTRING(S.SHIP_DATE,1,6) AS YEAR_MONTH");
				stringBuilder.Append(" ,COUNT(*) AS GOAL_CNT");
				stringBuilder.Append(" ,SUM(CASE WHEN CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END > S.SHIP_DATE THEN 1 ELSE CASE WHEN CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END > CONVERT(VARCHAR(8), W.ACT_END_TIME, 112) THEN 1 ELSE 0 END END) AS ACT_CNT");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO S");
				stringBuilder.Append(" ON S.ORDER_NO = P.ORDER_NO");
				stringBuilder.Append(" AND S.ORDER_LINE = P.ORDER_LINE");
				stringBuilder.Append(" LEFT JOIN");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT PLT_CODE, PROD_CODE, MIN(ACT_END_TIME) AS ACT_END_TIME FROM TSHP_WORKORDER");
				stringBuilder.Append(" WHERE PROC_CODE IN ('NAM-10', 'NAM-20', 'ENA-10', 'ENA-20', 'HNA-10', 'HNA-20')");
				stringBuilder.Append(" AND WO_FLAG = '4'");
				stringBuilder.Append(" AND DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE");
				stringBuilder.Append(" ) W");
				stringBuilder.Append(" ON P.PLT_CODE = W.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = W.PROD_CODE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@SER_YEAR", "SUBSTRING(S.SHIP_DATE,1,4) = @SER_YEAR"));
					stringBuilder2.Append(" AND P.PROD_CODE IS NOT NULL AND P.DATA_FLAG = 0 AND S.SHIP_DATE IS NOT NULL ");
					stringBuilder2.Append(" GROUP BY P.MODEL_TYPE,SUBSTRING(S.SHIP_DATE,1,6) ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY15_Q(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT P.MODEL_TYPE ");
				stringBuilder.Append(" ,CONVERT(nvarchar(4),DATEPART(yy,S.SHIP_DATE)) + '-' + CONVERT(nvarchar(1),DATEPART(qq,S.SHIP_DATE)) AS YEAR_QUARTER ");
				stringBuilder.Append(" ,COUNT(*) AS GOAL_CNT");
				stringBuilder.Append(" ,SUM(CASE WHEN CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END > S.SHIP_DATE THEN 1 ELSE CASE WHEN CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END > CONVERT(VARCHAR(8), W.ACT_END_TIME, 112) THEN 1 ELSE 0 END END) AS ACT_CNT");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO S");
				stringBuilder.Append(" ON S.ORDER_NO = P.ORDER_NO");
				stringBuilder.Append(" AND S.ORDER_LINE = P.ORDER_LINE");
				stringBuilder.Append(" LEFT JOIN");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT PLT_CODE, PROD_CODE, MIN(ACT_END_TIME) AS ACT_END_TIME FROM TSHP_WORKORDER");
				stringBuilder.Append(" WHERE PROC_CODE IN ('NAM-10', 'NAM-20', 'ENA-10', 'ENA-20', 'HNA-10', 'HNA-20')");
				stringBuilder.Append(" AND WO_FLAG = '4'");
				stringBuilder.Append(" AND DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE");
				stringBuilder.Append(" ) W");
				stringBuilder.Append(" ON P.PLT_CODE = W.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = W.PROD_CODE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@SER_YEAR", "SUBSTRING(S.SHIP_DATE,1,4) = @SER_YEAR"));
					stringBuilder2.Append("  AND P.PROD_CODE IS NOT NULL AND P.DATA_FLAG = 0 AND S.SHIP_DATE IS NOT NULL ");
					stringBuilder2.Append(" GROUP BY P.MODEL_TYPE, DATEPART(yy,S.SHIP_DATE),DATEPART(qq,S.SHIP_DATE) ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY15_Y(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT P.MODEL_TYPE ");
				stringBuilder.Append(" ,SUBSTRING(S.SHIP_DATE,1,4) AS SER_YEAR");
				stringBuilder.Append(" ,COUNT(*) AS GOAL_CNT");
				stringBuilder.Append(" ,SUM(CASE WHEN CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END > S.SHIP_DATE THEN 1 ELSE CASE WHEN CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END > CONVERT(VARCHAR(8), W.ACT_END_TIME, 112) THEN 1 ELSE 0 END END) AS ACT_CNT");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO S");
				stringBuilder.Append(" ON S.ORDER_NO = P.ORDER_NO");
				stringBuilder.Append(" AND S.ORDER_LINE = P.ORDER_LINE");
				stringBuilder.Append(" LEFT JOIN");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT PLT_CODE, PROD_CODE, MIN(ACT_END_TIME) AS ACT_END_TIME FROM TSHP_WORKORDER");
				stringBuilder.Append(" WHERE PROC_CODE IN ('NAM-10', 'NAM-20', 'ENA-10', 'ENA-20', 'HNA-10', 'HNA-20')");
				stringBuilder.Append(" AND WO_FLAG = '4'");
				stringBuilder.Append(" AND DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE");
				stringBuilder.Append(" ) W");
				stringBuilder.Append(" ON P.PLT_CODE = W.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = W.PROD_CODE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_YEAR,@E_YEAR", "SUBSTRING(S.SHIP_DATE,1,4) BETWEEN @S_YEAR AND @E_YEAR"));
					stringBuilder2.Append("  AND P.PROD_CODE IS NOT NULL AND P.DATA_FLAG = 0 AND S.SHIP_DATE IS NOT NULL ");
					stringBuilder2.Append(" GROUP BY P.MODEL_TYPE,SUBSTRING(S.SHIP_DATE,1,4) ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY15_D(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT P.MODEL_TYPE ");
				stringBuilder.Append(" ,S.SHIP_DATE AS YEAR_DAY");
				stringBuilder.Append(" ,COUNT(*) AS GOAL_CNT");
				stringBuilder.Append(" ,SUM(CASE WHEN CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END > S.SHIP_DATE THEN 1 ELSE CASE WHEN CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END > CONVERT(VARCHAR(8), W.ACT_END_TIME, 112) THEN 1 ELSE 0 END END) AS ACT_CNT");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO S");
				stringBuilder.Append(" ON S.ORDER_NO = P.ORDER_NO");
				stringBuilder.Append(" AND S.ORDER_LINE = P.ORDER_LINE");
				stringBuilder.Append(" LEFT JOIN");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT PLT_CODE, PROD_CODE, MIN(ACT_END_TIME) AS ACT_END_TIME FROM TSHP_WORKORDER");
				stringBuilder.Append(" WHERE PROC_CODE IN ('NAM-10', 'NAM-20', 'ENA-10', 'ENA-20', 'HNA-10', 'HNA-20')");
				stringBuilder.Append(" AND WO_FLAG = '4'");
				stringBuilder.Append(" AND DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE");
				stringBuilder.Append(" ) W");
				stringBuilder.Append(" ON P.PLT_CODE = W.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = W.PROD_CODE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_YEAR,@E_YEAR", "SUBSTRING(S.SHIP_DATE,1,4) BETWEEN @S_YEAR AND @E_YEAR"));
					stringBuilder2.Append("  AND P.PROD_CODE IS NOT NULL AND P.DATA_FLAG = 0 AND S.SHIP_DATE IS NOT NULL ");
					stringBuilder2.Append(" GROUP BY P.MODEL_TYPE, S.SHIP_DATE ORDER BY P.MODEL_TYPE, S.SHIP_DATE ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY15_DD(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT P.MODEL_TYPE");
				stringBuilder.Append(" ,P.PROD_HOGI");
				stringBuilder.Append(" ,S.CUSTOMER");
				stringBuilder.Append(" ,S.ORDER_QTY");
				stringBuilder.Append(" ,CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END AS DUE_DATE");
				stringBuilder.Append(" ,S.SHIP_DATE");
				stringBuilder.Append(" ,W.ACT_END_TIME");
				stringBuilder.Append(" ,CASE WHEN CONVERT(INT, CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END) - CONVERT(INT, S.SHIP_DATE) > 0 THEN '준수' ELSE CASE WHEN CONVERT(INT, CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END) - CONVERT(INT, CONVERT(VARCHAR(8), W.ACT_END_TIME, 112)) > 0 THEN '준수' ELSE '미준수' END END RESULT");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO S");
				stringBuilder.Append(" ON S.ORDER_NO = P.ORDER_NO");
				stringBuilder.Append(" AND S.ORDER_LINE = P.ORDER_LINE");
				stringBuilder.Append(" LEFT JOIN");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT PLT_CODE, PROD_CODE, MIN(ACT_END_TIME) AS ACT_END_TIME FROM TSHP_WORKORDER");
				stringBuilder.Append(" WHERE PROC_CODE IN ('NAM-10', 'NAM-20', 'ENA-10', 'ENA-20', 'HNA-10', 'HNA-20')");
				stringBuilder.Append(" AND WO_FLAG = '4'");
				stringBuilder.Append(" AND DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE");
				stringBuilder.Append(" ) W");
				stringBuilder.Append(" ON P.PLT_CODE = W.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = W.PROD_CODE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_YEAR,@E_YEAR", "SUBSTRING(S.SHIP_DATE,1,4) BETWEEN @S_YEAR AND @E_YEAR"));
					stringBuilder2.Append("  AND P.PROD_CODE IS NOT NULL AND P.DATA_FLAG = 0 AND S.SHIP_DATE IS NOT NULL ");
					stringBuilder2.Append(" ORDER BY S.SHIP_DATE, P.MODEL_TYPE ");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY16(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" set transaction isolation level read uncommitted");
				stringBuilder.Append(" SELECT A.PLT_CODE, A.PROD_CODE, A.YEAR_DATE, MIN(A.INDUE_DATE) AS INDUE_DATE, MIN(A.ACT_END_DATE) AS ACT_END_DATE, A.MODEL_TYPE, SUM(A.PLN_QTY) AS PLN_QTY, SUM(A.ACT_QTY) AS ACT_QTY");
				stringBuilder.Append(" , LEFT(MIN(A.INDUE_DATE),4) AS YEAR_INDUE_DATE, LEFT(MIN(A.ACT_END_DATE),4) AS YEAR_ACT_END_DATE FROM");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT P.PLT_CODE, P.PROD_CODE, LEFT(PIL.INDUE_DATE, 4) AS YEAR_DATE, PIL.INDUE_DATE, NULL AS ACT_END_DATE, P.MODEL_TYPE, COUNT(PIL.PROD_CODE) AS PLN_QTY, 0 AS ACT_QTY");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN (");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" PLT_CODE");
				stringBuilder.Append(" ,PROD_CODE");
				stringBuilder.Append(" ,SUBSTRING(INDUE_DATE,1,4) AS YEAR_DATE");
				stringBuilder.Append(" ,MIN(INDUE_DATE) AS INDUE_DATE");
				stringBuilder.Append(" , NULL AS ACT_END_TIME");
				stringBuilder.Append(" FROM TORD_PRODUCT_INDUE_LOG");
				stringBuilder.Append(" WHERE DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE, SUBSTRING(INDUE_DATE,1,4)");
				stringBuilder.Append(" ) PIL");
				stringBuilder.Append(" ON P.PLT_CODE = PIL.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = PIL.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(PIL.INDUE_DATE, 4) BETWEEN @S_YEAR AND @E_YEAR");
				stringBuilder.Append(" AND LEFT(PIL.INDUE_DATE, 6) < @S_DATE");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.MODEL_TYPE IS NOT NULL");
				stringBuilder.Append(" AND ISNULL(P.ORDER_FLAG2, '0') <> '5'");
				if (dtParam.Columns.Contains("IS_PRE_DATA") && dtParam.Rows[0]["IS_PRE_DATA"].ToString() == "1")
				{
					stringBuilder.Append(" AND LEFT(PIL.INDUE_DATE, 4) >= '2021'");
				}
				stringBuilder.Append(" GROUP BY P.PLT_CODE, LEFT(PIL.INDUE_DATE, 4), P.MODEL_TYPE, P.PROD_CODE, PIL.INDUE_DATE");
				stringBuilder.Append(" UNION ALL");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ,P.PROD_CODE");
				stringBuilder.Append(" ,LEFT(CONVERT(VARCHAR(8), MIN(W.ACT_END_TIME), 112), 4)");
				stringBuilder.Append(" , NULL AS INDUE_DATE");
				stringBuilder.Append(" ,CONVERT(VARCHAR(8), MIN(W.ACT_END_TIME), 112)");
				stringBuilder.Append(" ,P.MODEL_TYPE");
				stringBuilder.Append(" ,0 AS PLN_QTY");
				stringBuilder.Append(" ,1 AS ACT_QTY");
				stringBuilder.Append(" FROM TSHP_WORKORDER W");
				stringBuilder.Append(" LEFT JOIN TORD_PRODUCT P");
				stringBuilder.Append(" ON W.PLT_CODE = P.PLT_CODE");
				stringBuilder.Append(" AND W.PROD_CODE = P.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 4) BETWEEN @S_YEAR AND @E_YEAR");
				stringBuilder.Append(" AND LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 6) < @S_DATE");
				stringBuilder.Append(" AND W.PLANTS = '3603'");
				stringBuilder.Append(" AND W.MPROC_CODE IN ('CND','HDD','EDD')");
				stringBuilder.Append(" AND W.WO_FLAG = '4'");
				stringBuilder.Append(" AND W.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.MODEL_TYPE IS NOT NULL");
				stringBuilder.Append(" AND ISNULL(P.ORDER_FLAG2, '0') <> '5'");
				if (dtParam.Columns.Contains("IS_PRE_DATA") && dtParam.Rows[0]["IS_PRE_DATA"].ToString() == "1")
				{
					stringBuilder.Append(" AND LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 4) >= '2021'");
				}
				stringBuilder.Append(" GROUP BY");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ,P.PROD_CODE");
				stringBuilder.Append(" ,P.MODEL_TYPE");
				stringBuilder.Append(" ) A");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE A.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(" GROUP BY A.PLT_CODE, A.YEAR_DATE, A.MODEL_TYPE, A.PROD_CODE");
					stringBuilder2.Append(" ORDER BY A.MODEL_TYPE, A.YEAR_DATE");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString(), row).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY16_1(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" set transaction isolation level read uncommitted");
				stringBuilder.Append(" SELECT A.PLT_CODE, A.YEAR_DATE, SUM(A.PLN_QTY) AS PLN_QTY, SUM(A.ACT_QTY) AS ACT_QTY FROM");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT P.PLT_CODE, LEFT(PIL.INDUE_DATE, 4) AS YEAR_DATE, COUNT(PIL.PROD_CODE) AS PLN_QTY, 0 AS ACT_QTY");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN (");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" PLT_CODE");
				stringBuilder.Append(" ,PROD_CODE");
				stringBuilder.Append(" ,SUBSTRING(INDUE_DATE,1,4) AS YEAR_DATE");
				stringBuilder.Append(" ,MIN(INDUE_DATE) AS INDUE_DATE");
				stringBuilder.Append(" FROM TORD_PRODUCT_INDUE_LOG");
				stringBuilder.Append(" WHERE DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE, SUBSTRING(INDUE_DATE,1,4)");
				stringBuilder.Append(" ) PIL");
				stringBuilder.Append(" ON P.PLT_CODE = PIL.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = PIL.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(PIL.INDUE_DATE, 4) BETWEEN @S_YEAR AND @E_YEAR");
				stringBuilder.Append(" AND LEFT(PIL.INDUE_DATE, 6) < @S_DATE");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.MODEL_TYPE IS NOT NULL");
				stringBuilder.Append(" AND ISNULL(P.ORDER_FLAG2, '0') = '5'");
				if (dtParam.Columns.Contains("IS_PRE_DATA") && dtParam.Rows[0]["IS_PRE_DATA"].ToString() == "1")
				{
					stringBuilder.Append(" AND LEFT(PIL.INDUE_DATE, 4) >= '2021'");
				}
				stringBuilder.Append(" GROUP BY P.PLT_CODE, PIL.INDUE_DATE");
				stringBuilder.Append(" UNION ALL");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ,LEFT(CONVERT(VARCHAR(8), MIN(W.ACT_END_TIME), 112), 4)");
				stringBuilder.Append(" ,0 AS PLN_QTY");
				stringBuilder.Append(" ,1 AS ACT_QTY");
				stringBuilder.Append(" FROM TSHP_WORKORDER W");
				stringBuilder.Append(" LEFT JOIN TORD_PRODUCT P");
				stringBuilder.Append(" ON W.PLT_CODE = P.PLT_CODE");
				stringBuilder.Append(" AND W.PROD_CODE = P.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 4) BETWEEN @S_YEAR AND @E_YEAR");
				stringBuilder.Append(" AND LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 6) < @S_DATE");
				stringBuilder.Append(" AND W.PLANTS = '3603'");
				stringBuilder.Append(" AND W.MPROC_CODE IN ('CND','HDD','EDD')");
				stringBuilder.Append(" AND W.WO_FLAG = '4'");
				stringBuilder.Append(" AND W.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.MODEL_TYPE IS NOT NULL");
				stringBuilder.Append(" AND ISNULL(P.ORDER_FLAG2, '0') = '5'");
				if (dtParam.Columns.Contains("IS_PRE_DATA") && dtParam.Rows[0]["IS_PRE_DATA"].ToString() == "1")
				{
					stringBuilder.Append(" AND LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 4) >= '2021'");
				}
				stringBuilder.Append(" GROUP BY");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ) A");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE A.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(" GROUP BY A.PLT_CODE, A.YEAR_DATE");
					stringBuilder2.Append(" ORDER BY A.YEAR_DATE");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString(), row).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY17(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" set transaction isolation level read uncommitted");
				stringBuilder.Append(" SELECT A.PLT_CODE, A.PROD_CODE, A.DAY_DATE, LEFT(A.DAY_DATE,6) AS MONTH_DATE, MIN(A.INDUE_DATE) AS INDUE_DATE, MIN(A.ACT_END_DATE) AS ACT_END_DATE, A.MODEL_TYPE, SUM(A.PLN_QTY) AS PLN_QTY, SUM(A.ACT_QTY) AS ACT_QTY FROM");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT P.PLT_CODE, P.PROD_CODE, PIL.INDUE_DATE AS DAY_DATE, PIL.INDUE_DATE, NULL AS ACT_END_DATE, P.MODEL_TYPE, COUNT(PIL.PROD_CODE) AS PLN_QTY, 0 AS ACT_QTY");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN (");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" PLT_CODE");
				stringBuilder.Append(" ,PROD_CODE");
				stringBuilder.Append(" ,SUBSTRING(INDUE_DATE,1,6) AS MONTH_DATE");
				stringBuilder.Append(" ,MIN(INDUE_DATE) AS INDUE_DATE");
				stringBuilder.Append(" FROM TORD_PRODUCT_INDUE_LOG");
				stringBuilder.Append(" WHERE DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE, SUBSTRING(INDUE_DATE,1,6)");
				stringBuilder.Append(" ) PIL");
				stringBuilder.Append(" ON P.PLT_CODE = PIL.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = PIL.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(PIL.INDUE_DATE, 6) BETWEEN @S_YEAR_DATE AND @E_YEAR_DATE");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.MODEL_TYPE IS NOT NULL");
				stringBuilder.Append(" AND ISNULL(P.ORDER_FLAG2, '0') <> '5'");
				if (dtParam.Columns.Contains("IS_PRE_DATA") && dtParam.Rows[0]["IS_PRE_DATA"].ToString() == "1")
				{
					stringBuilder.Append(" AND LEFT(PIL.INDUE_DATE, 4) >= '2021'");
				}
				stringBuilder.Append(" GROUP BY P.PLT_CODE, PIL.INDUE_DATE, P.MODEL_TYPE, P.PROD_CODE");
				stringBuilder.Append(" UNION ALL");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ,P.PROD_CODE");
				stringBuilder.Append(" ,CONVERT(VARCHAR(8), MIN(W.ACT_END_TIME), 112)");
				stringBuilder.Append(" , NULL AS INDUE_DATE");
				stringBuilder.Append(" ,CONVERT(VARCHAR(8), MIN(W.ACT_END_TIME), 112)");
				stringBuilder.Append(" ,P.MODEL_TYPE");
				stringBuilder.Append(" ,0 AS PLN_QTY");
				stringBuilder.Append(" ,1 AS ACT_QTY");
				stringBuilder.Append(" FROM TSHP_WORKORDER W");
				stringBuilder.Append(" LEFT JOIN TORD_PRODUCT P");
				stringBuilder.Append(" ON W.PLT_CODE = P.PLT_CODE");
				stringBuilder.Append(" AND W.PROD_CODE = P.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 6) BETWEEN @S_YEAR_DATE AND @E_YEAR_DATE");
				stringBuilder.Append(" AND W.PLANTS = '3603'");
				stringBuilder.Append(" AND W.MPROC_CODE IN ('CND','HDD','EDD')");
				stringBuilder.Append(" AND W.WO_FLAG = '4'");
				stringBuilder.Append(" AND W.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.MODEL_TYPE IS NOT NULL");
				stringBuilder.Append(" AND ISNULL(P.ORDER_FLAG2, '0') <> '5'");
				if (dtParam.Columns.Contains("IS_PRE_DATA") && dtParam.Rows[0]["IS_PRE_DATA"].ToString() == "1")
				{
					stringBuilder.Append(" AND LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 4) >= '2021'");
				}
				stringBuilder.Append(" GROUP BY");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ,P.PROD_CODE");
				stringBuilder.Append(" ,P.MODEL_TYPE");
				stringBuilder.Append(" ) A");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE A.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(" GROUP BY A.PLT_CODE, A.DAY_DATE, A.MODEL_TYPE, A.PROD_CODE");
					stringBuilder2.Append(" ORDER BY A.MODEL_TYPE, A.DAY_DATE");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString(), row).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY17_1(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" set transaction isolation level read uncommitted");
				stringBuilder.Append(" SELECT A.PLT_CODE, A.DAY_DATE, LEFT(A.DAY_DATE,6) AS MONTH_DATE, SUM(A.PLN_QTY) AS PLN_QTY, SUM(A.ACT_QTY) AS ACT_QTY FROM");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT P.PLT_CODE, PIL.INDUE_DATE AS DAY_DATE, COUNT(PIL.PROD_CODE) AS PLN_QTY, 0 AS ACT_QTY");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN (");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" PLT_CODE");
				stringBuilder.Append(" ,PROD_CODE");
				stringBuilder.Append(" ,SUBSTRING(INDUE_DATE,1,6) AS MONTH_DATE");
				stringBuilder.Append(" ,MIN(INDUE_DATE) AS INDUE_DATE");
				stringBuilder.Append(" FROM TORD_PRODUCT_INDUE_LOG");
				stringBuilder.Append(" WHERE DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE, SUBSTRING(INDUE_DATE,1,6)");
				stringBuilder.Append(" ) PIL");
				stringBuilder.Append(" ON P.PLT_CODE = PIL.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = PIL.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(PIL.INDUE_DATE, 6) BETWEEN @S_YEAR_DATE AND @E_YEAR_DATE");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.MODEL_TYPE IS NOT NULL");
				stringBuilder.Append(" AND ISNULL(P.ORDER_FLAG2, '0') = '5'");
				if (dtParam.Columns.Contains("IS_PRE_DATA") && dtParam.Rows[0]["IS_PRE_DATA"].ToString() == "1")
				{
					stringBuilder.Append(" AND LEFT(PIL.INDUE_DATE, 4) >= '2021'");
				}
				stringBuilder.Append(" GROUP BY P.PLT_CODE, PIL.INDUE_DATE");
				stringBuilder.Append(" UNION ALL");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ,CONVERT(VARCHAR(8), MIN(W.ACT_END_TIME), 112)");
				stringBuilder.Append(" ,0 AS PLN_QTY");
				stringBuilder.Append(" ,1 AS ACT_QTY");
				stringBuilder.Append(" FROM TSHP_WORKORDER W");
				stringBuilder.Append(" LEFT JOIN TORD_PRODUCT P");
				stringBuilder.Append(" ON W.PLT_CODE = P.PLT_CODE");
				stringBuilder.Append(" AND W.PROD_CODE = P.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 6) BETWEEN @S_YEAR_DATE AND @E_YEAR_DATE");
				stringBuilder.Append(" AND W.PLANTS = '3603'");
				stringBuilder.Append(" AND W.MPROC_CODE IN ('CND','HDD','EDD')");
				stringBuilder.Append(" AND W.WO_FLAG = '4'");
				stringBuilder.Append(" AND W.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" AND ISNULL(P.ORDER_FLAG2, '0') = '5'");
				if (dtParam.Columns.Contains("IS_PRE_DATA") && dtParam.Rows[0]["IS_PRE_DATA"].ToString() == "1")
				{
					stringBuilder.Append(" AND LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 4) >= '2021'");
				}
				stringBuilder.Append(" GROUP BY");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ) A");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE A.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(" GROUP BY A.PLT_CODE, A.DAY_DATE");
					stringBuilder2.Append(" ORDER BY A.DAY_DATE");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString(), row).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY18(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" set transaction isolation level read uncommitted");
				stringBuilder.Append(" SELECT A.PLT_CODE, A.YEAR_DATE, A.MODEL_TYPE, A.MODEL_NO, SUM(A.PLN_QTY) AS PLN_QTY, SUM(A.ACT_QTY) AS ACT_QTY, A.PROD_CODE, MIN(A.INDUE_DATE) AS INDUE_DATE, MIN(A.ACT_END_DATE) AS ACT_END_DATE ");
				stringBuilder.Append(" , LEFT(MIN(A.INDUE_DATE),4) AS YEAR_INDUE_DATE, LEFT(MIN(A.ACT_END_DATE),4) AS YEAR_ACT_END_DATE FROM");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT P.PLT_CODE, P.PROD_CODE, LEFT(PIL.INDUE_DATE, 4) AS YEAR_DATE, PIL.INDUE_DATE, NULL AS ACT_END_DATE, P.MODEL_TYPE, P.MODEL_NO, COUNT(PIL.PROD_CODE) AS PLN_QTY, 0 AS ACT_QTY");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN (");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" PLT_CODE");
				stringBuilder.Append(" ,PROD_CODE");
				stringBuilder.Append(" ,SUBSTRING(INDUE_DATE,1,4) AS YEAR_DATE");
				stringBuilder.Append(" ,MIN(INDUE_DATE) AS INDUE_DATE");
				stringBuilder.Append(" FROM TORD_PRODUCT_INDUE_LOG");
				stringBuilder.Append(" WHERE DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE, SUBSTRING(INDUE_DATE,1,4)");
				stringBuilder.Append(" ) PIL");
				stringBuilder.Append(" ON P.PLT_CODE = PIL.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = PIL.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(PIL.INDUE_DATE, 4) BETWEEN @S_YEAR AND @E_YEAR");
				stringBuilder.Append(" AND LEFT(PIL.INDUE_DATE, 6) < @S_DATE");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.MODEL_TYPE IS NOT NULL");
				stringBuilder.Append(" AND ISNULL(P.ORDER_FLAG2, '0') <> '5'");
				if (dtParam.Columns.Contains("IS_PRE_DATA") && dtParam.Rows[0]["IS_PRE_DATA"].ToString() == "1")
				{
					stringBuilder.Append(" AND LEFT(PIL.INDUE_DATE, 4) >= '2021'");
				}
				stringBuilder.Append(" GROUP BY P.PLT_CODE, PIL.INDUE_DATE, P.MODEL_TYPE, P.MODEL_NO, P.PROD_CODE");
				stringBuilder.Append(" UNION ALL");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ,W.PROD_CODE");
				stringBuilder.Append(" ,LEFT(CONVERT(VARCHAR(8), MIN(W.ACT_END_TIME), 112), 4)  AS YEAR_DATE");
				stringBuilder.Append(" ,NULL AS INDUE_DATE");
				stringBuilder.Append(" ,CONVERT(VARCHAR(8), MIN(W.ACT_END_TIME), 112)");
				stringBuilder.Append(" ,P.MODEL_TYPE");
				stringBuilder.Append(" ,P.MODEL_NO");
				stringBuilder.Append(" ,0 AS PLN_QTY");
				stringBuilder.Append(" ,1 AS ACT_QTY");
				stringBuilder.Append(" FROM TSHP_WORKORDER W");
				stringBuilder.Append(" LEFT JOIN TORD_PRODUCT P");
				stringBuilder.Append(" ON W.PLT_CODE = P.PLT_CODE");
				stringBuilder.Append(" AND W.PROD_CODE = P.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 4) BETWEEN @S_YEAR AND @E_YEAR");
				stringBuilder.Append(" AND LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 6) < @S_DATE");
				stringBuilder.Append(" AND W.PLANTS = '3603'");
				stringBuilder.Append(" AND W.MPROC_CODE IN ('CND','HDD','EDD')");
				stringBuilder.Append(" AND W.WO_FLAG = '4'");
				stringBuilder.Append(" AND W.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.MODEL_TYPE IS NOT NULL");
				stringBuilder.Append(" AND ISNULL(P.ORDER_FLAG2, '0') <> '5'");
				if (dtParam.Columns.Contains("IS_PRE_DATA") && dtParam.Rows[0]["IS_PRE_DATA"].ToString() == "1")
				{
					stringBuilder.Append(" AND LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 4) >= '2021'");
				}
				stringBuilder.Append(" GROUP BY");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ,W.PROD_CODE");
				stringBuilder.Append(" ,CONVERT(VARCHAR(8), W.ACT_END_TIME, 112)");
				stringBuilder.Append(" ,P.MODEL_TYPE");
				stringBuilder.Append(" ,P.MODEL_NO");
				stringBuilder.Append(" ) A");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE A.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(" GROUP BY A.PLT_CODE, A.YEAR_DATE, A.MODEL_TYPE, A.MODEL_NO, A.PROD_CODE");
					stringBuilder2.Append(" ORDER BY A.MODEL_TYPE, A.YEAR_DATE, A.MODEL_NO");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString(), row).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY19(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" set transaction isolation level read uncommitted");
				stringBuilder.Append(" SELECT A.PLT_CODE, A.DAY_DATE, LEFT(A.DAY_DATE,6) AS MONTH_DATE, MIN(A.INDUE_DATE) AS INDUE_DATE, MIN(A.ACT_END_DATE) AS ACT_END_DATE, A.MODEL_TYPE, A.MODEL_NO, SUM(A.PLN_QTY) AS PLN_QTY, SUM(A.ACT_QTY) AS ACT_QTY FROM");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT P.PLT_CODE, P.PROD_CODE, PIL.INDUE_DATE AS DAY_DATE, PIL.INDUE_DATE, NULL AS ACT_END_DATE, P.MODEL_TYPE, P.MODEL_NO, COUNT(PIL.PROD_CODE) AS PLN_QTY, 0 AS ACT_QTY");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN (");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" PLT_CODE");
				stringBuilder.Append(" ,PROD_CODE");
				stringBuilder.Append(" ,SUBSTRING(INDUE_DATE,1,6) AS YEAR_DATE");
				stringBuilder.Append(" ,MIN(INDUE_DATE) AS INDUE_DATE");
				stringBuilder.Append(" FROM TORD_PRODUCT_INDUE_LOG");
				stringBuilder.Append(" WHERE DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE, SUBSTRING(INDUE_DATE,1,6)");
				stringBuilder.Append(" ) PIL");
				stringBuilder.Append(" ON P.PLT_CODE = PIL.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = PIL.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(PIL.INDUE_DATE, 6) BETWEEN @S_YEAR_DATE AND @E_YEAR_DATE");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.MODEL_TYPE IS NOT NULL");
				stringBuilder.Append(" AND ISNULL(P.ORDER_FLAG2, '0') <> '5'");
				if (dtParam.Columns.Contains("IS_PRE_DATA") && dtParam.Rows[0]["IS_PRE_DATA"].ToString() == "1")
				{
					stringBuilder.Append(" AND LEFT(PIL.INDUE_DATE, 4) >= '2021'");
				}
				stringBuilder.Append(" GROUP BY P.PLT_CODE, PIL.INDUE_DATE, P.MODEL_TYPE, P.MODEL_NO, P.PROD_CODE");
				stringBuilder.Append(" UNION ALL");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ,P.PROD_CODE");
				stringBuilder.Append(" ,CONVERT(VARCHAR(8), MIN(W.ACT_END_TIME), 112)");
				stringBuilder.Append(" , NULL AS INDUE_DATE");
				stringBuilder.Append(" ,CONVERT(VARCHAR(8), MIN(W.ACT_END_TIME), 112)");
				stringBuilder.Append(" ,P.MODEL_TYPE");
				stringBuilder.Append(" ,P.MODEL_NO");
				stringBuilder.Append(" ,0 AS PLN_QTY");
				stringBuilder.Append(" ,1 AS ACT_QTY");
				stringBuilder.Append(" FROM TSHP_WORKORDER W");
				stringBuilder.Append(" LEFT JOIN TORD_PRODUCT P");
				stringBuilder.Append(" ON W.PLT_CODE = P.PLT_CODE");
				stringBuilder.Append(" AND W.PROD_CODE = P.PROD_CODE");
				stringBuilder.Append(" WHERE LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 6) BETWEEN @S_YEAR_DATE AND @E_YEAR_DATE");
				stringBuilder.Append(" AND W.PLANTS = '3603'");
				stringBuilder.Append(" AND W.MPROC_CODE IN ('CND','HDD','EDD')");
				stringBuilder.Append(" AND W.WO_FLAG = '4'");
				stringBuilder.Append(" AND W.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.DATA_FLAG = '0'");
				stringBuilder.Append(" AND P.MODEL_TYPE IS NOT NULL");
				stringBuilder.Append(" AND ISNULL(P.ORDER_FLAG2, '0') <> '5'");
				if (dtParam.Columns.Contains("IS_PRE_DATA") && dtParam.Rows[0]["IS_PRE_DATA"].ToString() == "1")
				{
					stringBuilder.Append(" AND LEFT(CONVERT(VARCHAR(8), W.ACT_END_TIME, 112), 4) >= '2021'");
				}
				stringBuilder.Append(" GROUP BY");
				stringBuilder.Append(" W.PLT_CODE");
				stringBuilder.Append(" ,P.PROD_CODE");
				stringBuilder.Append(" ,P.MODEL_TYPE");
				stringBuilder.Append(" ,P.MODEL_NO");
				stringBuilder.Append(" ) A");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE A.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(" GROUP BY A.PLT_CODE, A.DAY_DATE, A.MODEL_TYPE, A.MODEL_NO, A.PROD_CODE");
					stringBuilder2.Append(" ORDER BY A.MODEL_TYPE, A.DAY_DATE, A.MODEL_NO");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString(), row).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY20(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" set transaction isolation level read uncommitted");
				stringBuilder.Append(" SELECT P.PLT_CODE");
				stringBuilder.Append(" , P.MODEL_TYPE");
				stringBuilder.Append(" ,SUBSTRING(S.SHIP_DATE,1,4) AS YEAR_DATE");
				stringBuilder.Append(" ,SUBSTRING(S.SHIP_DATE, 1,6) AS MONTH_DATE");
				stringBuilder.Append(" ,S.SHIP_DATE AS DAY_DATE");
				stringBuilder.Append(" ,COUNT(*) AS GOAL_QTY");
				stringBuilder.Append(" ,SUM(CASE WHEN CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END > S.SHIP_DATE THEN 1 ELSE CASE WHEN CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END >  CONVERT(VARCHAR(8), W.ACT_END_TIME, 112) THEN 1 ELSE 0 END END) AS ACT_QTY");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO S");
				stringBuilder.Append(" ON S.ORDER_NO = P.ORDER_NO");
				stringBuilder.Append(" AND S.ORDER_LINE = P.ORDER_LINE");
				stringBuilder.Append(" LEFT JOIN");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT PLT_CODE, PROD_CODE, MIN(ACT_END_TIME) AS ACT_END_TIME FROM TSHP_WORKORDER");
				stringBuilder.Append(" WHERE MPROC_CODE IN ('CND','HDD','EDD')");
				stringBuilder.Append(" AND WO_FLAG = '4'");
				stringBuilder.Append(" AND DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE");
				stringBuilder.Append(" ) W");
				stringBuilder.Append(" ON P.PLT_CODE = W.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = W.PROD_CODE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_YEAR,@E_YEAR", "SUBSTRING(S.SHIP_DATE,1,4) BETWEEN @S_YEAR AND @E_YEAR"));
					stringBuilder2.Append(" AND P.PROD_CODE IS NOT NULL AND P.DATA_FLAG = 0 AND S.SHIP_DATE IS NOT NULL AND P.MODEL_TYPE IS NOT NULL ");
					if (dtParam.Columns.Contains("IS_PRE_DATA") && row["IS_PRE_DATA"].ToString() == "1")
					{
						stringBuilder2.Append(" AND SUBSTRING(S.SHIP_DATE,1,4) >= '2021'");
					}
					stringBuilder2.Append(" GROUP BY P.PLT_CODE, P.MODEL_TYPE, S.SHIP_DATE ORDER BY P.MODEL_TYPE, S.SHIP_DATE");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString(), row).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY21(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" set transaction isolation level read uncommitted");
				stringBuilder.Append(" SELECT P.PLT_CODE");
				stringBuilder.Append(" , P.MODEL_TYPE");
				stringBuilder.Append(" ,P.MODEL_NO");
				stringBuilder.Append(" ,SUBSTRING(S.SHIP_DATE,1,4) AS YEAR_DATE");
				stringBuilder.Append(" ,SUBSTRING(S.SHIP_DATE, 1,6) AS MONTH_DATE");
				stringBuilder.Append(" ,S.SHIP_DATE AS DAY_DATE");
				stringBuilder.Append(" ,COUNT(*) AS GOAL_QTY");
				stringBuilder.Append(" ,SUM(CASE WHEN CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END > S.SHIP_DATE THEN 1 ELSE CASE WHEN CASE WHEN P.DUE_DATE IS NULL THEN S.DUE_DATE ELSE P.DUE_DATE END >  CONVERT(VARCHAR(8), W.ACT_END_TIME, 112) THEN 1 ELSE 0 END END) AS ACT_QTY");
				stringBuilder.Append(" FROM TORD_PRODUCT P");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO S");
				stringBuilder.Append(" ON S.ORDER_NO = P.ORDER_NO");
				stringBuilder.Append(" AND S.ORDER_LINE = P.ORDER_LINE");
				stringBuilder.Append(" LEFT JOIN");
				stringBuilder.Append(" (");
				stringBuilder.Append(" SELECT PLT_CODE, PROD_CODE, MIN(ACT_END_TIME) AS ACT_END_TIME FROM TSHP_WORKORDER");
				stringBuilder.Append(" WHERE MPROC_CODE IN ('CND','HDD','EDD')");
				stringBuilder.Append(" AND WO_FLAG = '4'");
				stringBuilder.Append(" AND DATA_FLAG = '0'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE");
				stringBuilder.Append(" ) W");
				stringBuilder.Append(" ON P.PLT_CODE = W.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = W.PROD_CODE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE P.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_YEAR,@E_YEAR", "SUBSTRING(S.SHIP_DATE,1,4) BETWEEN @S_YEAR AND @E_YEAR"));
					stringBuilder2.Append(" AND P.PROD_CODE IS NOT NULL AND P.DATA_FLAG = 0 AND S.SHIP_DATE IS NOT NULL AND P.MODEL_TYPE IS NOT NULL ");
					if (dtParam.Columns.Contains("IS_PRE_DATA") && row["IS_PRE_DATA"].ToString() == "1")
					{
						stringBuilder2.Append(" AND SUBSTRING(S.SHIP_DATE,1,4) >= '2021'");
					}
					stringBuilder2.Append(" GROUP BY P.PLT_CODE, P.MODEL_TYPE, S.SHIP_DATE, P.MODEL_NO ORDER BY P.MODEL_TYPE, S.SHIP_DATE");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString(), row).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY22(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" set transaction isolation level read uncommitted");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" FC.PLT_CODE");
				stringBuilder.Append(" ,M.PROD_TYPE");
				stringBuilder.Append(" ,P.PROD_CODE");
				stringBuilder.Append(" ,P.ORDER_NO");
				stringBuilder.Append(" ,P.ORDER_LINE");
				stringBuilder.Append(" ,P.PROD_HOGI");
				stringBuilder.Append(" ,P.MODEL_NO");
				stringBuilder.Append(" ,P.INDUE_DATE");
				stringBuilder.Append(" ,SH.CUSTOMER");
				stringBuilder.Append(" ,ISNULL(WM.WORK_FLAG, '0') AS WORK_FLAG");
				stringBuilder.Append(" ,WM.SCOMMENT");
				stringBuilder.Append(" ,ISNULL(WM.MDFY_EMP, WM.REG_EMP) AS CHK_EMP");
				stringBuilder.Append(" ,ISNULL(WM.MDFY_DATE, WM.REG_DATE) AS CHK_DATE");
				stringBuilder.Append(" ,E.EMP_NAME AS CHK_EMP_NAME");
				stringBuilder.Append(" ,CASE WHEN NAM.PROD_CODE IS NOT NULL THEN '1' ELSE '0' END AS IS_NAM");
				stringBuilder.Append(" ,MC.MC_NO");
				stringBuilder.Append(" FROM TSHP_NG_FILE_CHK FC");
				stringBuilder.Append(" LEFT JOIN TSHP_WORKORDER W");
				stringBuilder.Append(" ON FC.PLT_CODE = W.PLT_CODE");
				stringBuilder.Append(" AND FC.WO_NO = W.WO_NO");
				stringBuilder.Append(" LEFT JOIN TORD_PRODUCT P");
				stringBuilder.Append(" ON W.PLT_CODE = P.PLT_CODE");
				stringBuilder.Append(" AND W.PROD_CODE = P.PROD_CODE");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO SH ");
				stringBuilder.Append(" ON P.ORDER_NO = SH.ORDER_NO");
				stringBuilder.Append(" AND P.ORDER_LINE = SH.ORDER_LINE");
				stringBuilder.Append(" LEFT JOIN TSHP_NG_FILE_WORK_MASTER WM ");
				stringBuilder.Append(" ON P.PLT_CODE = WM.PLT_CODE");
				stringBuilder.Append(" AND P.PROD_CODE = WM.PROD_CODE");
				stringBuilder.Append(" LEFT JOIN TSTD_EMPLOYEE E ");
				stringBuilder.Append(" ON WM.PLT_CODE = E.PLT_CODE");
				stringBuilder.Append(" AND ISNULL(WM.MDFY_EMP, WM.REG_EMP) = E.EMP_CODE");
				stringBuilder.Append(" LEFT JOIN TSTD_MODEL M ");
				stringBuilder.Append(" ON P.PLT_CODE = M.PLT_CODE");
				stringBuilder.Append(" AND P.MODEL_TYPE = M.MODEL_TYPE");
				stringBuilder.Append(" AND P.MODEL_SERISE = M.MODEL_SERISE");
				stringBuilder.Append(" AND P.MODEL_NO = M.MODEL_NO");
				stringBuilder.Append(" LEFT JOIN (");
				stringBuilder.Append(" SELECT PLT_CODE, PROD_CODE FROM TSHP_WORKORDER");
				stringBuilder.Append(" WHERE WO_FLAG = '4'");
				stringBuilder.Append(" AND PROC_CODE = 'NAM-10'");
				stringBuilder.Append(" AND DATA_FLAG = '0'");
				stringBuilder.Append(" AND PLANTS = '3603'");
				stringBuilder.Append(" GROUP BY PLT_CODE, PROD_CODE");
				stringBuilder.Append(" ) NAM");
				stringBuilder.Append(" ON W.PLT_CODE = NAM.PLT_CODE");
				stringBuilder.Append(" AND W.PROD_CODE = NAM.PROD_CODE");
				stringBuilder.Append(" LEFT JOIN (");
				stringBuilder.Append(" SELECT * FROM(");
				stringBuilder.Append(" SELECT PLT_CODE, PROD_CODE, MC_NO, REG_DATE, ROW_NUMBER() OVER(PARTITION BY PROD_CODE ORDER BY REG_DATE DESC) AS WO_SEQ FROM TSHP_WORKORDER");
				stringBuilder.Append(" WHERE MPROC_CODE = 'NAM'");
				stringBuilder.Append(" AND DATA_FLAG = '0'");
				stringBuilder.Append(" AND PLANTS = '3603'");
				stringBuilder.Append(" AND MC_NO IS NOT NULL");
				stringBuilder.Append(" ) MCN");
				stringBuilder.Append(" WHERE WO_SEQ = 1");
				stringBuilder.Append(" ) MC");
				stringBuilder.Append(" ON W.PLT_CODE = MC.PLT_CODE");
				stringBuilder.Append(" AND W.PROD_CODE = MC.PROD_CODE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE FC.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@S_INDUE_DATE,@E_INDUE_DATE", "INDUE_DATE BETWEEN @S_INDUE_DATE AND @E_INDUE_DATE"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@HOGI_LIKE", "P.PROD_HOGI LIKE '%' + @HOGI_LIKE + '%'"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@ORDER_LIKE", "P.ORDER_NO LIKE '%' + @ORDER_LIKE + '%'"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@CUSTOMER_LIKE", "SH.CUSTOMER LIKE '%' + @CUSTOMER_LIKE + '%'"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_CODE", "P.PROD_CODE = @PROD_CODE"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_TYPE", "M.PROD_TYPE = @PROD_TYPE"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@MC_NO_LIKE", "MC.MC_NO LIKE '%' + @MC_NO_LIKE + '%'"));
					stringBuilder2.Append(" GROUP BY FC.PLT_CODE, P.INDUE_DATE, P.PROD_CODE, P.ORDER_NO, P.ORDER_LINE, P.PROD_HOGI, P.MODEL_NO, SH.CUSTOMER, WM.WORK_FLAG, WM.SCOMMENT, ISNULL(WM.MDFY_EMP, WM.REG_EMP), E.EMP_NAME, M.PROD_TYPE, CASE WHEN NAM.PROD_CODE IS NOT NULL THEN '1' ELSE '0' END, MC.MC_NO, ISNULL(WM.MDFY_DATE, WM.REG_DATE) ");
					stringBuilder2.Append(" ORDER BY P.INDUE_DATE");
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString(), row).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY23(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" set transaction isolation level read uncommitted");
				stringBuilder.Append(" SELECT");
				stringBuilder.Append(" FC.PLT_CODE");
				stringBuilder.Append(" ,FC.FILE_ID");
				stringBuilder.Append(" ,FM.FILE_NAME");
				stringBuilder.Append(" ,FC.PROC_CODE");
				stringBuilder.Append(" ,FC.WO_NO");
				stringBuilder.Append(" ,FC.EMP_CODE");
				stringBuilder.Append(" ,WE.EMP_NAME");
				stringBuilder.Append(" ,FC.REG_DATE AS CHK_REG_DATE");
				stringBuilder.Append(" ,FM.REG_DATE");
				stringBuilder.Append(" ,FM.REG_EMP");
				stringBuilder.Append(" ,E.EMP_NAME AS REG_EMP_NAME");
				stringBuilder.Append(" ,FM.DATA_FLAG");
				stringBuilder.Append(" FROM TSHP_NG_FILE_CHK FC");
				stringBuilder.Append(" LEFT JOIN TSHP_WORKORDER W");
				stringBuilder.Append(" ON FC.PLT_CODE = W.PLT_CODE");
				stringBuilder.Append(" AND FC.WO_NO = W.WO_NO");
				stringBuilder.Append(" LEFT JOIN TORD_PRODUCT P");
				stringBuilder.Append(" ON W.PLT_CODE = P.PLT_CODE");
				stringBuilder.Append(" AND W.PROD_CODE = P.PROD_CODE");
				stringBuilder.Append(" LEFT JOIN IF_SAP_SHIPINFO SH WITH(NOLOCK)");
				stringBuilder.Append(" ON P.ORDER_NO = SH.ORDER_NO");
				stringBuilder.Append(" AND P.ORDER_LINE = SH.ORDER_LINE");
				stringBuilder.Append(" LEFT JOIN TSYS_FILELIST_MASTER FM");
				stringBuilder.Append(" ON FC.PLT_CODE = FM.PLT_CODE");
				stringBuilder.Append(" AND FC.FILE_ID = FM.FILE_ID");
				stringBuilder.Append(" LEFT JOIN TSTD_EMPLOYEE E");
				stringBuilder.Append(" ON FM.PLT_CODE = E.PLT_CODE");
				stringBuilder.Append(" AND FM.REG_EMP = E.EMP_CODE");
				stringBuilder.Append(" LEFT JOIN TSTD_EMPLOYEE WE");
				stringBuilder.Append(" ON FC.PLT_CODE = WE.PLT_CODE");
				stringBuilder.Append(" AND FC.EMP_CODE = WE.EMP_CODE");
				foreach (DataRow row in dtParam.Rows)
				{
					StringBuilder stringBuilder2 = new StringBuilder(" WHERE FC.PLT_CODE = " + UTIL.GetValidValue(row, "PLT_CODE").ToString());
					stringBuilder2.Append(UTIL.GetWhere(row, "@PROD_CODE", "P.PROD_CODE = @PROD_CODE"));
					stringBuilder2.Append(UTIL.GetWhere(row, "@MODEL", "FC.MODEL = @MODEL"));
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString() + stringBuilder2.ToString(), row).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_QUERY99(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append(" SELECT ORDER_NO, SEND_NO, MAIL_SUBJECT FROM TORD_PROD_SEND_LOG A");
				stringBuilder.Append(" LEFT JOIN TORD_PRODUCT B");
				stringBuilder.Append(" ON A.PLT_CODE = B.PLT_CODE");
				stringBuilder.Append(" AND A.PROD_CODE = B.PROD_CODE");
				stringBuilder.Append(" LEFT JOIN TSYS_FILELIST_MASTER C");
				stringBuilder.Append(" ON A.PLT_CODE = C.PLT_CODE");
				stringBuilder.Append(" AND A.SEND_NO = C.LINK_KEY");
				stringBuilder.Append(" AND IS_UPLOAD = '1'");
				stringBuilder.Append(" WHERE SEND_SEQ = '0'");
				stringBuilder.Append(" AND IF_FLAG IS NULL");
				stringBuilder.Append(" AND MAIL_TO LIKE '%<서인철>%'");
				stringBuilder.Append(" AND C.LINK_KEY IS NULL");
				stringBuilder.Append(" AND A.PROD_CODE = 'P220520-0011'");
				foreach (DataRow row in dtParam.Rows)
				{
					DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString()).Copy();
					dataTable.TableName = "RSLTDT";
					dataSet.Merge(dataTable);
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}
}
