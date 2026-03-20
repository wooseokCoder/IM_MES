using System;
using System.Data;
using System.Diagnostics;
using System.Text;
using BizExecute;

namespace DORD;

public class TORD_PRODUCT
{
	public static DataTable TORD_PRODUCT_SER(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append("  SELECT  ");
				stringBuilder.Append("  PLT_CODE ");
				stringBuilder.Append(" ,PROD_CODE ");
				stringBuilder.Append(" ,ORDER_NO ");
				stringBuilder.Append(" ,ORDER_LINE ");
				stringBuilder.Append(" ,PROD_MONTH ");
				stringBuilder.Append(" ,PROD_STATE ");
				stringBuilder.Append(" ,PROD_HOGI ");
				stringBuilder.Append(" ,PROD_TYPE ");
				stringBuilder.Append(" ,PROD_GOLE ");
				stringBuilder.Append(" ,SALE_MONTH ");
				stringBuilder.Append(" ,MODEL_TYPE ");
				stringBuilder.Append(" ,MODEL_SERISE ");
				stringBuilder.Append(" ,MODEL_NO ");
				stringBuilder.Append(" ,MODEL_TON ");
				stringBuilder.Append(" ,INOUT_FLAG ");
				stringBuilder.Append(" ,SHIP_COUNTRY ");
				stringBuilder.Append(" ,ORDER_FLAG ");
				stringBuilder.Append(" ,ORDER_FLAG2 ");
				stringBuilder.Append(" ,GAORDER_NO ");
				stringBuilder.Append(" ,GAORDER_LINE ");
				stringBuilder.Append(" ,JINORDER_NO ");
				stringBuilder.Append(" ,JINORDER_LINE ");
				stringBuilder.Append(" ,PART_CODE ");
				stringBuilder.Append(" ,ST_CODE ");
				stringBuilder.Append(" ,CVND_CONTENTS ");
				stringBuilder.Append(" ,PROD_SEND_DATE ");
				stringBuilder.Append(" ,DUE_DATE ");
				stringBuilder.Append(" ,INDUE_DATE ");
				stringBuilder.Append(" ,DUE_SEND ");
				stringBuilder.Append(" ,ORD_DATE ");
				stringBuilder.Append(" ,PROD_WEEK ");
				stringBuilder.Append(" ,MAIN_PROD ");
				stringBuilder.Append(" ,LAST_MONTH ");
				stringBuilder.Append(" ,NOW_MONTH ");
				stringBuilder.Append(" ,NEXT_MONTH ");
				stringBuilder.Append(" ,PLAN_RATE ");
				stringBuilder.Append(" ,PLAN_EMP_RATE ");
				stringBuilder.Append(" ,YEAR_WEEK ");
				stringBuilder.Append(" ,MONTH_WEEK ");
				stringBuilder.Append(" ,INDUE_WEEK ");
				stringBuilder.Append(" ,INDUE_MONTH_WEEK ");
				stringBuilder.Append(" ,SHIP_PLAN_DATE ");
				stringBuilder.Append(" ,SCOMMENT ");
				stringBuilder.Append(" ,REG_DATE ");
				stringBuilder.Append(" ,REG_EMP ");
				stringBuilder.Append(" ,MDFY_DATE ");
				stringBuilder.Append(" ,MDFY_EMP ");
				stringBuilder.Append(" ,DEL_DATE ");
				stringBuilder.Append(" ,DEL_EMP ");
				stringBuilder.Append(" ,DEL_REASON ");
				stringBuilder.Append(" ,DATA_FLAG ");
				stringBuilder.Append(" ,OLD_PROD_HOGI ");
				stringBuilder.Append(" ,OLD_ORDER_NO ");
				stringBuilder.Append(" ,OLD_ORDER_LINE ");
				stringBuilder.Append("  FROM TORD_PRODUCT  ");
				stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE  ");
				stringBuilder.Append("  AND PROD_CODE = @PROD_CODE  ");
				foreach (DataRow row in dtParam.Rows)
				{
					bool flag = true;
					if (!UTIL.ValidColumn(row, "PLT_CODE"))
					{
						flag = false;
					}
					if (!UTIL.ValidColumn(row, "PROD_CODE"))
					{
						flag = false;
					}
					if (flag)
					{
						DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString(), row).Copy();
						dataTable.TableName = "RSLTDT";
						dataSet.Merge(dataTable);
					}
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_SER2(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append("  SELECT  ");
				stringBuilder.Append("  PLT_CODE ");
				stringBuilder.Append(" ,PROD_CODE ");
				stringBuilder.Append(" ,ORDER_NO ");
				stringBuilder.Append(" ,ORDER_LINE ");
				stringBuilder.Append(" ,PROD_MONTH ");
				stringBuilder.Append(" ,PROD_STATE ");
				stringBuilder.Append(" ,PROD_HOGI ");
				stringBuilder.Append(" ,PROD_TYPE ");
				stringBuilder.Append(" ,PROD_GOLE ");
				stringBuilder.Append(" ,SALE_MONTH ");
				stringBuilder.Append(" ,MODEL_TYPE ");
				stringBuilder.Append(" ,MODEL_SERISE ");
				stringBuilder.Append(" ,MODEL_NO ");
				stringBuilder.Append(" ,MODEL_TON ");
				stringBuilder.Append(" ,INOUT_FLAG ");
				stringBuilder.Append(" ,SHIP_COUNTRY ");
				stringBuilder.Append(" ,ORDER_FLAG ");
				stringBuilder.Append(" ,ORDER_FLAG2 ");
				stringBuilder.Append(" ,GAORDER_NO ");
				stringBuilder.Append(" ,GAORDER_LINE ");
				stringBuilder.Append(" ,JINORDER_NO ");
				stringBuilder.Append(" ,JINORDER_LINE ");
				stringBuilder.Append(" ,PART_CODE ");
				stringBuilder.Append(" ,ST_CODE ");
				stringBuilder.Append(" ,CVND_CONTENTS ");
				stringBuilder.Append(" ,PROD_SEND_DATE ");
				stringBuilder.Append(" ,DUE_DATE ");
				stringBuilder.Append(" ,INDUE_DATE ");
				stringBuilder.Append(" ,DUE_SEND ");
				stringBuilder.Append(" ,ORD_DATE ");
				stringBuilder.Append(" ,PROD_WEEK ");
				stringBuilder.Append(" ,MAIN_PROD ");
				stringBuilder.Append(" ,LAST_MONTH ");
				stringBuilder.Append(" ,NOW_MONTH ");
				stringBuilder.Append(" ,NEXT_MONTH ");
				stringBuilder.Append(" ,PLAN_RATE ");
				stringBuilder.Append(" ,PLAN_EMP_RATE ");
				stringBuilder.Append(" ,YEAR_WEEK ");
				stringBuilder.Append(" ,MONTH_WEEK ");
				stringBuilder.Append(" ,INDUE_WEEK ");
				stringBuilder.Append(" ,INDUE_MONTH_WEEK ");
				stringBuilder.Append(" ,SHIP_PLAN_DATE ");
				stringBuilder.Append(" ,SCOMMENT ");
				stringBuilder.Append(" ,REG_DATE ");
				stringBuilder.Append(" ,REG_EMP ");
				stringBuilder.Append(" ,MDFY_DATE ");
				stringBuilder.Append(" ,MDFY_EMP ");
				stringBuilder.Append(" ,DEL_DATE ");
				stringBuilder.Append(" ,DEL_EMP ");
				stringBuilder.Append(" ,DEL_REASON ");
				stringBuilder.Append(" ,DATA_FLAG ");
				stringBuilder.Append(" ,OLD_PROD_HOGI ");
				stringBuilder.Append(" ,OLD_ORDER_NO ");
				stringBuilder.Append(" ,OLD_ORDER_LINE ");
				stringBuilder.Append("  FROM TORD_PRODUCT  ");
				stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE  ");
				stringBuilder.Append("  AND ORDER_NO = @ORDER_NO  ");
				stringBuilder.Append("  AND ORDER_LINE = @ORDER_LINE  ");
				stringBuilder.Append("  AND DATA_FLAG = 0  ");
				foreach (DataRow row in dtParam.Rows)
				{
					bool flag = true;
					if (!UTIL.ValidColumn(row, "PLT_CODE"))
					{
						flag = false;
					}
					if (!UTIL.ValidColumn(row, "ORDER_NO"))
					{
						flag = false;
					}
					if (!UTIL.ValidColumn(row, "ORDER_LINE"))
					{
						flag = false;
					}
					if (flag)
					{
						DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString(), row).Copy();
						dataTable.TableName = "RSLTDT";
						dataSet.Merge(dataTable);
					}
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_SER3(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append("  SELECT  ");
				stringBuilder.Append("  PLT_CODE ");
				stringBuilder.Append(" ,PROD_CODE ");
				stringBuilder.Append(" ,ORDER_NO ");
				stringBuilder.Append(" ,ORDER_LINE ");
				stringBuilder.Append(" ,PROD_MONTH ");
				stringBuilder.Append(" ,PROD_STATE ");
				stringBuilder.Append(" ,PROD_HOGI ");
				stringBuilder.Append(" ,PROD_TYPE ");
				stringBuilder.Append(" ,PROD_GOLE ");
				stringBuilder.Append(" ,SALE_MONTH ");
				stringBuilder.Append(" ,MODEL_TYPE ");
				stringBuilder.Append(" ,MODEL_SERISE ");
				stringBuilder.Append(" ,MODEL_NO ");
				stringBuilder.Append(" ,MODEL_TON ");
				stringBuilder.Append(" ,INOUT_FLAG ");
				stringBuilder.Append(" ,SHIP_COUNTRY ");
				stringBuilder.Append(" ,ORDER_FLAG ");
				stringBuilder.Append(" ,ORDER_FLAG2 ");
				stringBuilder.Append(" ,GAORDER_NO ");
				stringBuilder.Append(" ,GAORDER_LINE ");
				stringBuilder.Append(" ,JINORDER_NO ");
				stringBuilder.Append(" ,JINORDER_LINE ");
				stringBuilder.Append(" ,PART_CODE ");
				stringBuilder.Append(" ,ST_CODE ");
				stringBuilder.Append(" ,CVND_CONTENTS ");
				stringBuilder.Append(" ,PROD_SEND_DATE ");
				stringBuilder.Append(" ,DUE_DATE ");
				stringBuilder.Append(" ,INDUE_DATE ");
				stringBuilder.Append(" ,DUE_SEND ");
				stringBuilder.Append(" ,ORD_DATE ");
				stringBuilder.Append(" ,PROD_WEEK ");
				stringBuilder.Append(" ,MAIN_PROD ");
				stringBuilder.Append(" ,LAST_MONTH ");
				stringBuilder.Append(" ,NOW_MONTH ");
				stringBuilder.Append(" ,NEXT_MONTH ");
				stringBuilder.Append(" ,PLAN_RATE ");
				stringBuilder.Append(" ,PLAN_EMP_RATE ");
				stringBuilder.Append(" ,YEAR_WEEK ");
				stringBuilder.Append(" ,MONTH_WEEK ");
				stringBuilder.Append(" ,INDUE_WEEK ");
				stringBuilder.Append(" ,INDUE_MONTH_WEEK ");
				stringBuilder.Append(" ,SHIP_PLAN_DATE ");
				stringBuilder.Append(" ,SCOMMENT ");
				stringBuilder.Append(" ,REG_DATE ");
				stringBuilder.Append(" ,REG_EMP ");
				stringBuilder.Append(" ,MDFY_DATE ");
				stringBuilder.Append(" ,MDFY_EMP ");
				stringBuilder.Append(" ,DEL_DATE ");
				stringBuilder.Append(" ,DEL_EMP ");
				stringBuilder.Append(" ,DEL_REASON ");
				stringBuilder.Append(" ,DATA_FLAG ");
				stringBuilder.Append(" ,OLD_PROD_HOGI ");
				stringBuilder.Append("  FROM TORD_PRODUCT  ");
				stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE  ");
				stringBuilder.Append("  AND PROD_HOGI = @PROD_HOGI  ");
				stringBuilder.Append("  AND DATA_FLAG = 0  ");
				foreach (DataRow row in dtParam.Rows)
				{
					bool flag = true;
					if (!UTIL.ValidColumn(row, "PLT_CODE"))
					{
						flag = false;
					}
					if (!UTIL.ValidColumn(row, "PROD_HOGI"))
					{
						flag = false;
					}
					if (flag)
					{
						DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString(), row).Copy();
						dataTable.TableName = "RSLTDT";
						dataSet.Merge(dataTable);
					}
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static DataTable TORD_PRODUCT_SER4(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count > 0)
			{
				StringBuilder stringBuilder = new StringBuilder();
				stringBuilder.Append("  SELECT  ");
				stringBuilder.Append("  PLT_CODE ");
				stringBuilder.Append(" ,PROD_CODE ");
				stringBuilder.Append(" ,ORDER_NO ");
				stringBuilder.Append(" ,ORDER_LINE ");
				stringBuilder.Append(" ,PROD_MONTH ");
				stringBuilder.Append(" ,PROD_STATE ");
				stringBuilder.Append(" ,PROD_HOGI ");
				stringBuilder.Append(" ,PROD_TYPE ");
				stringBuilder.Append(" ,PROD_GOLE ");
				stringBuilder.Append(" ,SALE_MONTH ");
				stringBuilder.Append(" ,MODEL_TYPE ");
				stringBuilder.Append(" ,MODEL_SERISE ");
				stringBuilder.Append(" ,MODEL_NO ");
				stringBuilder.Append(" ,MODEL_TON ");
				stringBuilder.Append(" ,INOUT_FLAG ");
				stringBuilder.Append(" ,SHIP_COUNTRY ");
				stringBuilder.Append(" ,ORDER_FLAG ");
				stringBuilder.Append(" ,ORDER_FLAG2 ");
				stringBuilder.Append(" ,GAORDER_NO ");
				stringBuilder.Append(" ,GAORDER_LINE ");
				stringBuilder.Append(" ,JINORDER_NO ");
				stringBuilder.Append(" ,JINORDER_LINE ");
				stringBuilder.Append(" ,PART_CODE ");
				stringBuilder.Append(" ,ST_CODE ");
				stringBuilder.Append(" ,CVND_CONTENTS ");
				stringBuilder.Append(" ,PROD_SEND_DATE ");
				stringBuilder.Append(" ,DUE_DATE ");
				stringBuilder.Append(" ,INDUE_DATE ");
				stringBuilder.Append(" ,DUE_SEND ");
				stringBuilder.Append(" ,ORD_DATE ");
				stringBuilder.Append(" ,PROD_WEEK ");
				stringBuilder.Append(" ,MAIN_PROD ");
				stringBuilder.Append(" ,LAST_MONTH ");
				stringBuilder.Append(" ,NOW_MONTH ");
				stringBuilder.Append(" ,NEXT_MONTH ");
				stringBuilder.Append(" ,PLAN_RATE ");
				stringBuilder.Append(" ,PLAN_EMP_RATE ");
				stringBuilder.Append(" ,YEAR_WEEK ");
				stringBuilder.Append(" ,MONTH_WEEK ");
				stringBuilder.Append(" ,INDUE_WEEK ");
				stringBuilder.Append(" ,INDUE_MONTH_WEEK ");
				stringBuilder.Append(" ,SHIP_PLAN_DATE ");
				stringBuilder.Append(" ,SCOMMENT ");
				stringBuilder.Append(" ,REG_DATE ");
				stringBuilder.Append(" ,REG_EMP ");
				stringBuilder.Append(" ,MDFY_DATE ");
				stringBuilder.Append(" ,MDFY_EMP ");
				stringBuilder.Append(" ,DEL_DATE ");
				stringBuilder.Append(" ,DEL_EMP ");
				stringBuilder.Append(" ,DEL_REASON ");
				stringBuilder.Append(" ,DATA_FLAG ");
				stringBuilder.Append(" ,OLD_PROD_HOGI ");
				stringBuilder.Append(" ,SIM_FLAG ");
				stringBuilder.Append("  FROM TORD_PRODUCT  ");
				stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE  ");
				stringBuilder.Append("  AND PROD_HOGI = @PROD_HOGI  ");
				stringBuilder.Append("  AND DATA_FLAG = '0'  ");
				foreach (DataRow row in dtParam.Rows)
				{
					bool flag = true;
					if (!UTIL.ValidColumn(row, "PLT_CODE"))
					{
						flag = false;
					}
					if (!UTIL.ValidColumn(row, "PROD_HOGI"))
					{
						flag = false;
					}
					if (flag)
					{
						DataTable dataTable = bizExecute.executeSelectQuery(stringBuilder.ToString(), row).Copy();
						dataTable.TableName = "RSLTDT";
						dataSet.Merge(dataTable);
					}
				}
			}
			return UTIL.GetDsToDt(dataSet);
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_INS(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" INSERT INTO TORD_PRODUCT (  ");
			stringBuilder.Append("  PLT_CODE ");
			stringBuilder.Append(" ,PROD_CODE ");
			stringBuilder.Append(" ,PROD_MONTH ");
			stringBuilder.Append(" ,PROD_STATE ");
			stringBuilder.Append(" ,PROD_TYPE ");
			stringBuilder.Append(" ,PROD_GOLE ");
			stringBuilder.Append(" ,SALE_MONTH ");
			stringBuilder.Append(" ,MODEL_TYPE ");
			stringBuilder.Append(" ,MODEL_SERISE ");
			stringBuilder.Append(" ,MODEL_NO ");
			stringBuilder.Append(" ,MODEL_TON ");
			stringBuilder.Append(" ,INOUT_FLAG ");
			stringBuilder.Append(" ,SHIP_COUNTRY ");
			stringBuilder.Append(" ,ORDER_FLAG ");
			stringBuilder.Append(" ,ORDER_FLAG2 ");
			stringBuilder.Append(" ,GAORDER_NO ");
			stringBuilder.Append(" ,GAORDER_LINE ");
			stringBuilder.Append(" ,JINORDER_NO ");
			stringBuilder.Append(" ,JINORDER_LINE ");
			stringBuilder.Append(" ,ORDER_NO ");
			stringBuilder.Append(" ,ORDER_LINE ");
			stringBuilder.Append(" ,PROD_HOGI ");
			stringBuilder.Append(" ,PART_CODE ");
			stringBuilder.Append(" ,ST_CODE ");
			stringBuilder.Append(" ,CVND_CONTENTS ");
			stringBuilder.Append(" ,PROD_SEND_DATE ");
			stringBuilder.Append(" ,DUE_DATE ");
			stringBuilder.Append(" ,INDUE_DATE ");
			stringBuilder.Append(" ,DUE_SEND ");
			stringBuilder.Append(" ,ORD_DATE ");
			stringBuilder.Append(" ,PROD_WEEK ");
			stringBuilder.Append(" ,MAIN_PROD ");
			stringBuilder.Append(" ,LAST_MONTH ");
			stringBuilder.Append(" ,NOW_MONTH ");
			stringBuilder.Append(" ,NEXT_MONTH ");
			stringBuilder.Append(" ,PLAN_RATE ");
			stringBuilder.Append(" ,PLAN_EMP_RATE ");
			stringBuilder.Append(" ,YEAR_WEEK ");
			stringBuilder.Append(" ,MONTH_WEEK ");
			stringBuilder.Append(" ,INDUE_WEEK ");
			stringBuilder.Append(" ,INDUE_MONTH_WEEK ");
			stringBuilder.Append(" ,SHIP_PLAN_DATE ");
			stringBuilder.Append(" ,SCOMMENT ");
			stringBuilder.Append(" ,OLD_ORDER_NO ");
			stringBuilder.Append(" ,OLD_ORDER_LINE ");
			stringBuilder.Append(" ,REG_DATE ");
			stringBuilder.Append(" ,REG_EMP ");
			stringBuilder.Append(" ,DATA_FLAG ");
			stringBuilder.Append("  ) VALUES (  ");
			stringBuilder.Append("  @PLT_CODE ");
			stringBuilder.Append(" ,@PROD_CODE ");
			stringBuilder.Append(" ,@PROD_MONTH ");
			stringBuilder.Append(" ,@PROD_STATE ");
			stringBuilder.Append(" ,@PROD_TYPE ");
			stringBuilder.Append(" ,@PROD_GOLE ");
			stringBuilder.Append(" ,@SALE_MONTH ");
			stringBuilder.Append(" ,@MODEL_TYPE ");
			stringBuilder.Append(" ,@MODEL_SERISE ");
			stringBuilder.Append(" ,@MODEL_NO ");
			stringBuilder.Append(" ,@MODEL_TON ");
			stringBuilder.Append(" ,@INOUT_FLAG ");
			stringBuilder.Append(" ,@SHIP_COUNTRY ");
			stringBuilder.Append(" ,@ORDER_FLAG ");
			stringBuilder.Append(" ,@ORDER_FLAG2 ");
			stringBuilder.Append(" ,@GAORDER_NO ");
			stringBuilder.Append(" ,@GAORDER_LINE ");
			stringBuilder.Append(" ,@JINORDER_NO ");
			stringBuilder.Append(" ,@JINORDER_LINE ");
			stringBuilder.Append(" ,@ORDER_NO ");
			stringBuilder.Append(" ,@ORDER_LINE ");
			stringBuilder.Append(" ,@PROD_HOGI ");
			stringBuilder.Append(" ,@PART_CODE ");
			stringBuilder.Append(" ,@ST_CODE ");
			stringBuilder.Append(" ,@CVND_CONTENTS ");
			stringBuilder.Append(" ,@PROD_SEND_DATE ");
			stringBuilder.Append(" ,@DUE_DATE ");
			stringBuilder.Append(" ,@INDUE_DATE ");
			stringBuilder.Append(" ,@DUE_SEND ");
			stringBuilder.Append(" ,@ORD_DATE ");
			stringBuilder.Append(" ,@PROD_WEEK ");
			stringBuilder.Append(" ,@MAIN_PROD ");
			stringBuilder.Append(" ,@LAST_MONTH ");
			stringBuilder.Append(" ,@NOW_MONTH ");
			stringBuilder.Append(" ,@NEXT_MONTH ");
			stringBuilder.Append(" ,@PLAN_RATE ");
			stringBuilder.Append(" ,@PLAN_EMP_RATE ");
			stringBuilder.Append(" ,@YEAR_WEEK ");
			stringBuilder.Append(" ,@MONTH_WEEK ");
			stringBuilder.Append(" ,@INDUE_WEEK ");
			stringBuilder.Append(" ,@INDUE_MONTH_WEEK ");
			stringBuilder.Append(" ,@SHIP_PLAN_DATE ");
			stringBuilder.Append(" ,@SCOMMENT ");
			stringBuilder.Append(" ,@OLD_ORDER_NO ");
			stringBuilder.Append(" ,@OLD_ORDER_LINE ");
			stringBuilder.Append(" ,GETDATE() ");
			stringBuilder.Append(" , " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append(" ,0 ");
			stringBuilder.Append("  ) ");
			foreach (DataRow row in dtParam.Rows)
			{
				bizExecute.executeInsertQuery(stringBuilder.ToString(), row);
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append("  PROD_MONTH = @PROD_MONTH ");
			stringBuilder.Append(" ,PROD_STATE = @PROD_STATE ");
			stringBuilder.Append(" ,PROD_TYPE = @PROD_TYPE ");
			stringBuilder.Append(" ,PROD_GOLE = @PROD_GOLE ");
			stringBuilder.Append(" ,SALE_MONTH = @SALE_MONTH ");
			stringBuilder.Append(" ,MODEL_TYPE = @MODEL_TYPE ");
			stringBuilder.Append(" ,MODEL_SERISE = @MODEL_SERISE ");
			stringBuilder.Append(" ,MODEL_NO = @MODEL_NO ");
			stringBuilder.Append(" ,MODEL_TON = @MODEL_TON ");
			stringBuilder.Append(" ,INOUT_FLAG = @INOUT_FLAG ");
			stringBuilder.Append(" ,SHIP_COUNTRY = @SHIP_COUNTRY ");
			stringBuilder.Append(" ,ORDER_FLAG = @ORDER_FLAG ");
			stringBuilder.Append(" ,ORDER_FLAG2 = @ORDER_FLAG2 ");
			stringBuilder.Append(" ,GAORDER_NO = @GAORDER_NO ");
			stringBuilder.Append(" ,GAORDER_LINE = @GAORDER_LINE ");
			stringBuilder.Append(" ,JINORDER_NO = @JINORDER_NO ");
			stringBuilder.Append(" ,JINORDER_LINE = @JINORDER_LINE ");
			stringBuilder.Append(" ,ORDER_NO = @ORDER_NO ");
			stringBuilder.Append(" ,ORDER_LINE = @ORDER_LINE ");
			stringBuilder.Append(" ,PROD_HOGI = @PROD_HOGI ");
			stringBuilder.Append(" ,PART_CODE = @PART_CODE ");
			stringBuilder.Append(" ,ST_CODE = @ST_CODE ");
			stringBuilder.Append(" ,CVND_CONTENTS = @CVND_CONTENTS ");
			stringBuilder.Append(" ,PROD_SEND_DATE = @PROD_SEND_DATE ");
			stringBuilder.Append(" ,DUE_DATE = @DUE_DATE ");
			stringBuilder.Append(" ,INDUE_DATE = @INDUE_DATE ");
			stringBuilder.Append(" ,DUE_SEND = @DUE_SEND ");
			stringBuilder.Append(" ,ORD_DATE = @ORD_DATE ");
			stringBuilder.Append(" ,PROD_WEEK = @PROD_WEEK ");
			stringBuilder.Append(" ,MAIN_PROD = @MAIN_PROD ");
			stringBuilder.Append(" ,LAST_MONTH = @LAST_MONTH ");
			stringBuilder.Append(" ,NOW_MONTH = @NOW_MONTH ");
			stringBuilder.Append(" ,NEXT_MONTH = @NEXT_MONTH ");
			stringBuilder.Append(" ,PLAN_RATE = @PLAN_RATE ");
			stringBuilder.Append(" ,PLAN_EMP_RATE = @PLAN_EMP_RATE ");
			stringBuilder.Append(" ,YEAR_WEEK = @YEAR_WEEK ");
			stringBuilder.Append(" ,MONTH_WEEK = @MONTH_WEEK ");
			stringBuilder.Append(" ,INDUE_WEEK = @INDUE_WEEK ");
			stringBuilder.Append(" ,INDUE_MONTH_WEEK = @INDUE_MONTH_WEEK ");
			stringBuilder.Append(" ,SHIP_PLAN_DATE = @SHIP_PLAN_DATE ");
			stringBuilder.Append(" ,OLD_PROD_HOGI = @OLD_PROD_HOGI ");
			stringBuilder.Append(" ,OLD_ORDER_NO = @OLD_ORDER_NO ");
			stringBuilder.Append(" ,OLD_ORDER_LINE = @OLD_ORDER_LINE ");
			stringBuilder.Append(" ,SCOMMENT = @SCOMMENT ");
			stringBuilder.Append(" ,MDFY_DATE = GETDATE() ");
			stringBuilder.Append(" ,MDFY_EMP = " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append(" ,DATA_FLAG = 0 ");
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD2(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append("  SCOMMENT = @SCOMMENT ");
			stringBuilder.Append(" ,MDFY_DATE = GETDATE() ");
			stringBuilder.Append(" ,MDFY_EMP = " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD3(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append("  PROD_STATE = @PROD_STATE ");
			stringBuilder.Append(" ,MDFY_DATE = GETDATE() ");
			stringBuilder.Append(" ,MDFY_EMP = " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD4(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append("  PROD_TYPE = @PROD_TYPE ");
			stringBuilder.Append(" ,MDFY_DATE = GETDATE() ");
			stringBuilder.Append(" ,MDFY_EMP = " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD5(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append("  PROD_SEND_DATE = CONVERT(nvarchar(8),GETDATE(),112) ");
			stringBuilder.Append(" ,PROD_SEND_FLAG = '1' ");
			stringBuilder.Append(" ,MDFY_DATE = GETDATE() ");
			stringBuilder.Append(" ,MDFY_EMP = " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD6(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append(" REV_SEND_FLAG = '1' ");
			stringBuilder.Append(" ,MDFY_DATE = GETDATE() ");
			stringBuilder.Append(" ,MDFY_EMP = " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD7(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append(" APRTS_DATE = @APRTS_DATE ");
			stringBuilder.Append(" ,CTRL_DATE = @CTRL_DATE ");
			stringBuilder.Append(" ,PLAZA_DATE = @PLAZA_DATE ");
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND ORDER_NO = @ORDER_NO ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "ORDER_NO"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD8(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append(" PROD_MONTH = @PROD_MONTH ");
			stringBuilder.Append(" ,LAST_MONTH = @LAST_MONTH ");
			stringBuilder.Append(" ,NEXT_MONTH = @NEXT_MONTH ");
			stringBuilder.Append(" ,PLAN_RATE = @PLAN_RATE ");
			stringBuilder.Append(" ,INDUE_DATE = @INDUE_DATE ");
			stringBuilder.Append(" ,PLAN_EMP_RATE = @PLAN_EMP_RATE ");
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD9(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append("  SHIP_PLAN_DATE = @SHIP_PLAN_DATE ");
			stringBuilder.Append(" ,MDFY_DATE = GETDATE() ");
			stringBuilder.Append(" ,MDFY_EMP = " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD10(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append("  PLN_SAP_SEND_FLAG = @PLN_SAP_SEND_FLAG ");
			stringBuilder.Append(" ,MDFY_DATE = GETDATE() ");
			stringBuilder.Append(" ,MDFY_EMP = " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD11(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append("  SIM_FLAG = @SIM_FLAG ");
			stringBuilder.Append(" ,MDFY_DATE = GETDATE() ");
			stringBuilder.Append(" ,MDFY_EMP = " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD12(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append("  REV_SEND_FLAG = NULL ");
			stringBuilder.Append(" ,PROD_SEND_DATE = NULL ");
			stringBuilder.Append(" ,PROD_SEND_FLAG = NULL ");
			stringBuilder.Append(" ,SIM_FLAG = NULL ");
			stringBuilder.Append(" ,MDFY_EMP = " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append(" ,MDFY_DATE = GETDATE() ");
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UPD13(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append("  ORDER_NO = @ORDER_NO ");
			stringBuilder.Append(" ,ORDER_LINE = @ORDER_LINE ");
			stringBuilder.Append(" ,INDUE_DATE = @INDUE_DATE ");
			stringBuilder.Append(" ,PROD_MONTH = @PROD_MONTH ");
			stringBuilder.Append(" ,PROD_GOLE = @PROD_GOLE ");
			stringBuilder.Append(" ,SALE_MONTH = @SALE_MONTH ");
			stringBuilder.Append(" ,ORDER_FLAG = @ORDER_FLAG ");
			stringBuilder.Append(" ,JINORDER_NO = @JINORDER_NO ");
			stringBuilder.Append(" ,JINORDER_LINE = @JINORDER_LINE ");
			stringBuilder.Append(" ,MODEL_TYPE = @MODEL_TYPE ");
			stringBuilder.Append(" ,MODEL_SERISE = @MODEL_SERISE ");
			stringBuilder.Append(" ,MODEL_NO = @MODEL_NO ");
			stringBuilder.Append(" ,PART_CODE = @PART_CODE ");
			stringBuilder.Append(" ,ST_CODE = @ST_CODE ");
			stringBuilder.Append(" ,CVND_CONTENTS = @CVND_CONTENTS ");
			stringBuilder.Append(" ,DUE_DATE = @DUE_DATE ");
			stringBuilder.Append(" ,DUE_SEND = @DUE_SEND ");
			stringBuilder.Append(" ,INDUE_WEEK = @INDUE_WEEK ");
			stringBuilder.Append(" ,INDUE_MONTH_WEEK = @INDUE_MONTH_WEEK ");
			stringBuilder.Append(" ,MDFY_EMP = " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append(" ,MDFY_DATE = GETDATE() ");
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}

	public static void TORD_PRODUCT_UDE(DataTable dtParam, global::BizExecute.BizExecute bizExecute)
	{
		try
		{
			DataSet dataSet = new DataSet();
			if (dtParam.Rows.Count <= 0)
			{
				return;
			}
			StringBuilder stringBuilder = new StringBuilder();
			stringBuilder.Append(" UPDATE TORD_PRODUCT SET  ");
			stringBuilder.Append("  DATA_FLAG = @DATA_FLAG ");
			stringBuilder.Append(" ,DEL_REASON = @DEL_REASON ");
			stringBuilder.Append(" ,DEL_DATE = GETDATE() ");
			stringBuilder.Append(" ,DEL_EMP = " + UTIL.GetValidValue(ConnInfo.UserID));
			stringBuilder.Append("  WHERE PLT_CODE = @PLT_CODE ");
			stringBuilder.Append("  AND PROD_CODE = @PROD_CODE ");
			foreach (DataRow row in dtParam.Rows)
			{
				bool flag = true;
				if (!UTIL.ValidColumn(row, "PLT_CODE"))
				{
					flag = false;
				}
				if (!UTIL.ValidColumn(row, "PROD_CODE"))
				{
					flag = false;
				}
				if (flag)
				{
					bizExecute.executeUpdateQuery(stringBuilder.ToString(), row);
				}
			}
		}
		catch (Exception ex)
		{
			throw UTIL.SetException(ex, new StackFrame().GetMethod().Name);
		}
	}
}
