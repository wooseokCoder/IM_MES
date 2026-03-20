using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using BizManager;
using CodeHelperManager;
using ControlManager;
using DevExpress.Utils;
using DevExpress.XtraBars;
using DevExpress.XtraEditors;
using DevExpress.XtraEditors.Controls;
using DevExpress.XtraGrid.Views.Base;
using DevExpress.XtraLayout;
using DevExpress.XtraLayout.Utils;
using DevExpress.XtraTab;
using GemBox.Spreadsheet;

namespace ORD;

public sealed class ORD07A_M1A : BaseMenu
{
	private IContainer components = null;

	private acBarManager acBarManager1;

	private acBar bar2;

	private acBar bar3;

	private BarDockControl barDockControlTop;

	private BarDockControl barDockControlBottom;

	private BarDockControl barDockControlLeft;

	private BarDockControl barDockControlRight;

	private acBarButtonItem barItemSearch;

	private acBarStaticItem statusBarLog;

	private acLayoutControl acLayoutControl1;

	private acLayoutControlGroup layoutControlGroup1;

	private acDateEdit acDateEdit2;

	private acDateEdit acDateEdit1;

	private acCheckedComboBoxEdit acCheckedComboBoxEdit1;

	private acLayoutControlItem acLayoutControlItem1;

	private acLayoutControlItem acLayoutControlItem2;

	private acLayoutControlItem acLayoutControlItem3;

	private acLabelControl acLabelControl1;

	private EmptySpaceItem emptySpaceItem1;

	private acLayoutControlItem acLayoutControlItem5;

	private acGroupControl acGroupControl1;

	private acSplitContainerControl acSplitContainerControl1;

	private acGridControl acGridControl1;

	private acGridView acGridView1;

	private EmptySpaceItem emptySpaceItem3;

	private acTabControl acTabControl1;

	private acTabPage acTabPage1;

	private acTextEdit acTextEdit1;

	private acItem acItem1;

	private acLayoutControlItem acLayoutControlItem4;

	private acLayoutControlItem acLayoutControlItem7;

	private acSplitContainerControl acSplitContainerControl2;

	private acGridControl acGridControl2;

	private acGridView acGridView2;

	private acTabPage acTabPage2;

	private acSplitContainerControl acSplitContainerControl3;

	private acGroupControl acGroupControl2;

	private acSplitContainerControl acSplitContainerControl4;

	private acGridControl acGridControl3;

	private acGridView acGridView3;

	private acGridControl acGridControl4;

	private acGridView acGridView4;

	private acLayoutControl acLayoutControl2;

	private acDateEdit acDateEdit4;

	private acLabelControl acLabelControl2;

	private acDateEdit acDateEdit3;

	private acCheckedComboBoxEdit acCheckedComboBoxEdit2;

	private acLayoutControlGroup acLayoutControlGroup1;

	private acLayoutControlItem acLayoutControlItem8;

	private EmptySpaceItem emptySpaceItem2;

	private acLayoutControlItem acLayoutControlItem9;

	private acLayoutControlItem acLayoutControlItem10;

	private acLayoutControlItem acLayoutControlItem11;

	private EmptySpaceItem emptySpaceItem4;

	private acItem acItem2;

	private acLayoutControlItem acLayoutControlItem6;

	private acBarButtonItem acBarButtonItem1;

	private acBarButtonItem acBarButtonItem2;

	public override acBarManager BarManager => acBarManager1;

	public override string InstantLog
	{
		set
		{
			statusBarLog.Caption = value;
		}
	}

	public override void BarCodeScanInput(string barcode)
	{
	}

	public ORD07A_M1A()
	{
		InitializeComponent();
	}

	public override void ChildContainerInit(Control sender)
	{
		if (sender == acLayoutControl1)
		{
			acLayoutControl acLayoutControl = sender as acLayoutControl;
			acLayoutControl.GetEditor("DATE").Value = "YPGO_DATE";
			acLayoutControl.GetEditor("S_DATE").Value = DateTime.Now.AddDays(-7.0);
			acLayoutControl.GetEditor("E_DATE").Value = DateTime.Now;
		}
		if (sender == this.acLayoutControl2)
		{
			acLayoutControl acLayoutControl2 = sender as acLayoutControl;
			acLayoutControl2.GetEditor("DATE").Value = "SHIP_DATE";
			acLayoutControl2.GetEditor("S_DATE").Value = DateTime.Now.AddDays(-7.0);
			acLayoutControl2.GetEditor("E_DATE").Value = DateTime.Now;
		}
		base.ChildContainerInit(sender);
	}

	public override void MenuInit()
	{
		acGridView1.GridType = acGridView.emGridType.AUTO_COL;
		acGridView1.AddTextEdit("VEN_CODE", "거래처코드", "40957", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView1.AddTextEdit("VEN_NAME", "거래처", "FTO56DTU", useReSourceID: false, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.GridType = acGridView.emGridType.SEARCH;
		acGridView2.AddCheckEdit("SEL", "선택", "40290", useReSourceID: true, allowEdit: true, visible: true, acGridView.emCheckEditDataType._STRING);
		acGridView2.AddLookUpEdit("BAL_FLAG", "구분", "41587", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, "S047");
		acGridView2.AddTextEdit("YPGO_ID", "입고번호", "42497", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("BALJU_NUM", "발주번호", "40203", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("BALJU_SEQ", "발주순번", "42597", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddDateEdit("BALJU_DATE", "발주일", "40206", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: false, isRequired: false, acGridView.emDateMask.SHORT_DATE);
		acGridView2.AddDateEdit("DUE_DATE", "입고예정일", "S06YYU8H", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: false, isRequired: false, acGridView.emDateMask.SHORT_DATE);
		acGridView2.AddDateEdit("DATE", "입고일", "40515", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emDateMask.SHORT_DATE);
		acGridView2.AddTextEdit("VEN_CODE", "거래처코드", "40957", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("VEN_NAME", "거래처명", "40956", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("BALJU_REG_EMP", "발주자코드", "N089BVX6", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("BALJU_REG_EMP_NAME", "발주자명", "HEP4DK2T", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("ITEM_CODE", "수주코드", "40377", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("ITEM_NAME", "수주명", "41906", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("PROD_CODE", "금형코드", "40900", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("PROD_NAME", "금형명", "40901", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("PART_CODE", "부품코드", "40239", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("PART_NAME", "부품명", "40234", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddLookUpEdit("MAT_LTYPE", "대분류", "40132", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, "M001");
		acGridView2.AddLookUpEdit("MAT_MTYPE", "중분류", "40630", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, "M002");
		acGridView2.AddLookUpEdit("MAT_STYPE", "소분류", "40338", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, "M008");
		acGridView2.AddLookUpEdit("PART_PRODTYPE", "부품제작구분", "40238", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, "M007");
		acGridView2.AddTextEdit("PART_QLTY", "재질코드", "QGD6SY0U", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("PART_QLTY_NAME", "재질명", "40572", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("DRAW_NO", "도면번호", "40145", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("PART_SPEC", "소재사양", "42544", useReSourceID: true, HorzAlignment.Near, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("PART_SPEC1", "완성사양", "42545", useReSourceID: true, HorzAlignment.Near, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("B_MAT_SPEC", "발주규격", "7MROZYWS", useReSourceID: true, HorzAlignment.Near, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("B_WEIGHT", "발주중량", "GOC9BNEP", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("PROC_CODE", "공정코드", "40920", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("PROC_NAME", "공정명", "40921", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("QTY", "수량", "40345", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.QTY);
		acGridView2.AddLookUpEdit("MAT_UNIT", "단위", "40123", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, "M003");
		acGridView2.AddTextEdit("UNIT_COST", "단가", "40121", useReSourceID: true, HorzAlignment.Far, allowEdit: true, visible: true, isRequired: false, acGridView.emTextEditMask.MONEY);
		acGridView2.AddTextEdit("AMT", "금액", "40084", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.MONEY);
		acGridView2.AddTextEdit("REG_EMP", "입고자코드", "1OFHCPFL", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("REG_EMP_NAME", "입고자명", "CFW2EN1I", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("SCOMMENT", "비고", "ARYZ726K", useReSourceID: true, HorzAlignment.Near, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("VEN_BIZ_NO", "사업자등록번호", "40256", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("VEN_ADDRESS", "주소", "40626", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("VEN_TEL", "전화번호", "WCO6Q0OP", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("VEN_FAX", "FAX", "40713", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("VEN_CEO", "대표자명", "40139", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddLookUpEdit("VEN_CONDITIONS", "업태", "40421", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: false, isRequired: false, "C017");
		acGridView2.AddTextEdit("VEN_PRODUCTS", "취급품목", "40683", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView2.AddTextEdit("VEN_EMAIL", "E-Mail", "40790", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView3.GridType = acGridView.emGridType.AUTO_COL;
		acGridView3.AddTextEdit("VEN_CODE", "거래처코드", "40957", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView3.AddTextEdit("VEN_NAME", "거래처", "FTO56DTU", useReSourceID: false, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.GridType = acGridView.emGridType.SEARCH;
		acGridView4.AddCheckEdit("SEL", "선택", "40290", useReSourceID: true, allowEdit: true, visible: true, acGridView.emCheckEditDataType._STRING);
		acGridView4.AddTextEdit("SHIP_ID", "출하ID", "", useReSourceID: false, HorzAlignment.Center, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddDateEdit("DATE", "출하일", "42362", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emDateMask.SHORT_DATE);
		acGridView4.AddTextEdit("SHIP_EMP", "출하 담당자", "", useReSourceID: false, HorzAlignment.Center, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddTextEdit("SHIP_EMP_NAME", "출하 담당자", "", useReSourceID: false, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddTextEdit("VEN_CODE", "수주처코드", "FYVPQ9JZ", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddTextEdit("VEN_NAME", "수주처명", "42428", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddTextEdit("ITEM_CODE", "수주코드", "40377", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddTextEdit("ITEM_NAME", "수주명", "41906", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddTextEdit("PROD_CODE", "금형코드", "40900", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddLookUpEdit("MAT_TYPE", "자재형태", "N05MMEKM", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, "S016");
		acGridView4.AddTextEdit("PART_CODE", "부품코드", "40239", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddTextEdit("PART_NAME", "부품명", "40234", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddTextEdit("DRAW_NO", "도면번호", "40145", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddTextEdit("MAT_SPEC", "소재사양", "42544", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddTextEdit("B_MAT_SPEC", "완성사양", "42545", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddTextEdit("SHIP_QTY", "출하 수량", "", useReSourceID: false, HorzAlignment.Far, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.QTY);
		acGridView4.AddLookUpEdit("MAT_UNIT", "단위", "40123", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, "M003");
		acGridView4.AddTextEdit("UNIT_COST", "단가", "40121", useReSourceID: true, HorzAlignment.Far, allowEdit: true, visible: true, isRequired: false, acGridView.emTextEditMask.MONEY);
		acGridView4.AddTextEdit("AMT", "금액", "40084", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.MONEY);
		acGridView4.AddTextEdit("SCOMMENT", "비고", "", useReSourceID: false, HorzAlignment.Center, allowEdit: false, visible: true, isRequired: false, acGridView.emTextEditMask.NONE);
		acGridView4.AddTextEdit("VEN_BIZ_NO", "사업자등록번호", "40256", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.MONEY);
		acGridView4.AddTextEdit("VEN_ADDRESS", "주소", "40626", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.MONEY);
		acGridView4.AddTextEdit("VEN_TEL", "전화번호", "WCO6Q0OP", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.MONEY);
		acGridView4.AddTextEdit("VEN_FAX", "FAX", "40713", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.MONEY);
		acGridView4.AddTextEdit("VEN_CEO", "대표자명", "40139", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.MONEY);
		acGridView4.AddLookUpEdit("VEN_CONDITIONS", "업태", "40421", useReSourceID: true, HorzAlignment.Center, allowEdit: false, visible: false, isRequired: false, "M003");
		acGridView4.AddTextEdit("VEN_PRODUCTS", "취급품목", "40683", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.MONEY);
		acGridView4.AddTextEdit("VEN_EMAIL", "E-Mail", "40790", useReSourceID: true, HorzAlignment.Far, allowEdit: false, visible: false, isRequired: false, acGridView.emTextEditMask.MONEY);
		acCheckedComboBoxEdit1.AddItem("입고일", useResourceID: true, "40515", "YPGO_DATE", true, false);
		acCheckedComboBoxEdit1.AddItem("발주일", useResourceID: true, "40206", "BALJU_DATE", true, false);
		acCheckedComboBoxEdit1.AddItem("입고예정일", useResourceID: true, "S06YYU8H", "DUE_DATE", true, false);
		acCheckedComboBoxEdit2.AddItem("납기일", useResourceID: true, "40111", "DUE_DATE", true, false);
		acCheckedComboBoxEdit2.AddItem("출하일", useResourceID: false, "", "SHIP_DATE", true, false);
		acLayoutControl1.OnValueKeyDown += acLayoutControl1_OnValueKeyDown;
		acLayoutControl1.OnValueChanged += acLayoutControl1_OnValueChanged;
		acLayoutControl2.OnValueKeyDown += acLayoutControl2_OnValueKeyDown;
		acLayoutControl2.OnValueChanged += acLayoutControl2_OnValueChanged;
		acGridView1.FocusedRowChanged += acGridView1_FocusedRowChanged;
		acGridView3.FocusedRowChanged += acGridView3_FocusedRowChanged;
		acGridView2.CellValueChanged += acGridView2_CellValueChanged;
		acGridView4.CellValueChanged += acGridView4_CellValueChanged;
		base.MenuInit();
	}

	private void acGridView4_CellValueChanged(object sender, CellValueChangedEventArgs e)
	{
		string fieldName = e.Column.FieldName;
		string text = fieldName;
		if (text == "UNIT_COST")
		{
			acGridView4.SetRowCellValue(e.RowHandle, "AMT", e.Value.toDouble() * acGridView4.GetRowCellDisplayText(e.RowHandle, "QTY").toDouble());
		}
	}

	private void acGridView2_CellValueChanged(object sender, CellValueChangedEventArgs e)
	{
		string fieldName = e.Column.FieldName;
		string text = fieldName;
		if (text == "UNIT_COST")
		{
			acGridView2.SetRowCellValue(e.RowHandle, "AMT", e.Value.toDouble() * acGridView2.GetRowCellDisplayText(e.RowHandle, "QTY").toDouble());
		}
	}

	private void acGridView3_FocusedRowChanged(object sender, FocusedRowChangedEventArgs e)
	{
		GetDetail();
	}

	private void acGridView1_FocusedRowChanged(object sender, FocusedRowChangedEventArgs e)
	{
		GetDetail();
	}

	private void acLayoutControl1_OnValueChanged(object sender, IBaseEditControl info, object newValue)
	{
		acLayoutControl acLayoutControl = sender as acLayoutControl;
		string columnName = info.ColumnName;
		string text = columnName;
		if (text == "DATE")
		{
			if (newValue.EqualsEx(string.Empty))
			{
				acLayoutControl.GetEditor("S_DATE").isRequired = false;
				acLayoutControl.GetEditor("E_DATE").isRequired = false;
			}
			else
			{
				acLayoutControl.GetEditor("S_DATE").isRequired = true;
				acLayoutControl.GetEditor("E_DATE").isRequired = true;
			}
		}
	}

	private void acLayoutControl2_OnValueChanged(object sender, IBaseEditControl info, object newValue)
	{
		acLayoutControl acLayoutControl = sender as acLayoutControl;
		string columnName = info.ColumnName;
		string text = columnName;
		if (text == "DATE")
		{
			if (newValue.EqualsEx(string.Empty))
			{
				acLayoutControl.GetEditor("S_DATE").isRequired = false;
				acLayoutControl.GetEditor("E_DATE").isRequired = false;
			}
			else
			{
				acLayoutControl.GetEditor("S_DATE").isRequired = true;
				acLayoutControl.GetEditor("E_DATE").isRequired = true;
			}
		}
	}

	private void acLayoutControl1_OnValueKeyDown(object sender, IBaseEditControl info, KeyEventArgs e)
	{
		if (e.KeyData == Keys.Return)
		{
			Search();
		}
	}

	private void acLayoutControl2_OnValueKeyDown(object sender, IBaseEditControl info, KeyEventArgs e)
	{
		if (e.KeyData == Keys.Return)
		{
			Search();
		}
	}

	private void Search()
	{
		string selectedContainerName = acTabControl1.GetSelectedContainerName();
		string text = selectedContainerName;
		if (!(text == "IN"))
		{
			if (!(text == "OUT") || !acLayoutControl2.ValidCheck())
			{
				return;
			}
			DataRow dataRow = acLayoutControl2.CreateParameterRow();
			DataTable dataTable = new DataTable("RQSTDT");
			dataTable.Columns.Add("PLT_CODE", typeof(string));
			dataTable.Columns.Add("ITEM_CODE", typeof(string));
			dataTable.Columns.Add("S_DUE_DATE", typeof(string));
			dataTable.Columns.Add("E_DUE_DATE", typeof(string));
			dataTable.Columns.Add("S_SHIP_DATE", typeof(string));
			dataTable.Columns.Add("E_SHIP_DATE", typeof(string));
			DataRow dataRow2 = dataTable.NewRow();
			dataRow2["PLT_CODE"] = acInfo.PLT_CODE;
			dataRow2["ITEM_CODE"] = dataRow["ITEM_CODE"];
			foreach (string item in acCheckedComboBoxEdit2.GetKeyChecked())
			{
				string text3 = item;
				string text4 = text3;
				if (!(text4 == "DUE_DATE"))
				{
					if (text4 == "SHIP_DATE")
					{
						dataRow2["S_SHIP_DATE"] = dataRow["S_DATE"];
						dataRow2["E_SHIP_DATE"] = dataRow["E_DATE"];
					}
				}
				else
				{
					dataRow2["S_DUE_DATE"] = dataRow["S_DATE"];
					dataRow2["E_DUE_DATE"] = dataRow["E_DATE"];
				}
			}
			dataTable.Rows.Add(dataRow2);
			DataSet dataSet = new DataSet();
			dataSet.Tables.Add(dataTable);
			BizRun.QBizRun.ExecuteService(this, QBiz.emExecuteType.LOAD, "ORD07A_SER3", dataSet, "RQSTDT", "RSLTDT", QuickSearch, QuickException);
		}
		else
		{
			if (!acLayoutControl1.ValidCheck())
			{
				return;
			}
			DataRow dataRow3 = acLayoutControl1.CreateParameterRow();
			DataTable dataTable2 = new DataTable("RQSTDT");
			dataTable2.Columns.Add("PLT_CODE", typeof(string));
			dataTable2.Columns.Add("BALJU_NUM", typeof(string));
			dataTable2.Columns.Add("S_BALJU_DATE", typeof(string));
			dataTable2.Columns.Add("E_BALJU_DATE", typeof(string));
			dataTable2.Columns.Add("S_DUE_DATE", typeof(string));
			dataTable2.Columns.Add("E_DUE_DATE", typeof(string));
			dataTable2.Columns.Add("S_YPGO_DATE", typeof(string));
			dataTable2.Columns.Add("E_YPGO_DATE", typeof(string));
			dataTable2.Columns.Add("ITEM_CODE", typeof(string));
			DataRow dataRow4 = dataTable2.NewRow();
			dataRow4["PLT_CODE"] = acInfo.PLT_CODE;
			dataRow4["BALJU_NUM"] = dataRow3["BALJU_NUM"];
			using (List<string>.Enumerator enumerator2 = acCheckedComboBoxEdit1.GetKeyChecked().GetEnumerator())
			{
				while (enumerator2.MoveNext())
				{
					switch (enumerator2.Current)
					{
					case "BALJU_DATE":
						dataRow4["S_BALJU_DATE"] = dataRow3["S_DATE"];
						dataRow4["E_BALJU_DATE"] = dataRow3["E_DATE"];
						break;
					case "DUE_DATE":
						dataRow4["S_DUE_DATE"] = dataRow3["S_DATE"];
						dataRow4["E_DUE_DATE"] = dataRow3["E_DATE"];
						break;
					case "YPGO_DATE":
						dataRow4["S_YPGO_DATE"] = dataRow3["S_DATE"];
						dataRow4["E_YPGO_DATE"] = dataRow3["E_DATE"];
						break;
					}
				}
			}
			dataRow4["ITEM_CODE"] = dataRow3["ITEM_CODE"];
			dataTable2.Rows.Add(dataRow4);
			DataSet dataSet2 = new DataSet();
			dataSet2.Tables.Add(dataTable2);
			BizRun.QBizRun.ExecuteService(this, QBiz.emExecuteType.LOAD, "ORD07A_SER", dataSet2, "RQSTDT", "RSLTDT", QuickSearch, QuickException);
		}
	}

	private void QuickException(object sender, QBiz qBiz, BizException ex)
	{
		acMessageBox.Show(this, ex);
	}

	private void QuickSearch(object sender, QBiz qBiz, QBiz.ExcuteCompleteArgs e)
	{
		try
		{
			if (e.result.Tables["RSLTDT"].Rows.Count != 0)
			{
				DataRow dataRow = e.result.Tables["RSLTDT"].NewRow();
				dataRow["PLT_CODE"] = e.result.Tables["RSLTDT"].Rows[0]["PLT_CODE"];
				dataRow["VEN_NAME"] = "전체";
				dataRow["VEN_CODE"] = DBNull.Value;
				e.result.Tables["RSLTDT"].Rows.InsertAt(dataRow, 0);
			}
			string selectedContainerName = acTabControl1.GetSelectedContainerName();
			string text = selectedContainerName;
			if (!(text == "IN"))
			{
				if (text == "OUT")
				{
					acGridView3.GridControl.DataSource = e.result.Tables["RSLTDT"];
				}
			}
			else
			{
				acGridView1.GridControl.DataSource = e.result.Tables["RSLTDT"];
			}
		}
		catch (Exception ex)
		{
			acMessageBox.Show(this, ex);
		}
	}

	private void barItemSearch_ItemClick(object sender, ItemClickEventArgs e)
	{
		try
		{
			Search();
		}
		catch (Exception ex)
		{
			acMessageBox.Show(this, ex);
		}
	}

	private void GetDetail()
	{
		DataRow dataRow = null;
		DataTable dataTable = new DataTable("RQSTDT");
		dataTable.Columns.Add("PLT_CODE", typeof(string));
		dataTable.Columns.Add("VEN_CODE", typeof(string));
		dataTable.Columns.Add("S_BALJU_DATE", typeof(string));
		dataTable.Columns.Add("E_BALJU_DATE", typeof(string));
		dataTable.Columns.Add("S_DUE_DATE", typeof(string));
		dataTable.Columns.Add("E_DUE_DATE", typeof(string));
		dataTable.Columns.Add("S_YPGO_DATE", typeof(string));
		dataTable.Columns.Add("E_YPGO_DATE", typeof(string));
		dataTable.Columns.Add("S_SHIP_DATE", typeof(string));
		dataTable.Columns.Add("E_SHIP_DATE", typeof(string));
		DataRow dataRow2 = acLayoutControl1.CreateParameterRow();
		DataRow dataRow3 = acLayoutControl2.CreateParameterRow();
		string selectedContainerName = acTabControl1.GetSelectedContainerName();
		string text = selectedContainerName;
		if (!(text == "IN"))
		{
			if (!(text == "OUT"))
			{
				return;
			}
			dataRow = acGridView3.GetFocusedDataRow();
			if (dataRow == null)
			{
				acGridView4.ClearRow();
				return;
			}
			DataRow dataRow4 = dataTable.NewRow();
			dataRow4["PLT_CODE"] = acInfo.PLT_CODE;
			dataRow4["VEN_CODE"] = dataRow["VEN_CODE"];
			foreach (string item in acCheckedComboBoxEdit2.GetKeyChecked())
			{
				string text3 = item;
				string text4 = text3;
				if (!(text4 == "DUE_DATE"))
				{
					if (text4 == "SHIP_DATE")
					{
						dataRow4["S_SHIP_DATE"] = dataRow3["S_DATE"];
						dataRow4["E_SHIP_DATE"] = dataRow3["E_DATE"];
					}
				}
				else
				{
					dataRow4["S_DUE_DATE"] = dataRow3["S_DATE"];
					dataRow4["E_DUE_DATE"] = dataRow3["E_DATE"];
				}
			}
			dataTable.Rows.Add(dataRow4);
			DataSet dataSet = new DataSet();
			dataSet.Tables.Add(dataTable);
			BizRun.QBizRun.ExecuteService(this, QBiz.emExecuteType.LOAD_DETAIL, "ORD07A_SER4", dataSet, "RQSTDT", "RSLTDT", QuickSearchDetail, QuickException);
			return;
		}
		dataRow = acGridView1.GetFocusedDataRow();
		if (dataRow == null)
		{
			acGridView2.ClearRow();
			return;
		}
		DataRow dataRow5 = dataTable.NewRow();
		dataRow5["PLT_CODE"] = acInfo.PLT_CODE;
		dataRow5["VEN_CODE"] = dataRow["VEN_CODE"];
		using (List<string>.Enumerator enumerator2 = acCheckedComboBoxEdit1.GetKeyChecked().GetEnumerator())
		{
			while (enumerator2.MoveNext())
			{
				switch (enumerator2.Current)
				{
				case "BALJU_DATE":
					dataRow5["S_BALJU_DATE"] = dataRow2["S_DATE"];
					dataRow5["E_BALJU_DATE"] = dataRow2["E_DATE"];
					break;
				case "DUE_DATE":
					dataRow5["S_DUE_DATE"] = dataRow2["S_DATE"];
					dataRow5["E_DUE_DATE"] = dataRow2["E_DATE"];
					break;
				case "YPGO_DATE":
					dataRow5["S_YPGO_DATE"] = dataRow2["S_DATE"];
					dataRow5["E_YPGO_DATE"] = dataRow2["E_DATE"];
					break;
				}
			}
		}
		dataTable.Rows.Add(dataRow5);
		DataSet dataSet2 = new DataSet();
		dataSet2.Tables.Add(dataTable);
		BizRun.QBizRun.ExecuteService(this, QBiz.emExecuteType.LOAD_DETAIL, "ORD07A_SER2", dataSet2, "RQSTDT", "RSLTDT", QuickSearchDetail, QuickException);
	}

	private void QuickSearchDetail(object sender, QBiz qBiz, QBiz.ExcuteCompleteArgs e)
	{
		try
		{
			string selectedContainerName = acTabControl1.GetSelectedContainerName();
			string text = selectedContainerName;
			if (!(text == "IN"))
			{
				if (text == "OUT")
				{
					acGridView4.GridControl.DataSource = e.result.Tables["RSLTDT"];
				}
			}
			else
			{
				acGridView2.GridControl.DataSource = e.result.Tables["RSLTDT"];
			}
			SetLog(e.executeType, e.result.Tables["RSLTDT"].Rows.Count, e.executeTime);
		}
		catch (Exception ex)
		{
			acMessageBox.Show(this, ex);
		}
	}

	private void acBarButtonItem1_ItemClick(object sender, ItemClickEventArgs e)
	{
		try
		{
			if (acMessageBox.Show(this, "엑셀 내보내기를 하시겠습니까?", "5DE1YPBV", useResouceID: true, acMessageBox.emMessageBoxType.YESNO) == DialogResult.No)
			{
				return;
			}
			DataView dataView = new DataView();
			DataRow dataRow = null;
			DataTable dataTable = new DataTable();
			DataTable dataTable2 = new DataTable();
			string fileName = "";
			string selectedContainerName = acTabControl1.GetSelectedContainerName();
			string text = selectedContainerName;
			if (!(text == "IN"))
			{
				if (text == "OUT")
				{
					if (acGridView4.FocusedRowHandle < 0)
					{
						return;
					}
					acGridView4.EndEditor();
					dataView = acGridView4.GetDataSourceView("SEL = '1'");
					dataRow = acGridView4.GetFocusedDataRow();
					dataTable = dataRow.NewTable();
					dataTable.TableName = "M";
					dataTable2 = dataView.ToTable();
					dataTable2.TableName = "D";
					fileName = dataRow["VEN_NAME"].ToString() + " 매출 원장";
				}
			}
			else
			{
				if (acGridView2.FocusedRowHandle < 0)
				{
					return;
				}
				acGridView2.EndEditor();
				dataView = acGridView2.GetDataSourceView("SEL = '1'");
				dataRow = acGridView2.GetFocusedDataRow();
				dataTable = dataRow.NewTable();
				dataTable.TableName = "M";
				dataTable2 = dataView.ToTable();
				dataTable2.TableName = "D";
				fileName = dataRow["VEN_NAME"].ToString() + " 매입 원장";
			}
			if (dataView.Count == 0)
			{
				return;
			}
			SaveFileDialog saveFileDialog = new SaveFileDialog();
			saveFileDialog.Filter = "Excel Files (.xls)|*.xls";
			saveFileDialog.Title = "저장할 위치를 입력하여 주십시오.";
			saveFileDialog.FileName = fileName;
			if (saveFileDialog.ShowDialog() != DialogResult.OK)
			{
				return;
			}
			SpreadsheetInfo.SetLicense("EORI-HF5T-MS0D-LVMH");
			string fileName2 = saveFileDialog.FileName;
			ExcelFile excelFile = new ExcelFile();
			Stream stream = new MemoryStream(Resource.ledger);
			excelFile.LoadXls(stream);
			stream.Close();
			ExcelWorksheet excelWorksheet = excelFile.Worksheets[0];
			excelWorksheet.Cells[0, 1].Value = dataRow["VEN_NAME"];
			excelWorksheet.Cells[2, 7].Value = dataView[0]["VEN_BIZ_NO"];
			excelWorksheet.Cells[3, 2].Value = dataView[0]["VEN_ADDRESS"];
			excelWorksheet.Cells[3, 5].Value = "TEL : " + dataView[0]["VEN_TEL"]?.ToString() + ", FAX : " + dataView[0]["VEN_FAX"];
			excelWorksheet.Cells[4, 2].Value = dataView[0]["VEN_CEO"];
			excelWorksheet.Cells[4, 5].Value = acInfo.StdCodes.GetNameByCode("C017", dataView[0]["VEN_CONDITIONS"]);
			excelWorksheet.Cells[4, 9].Value = dataView[0]["VEN_PRODUCTS"];
			excelWorksheet.Cells[5, 7].Value = dataView[0]["VEN_EMAIL"];
			excelWorksheet.Cells[6, 3].Value = dataView[0]["VEN_CHARGE_EMP"];
			excelWorksheet.Cells[6, 5].Value = dataView[0]["VEN_CHARGE_HP"];
			for (int i = 0; i < dataView.Count; i++)
			{
				if (i < 28)
				{
					excelWorksheet.Cells[i + 9, 1].Value = dataView[i]["DATE"].toDateString("yy/MM/dd");
					excelWorksheet.Cells[i + 9, 2].Value = dataView[i]["PART_NAME"];
					excelWorksheet.Cells[i + 9, 3].Value = dataView[i]["DRAW_NO"];
					excelWorksheet.Cells[i + 9, 5].Value = dataView[i]["QTY"];
					excelWorksheet.Cells[i + 9, 6].Value = dataView[i]["UNIT_COST"];
					excelWorksheet.Cells[i + 9, 7].Value = dataView[i]["AMT"];
					excelWorksheet.Cells[i + 9, 9].Value = dataView[i]["SCOMMENT"];
				}
				else if (i < 65)
				{
					excelWorksheet.Cells[i + 11, 1].Value = dataView[i]["DATE"].toDateString("yy/MM/dd");
					excelWorksheet.Cells[i + 11, 2].Value = dataView[i]["PART_NAME"];
					excelWorksheet.Cells[i + 11, 3].Value = dataView[i]["DRAW_NO"];
					excelWorksheet.Cells[i + 11, 5].Value = dataView[i]["QTY"];
					excelWorksheet.Cells[i + 11, 6].Value = dataView[i]["UNIT_COST"];
					excelWorksheet.Cells[i + 11, 7].Value = dataView[i]["AMT"];
					excelWorksheet.Cells[i + 11, 9].Value = dataView[i]["SCOMMENT"];
				}
				else
				{
					excelWorksheet.Cells[i + 11, 1].Value = dataView[i]["DATE"].toDateString("yy/MM/dd");
					excelWorksheet.Cells[i + 11, 2].Value = dataView[i]["PART_NAME"];
					excelWorksheet.Cells[i + 11, 3].Value = dataView[i]["DRAW_NO"];
					excelWorksheet.Cells.GetSubrangeAbsolute(i + 11, 3, i + 11, 4).Merged = true;
					excelWorksheet.Cells[i + 11, 5].Value = dataView[i]["QTY"];
					excelWorksheet.Cells[i + 11, 6].Value = dataView[i]["UNIT_COST"];
					excelWorksheet.Cells[i + 11, 7].Value = dataView[i]["AMT"];
					excelWorksheet.Cells.GetSubrangeAbsolute(i + 11, 7, i + 11, 8).Merged = true;
					excelWorksheet.Cells.GetSubrangeAbsolute(i + 11, 7, i + 11, 8).Style.NumberFormat = "₩_-* #,##0_-;-* #,##0_-;_-* -_-;_-@_-";
					excelWorksheet.Cells[i + 11, 9].Value = dataView[i]["SCOMMENT"];
					excelWorksheet.Cells.GetSubrangeAbsolute(i + 11, 9, i + 11, 10).Merged = true;
				}
			}
			if (saveFileDialog.FilterIndex == 1)
			{
				excelFile.SaveXls(fileName2);
			}
			else
			{
				excelFile.SaveXlsx(fileName2);
			}
			if (acMessageBox.Show(this, "파일을 여시겠습니까?", "C5FDPXF8", useResouceID: true, acMessageBox.emMessageBoxType.YESNO) == DialogResult.Yes)
			{
				Process.Start(fileName2);
			}
		}
		catch (Exception ex)
		{
			acMessageBox.Show(this, ex);
		}
	}

	private void acBarButtonItem2_ItemClick(object sender, ItemClickEventArgs e)
	{
		try
		{
			DataTable dataTable = new DataTable();
			DataTable dataTable2 = new DataTable("RQSTDT");
			dataTable2.Columns.Add("PLT_CODE", typeof(string));
			dataTable2.Columns.Add("TYPE", typeof(string));
			dataTable2.Columns.Add("BALJU_NUM", typeof(string));
			dataTable2.Columns.Add("BALJU_SEQ", typeof(string));
			dataTable2.Columns.Add("UNIT_COST", typeof(decimal));
			string selectedContainerName = acTabControl1.GetSelectedContainerName();
			string text = selectedContainerName;
			if (!(text == "IN"))
			{
				if (text == "OUT")
				{
					dataTable = acGridView4.GridControl.DataSource as DataTable;
				}
			}
			else
			{
				dataTable = acGridView2.GridControl.DataSource as DataTable;
			}
			DataRow[] array = dataTable.Select("SEL = '1'");
			DataRow[] array2 = array;
			foreach (DataRow dataRow in array2)
			{
				DataRow dataRow2 = dataTable2.NewRow();
				dataRow2["PLT_CODE"] = dataRow["PLT_CODE"];
				dataRow2["TYPE"] = acTabControl1.GetSelectedContainerName();
				dataRow2["BALJU_NUM"] = dataRow["BALJU_NUM"];
				dataRow2["BALJU_SEQ"] = dataRow["BALJU_SEQ"];
				dataRow2["UNIT_COST"] = dataRow["UNIT_COST"];
				dataTable2.Rows.Add(dataRow2);
			}
			DataSet dataSet = new DataSet();
			dataSet.Tables.Add(dataTable2);
			BizRun.QBizRun.ExecuteService(this, "ORD07A_INS", dataSet, "RQSTDT", "RSLTDT");
		}
		catch (Exception ex)
		{
			acMessageBox.Show(this, ex);
		}
	}

	protected override void Dispose(bool disposing)
	{
		if (disposing && components != null)
		{
			components.Dispose();
		}
		base.Dispose(disposing);
	}

	private void InitializeComponent()
	{
		this.components = new System.ComponentModel.Container();
		DevExpress.Utils.SerializableAppearanceObject appearance = new DevExpress.Utils.SerializableAppearanceObject();
		System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ORD.ORD07A_M1A));
		DevExpress.Utils.SerializableAppearanceObject appearance2 = new DevExpress.Utils.SerializableAppearanceObject();
		DevExpress.Utils.SerializableAppearanceObject appearance3 = new DevExpress.Utils.SerializableAppearanceObject();
		DevExpress.Utils.SerializableAppearanceObject appearance4 = new DevExpress.Utils.SerializableAppearanceObject();
		this.acBarManager1 = new ControlManager.acBarManager(this.components);
		this.bar2 = new ControlManager.acBar();
		this.barItemSearch = new ControlManager.acBarButtonItem();
		this.acBarButtonItem1 = new ControlManager.acBarButtonItem();
		this.acBarButtonItem2 = new ControlManager.acBarButtonItem();
		this.bar3 = new ControlManager.acBar();
		this.statusBarLog = new ControlManager.acBarStaticItem();
		this.barDockControlTop = new DevExpress.XtraBars.BarDockControl();
		this.barDockControlBottom = new DevExpress.XtraBars.BarDockControl();
		this.barDockControlLeft = new DevExpress.XtraBars.BarDockControl();
		this.barDockControlRight = new DevExpress.XtraBars.BarDockControl();
		this.acLayoutControl1 = new ControlManager.acLayoutControl();
		this.acTextEdit1 = new ControlManager.acTextEdit();
		this.acItem1 = new CodeHelperManager.acItem();
		this.acLabelControl1 = new ControlManager.acLabelControl();
		this.acDateEdit2 = new ControlManager.acDateEdit();
		this.acDateEdit1 = new ControlManager.acDateEdit();
		this.acCheckedComboBoxEdit1 = new ControlManager.acCheckedComboBoxEdit();
		this.layoutControlGroup1 = new ControlManager.acLayoutControlGroup();
		this.acLayoutControlItem1 = new ControlManager.acLayoutControlItem();
		this.acLayoutControlItem2 = new ControlManager.acLayoutControlItem();
		this.acLayoutControlItem3 = new ControlManager.acLayoutControlItem();
		this.emptySpaceItem1 = new DevExpress.XtraLayout.EmptySpaceItem();
		this.acLayoutControlItem5 = new ControlManager.acLayoutControlItem();
		this.emptySpaceItem3 = new DevExpress.XtraLayout.EmptySpaceItem();
		this.acLayoutControlItem4 = new ControlManager.acLayoutControlItem();
		this.acLayoutControlItem7 = new ControlManager.acLayoutControlItem();
		this.acGroupControl1 = new ControlManager.acGroupControl();
		this.acSplitContainerControl1 = new ControlManager.acSplitContainerControl();
		this.acSplitContainerControl2 = new ControlManager.acSplitContainerControl();
		this.acGridControl1 = new ControlManager.acGridControl();
		this.acGridView1 = new ControlManager.acGridView();
		this.acGridControl2 = new ControlManager.acGridControl();
		this.acGridView2 = new ControlManager.acGridView();
		this.acTabControl1 = new ControlManager.acTabControl();
		this.acTabPage1 = new ControlManager.acTabPage();
		this.acTabPage2 = new ControlManager.acTabPage();
		this.acSplitContainerControl3 = new ControlManager.acSplitContainerControl();
		this.acGroupControl2 = new ControlManager.acGroupControl();
		this.acLayoutControl2 = new ControlManager.acLayoutControl();
		this.acItem2 = new CodeHelperManager.acItem();
		this.acDateEdit4 = new ControlManager.acDateEdit();
		this.acLabelControl2 = new ControlManager.acLabelControl();
		this.acDateEdit3 = new ControlManager.acDateEdit();
		this.acCheckedComboBoxEdit2 = new ControlManager.acCheckedComboBoxEdit();
		this.acLayoutControlGroup1 = new ControlManager.acLayoutControlGroup();
		this.acLayoutControlItem8 = new ControlManager.acLayoutControlItem();
		this.emptySpaceItem2 = new DevExpress.XtraLayout.EmptySpaceItem();
		this.acLayoutControlItem9 = new ControlManager.acLayoutControlItem();
		this.acLayoutControlItem10 = new ControlManager.acLayoutControlItem();
		this.acLayoutControlItem11 = new ControlManager.acLayoutControlItem();
		this.emptySpaceItem4 = new DevExpress.XtraLayout.EmptySpaceItem();
		this.acLayoutControlItem6 = new ControlManager.acLayoutControlItem();
		this.acSplitContainerControl4 = new ControlManager.acSplitContainerControl();
		this.acGridControl3 = new ControlManager.acGridControl();
		this.acGridView3 = new ControlManager.acGridView();
		this.acGridControl4 = new ControlManager.acGridControl();
		this.acGridView4 = new ControlManager.acGridView();
		((System.ComponentModel.ISupportInitialize)base.pnlScreenBase).BeginInit();
		base.pnlScreenBase.SuspendLayout();
		((System.ComponentModel.ISupportInitialize)this.acBarManager1).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControl1).BeginInit();
		this.acLayoutControl1.SuspendLayout();
		((System.ComponentModel.ISupportInitialize)this.acTextEdit1.Properties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acItem1.Properties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit2.Properties.VistaTimeProperties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit2.Properties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit1.Properties.VistaTimeProperties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit1.Properties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acCheckedComboBoxEdit1.Properties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.layoutControlGroup1).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem1).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem2).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem3).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.emptySpaceItem1).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem5).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.emptySpaceItem3).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem4).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem7).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acGroupControl1).BeginInit();
		this.acGroupControl1.SuspendLayout();
		((System.ComponentModel.ISupportInitialize)this.acSplitContainerControl1).BeginInit();
		this.acSplitContainerControl1.SuspendLayout();
		((System.ComponentModel.ISupportInitialize)this.acSplitContainerControl2).BeginInit();
		this.acSplitContainerControl2.SuspendLayout();
		((System.ComponentModel.ISupportInitialize)this.acGridControl1).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acGridView1).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acGridControl2).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acGridView2).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acTabControl1).BeginInit();
		this.acTabControl1.SuspendLayout();
		this.acTabPage1.SuspendLayout();
		this.acTabPage2.SuspendLayout();
		((System.ComponentModel.ISupportInitialize)this.acSplitContainerControl3).BeginInit();
		this.acSplitContainerControl3.SuspendLayout();
		((System.ComponentModel.ISupportInitialize)this.acGroupControl2).BeginInit();
		this.acGroupControl2.SuspendLayout();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControl2).BeginInit();
		this.acLayoutControl2.SuspendLayout();
		((System.ComponentModel.ISupportInitialize)this.acItem2.Properties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit4.Properties.VistaTimeProperties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit4.Properties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit3.Properties.VistaTimeProperties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit3.Properties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acCheckedComboBoxEdit2.Properties).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlGroup1).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem8).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.emptySpaceItem2).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem9).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem10).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem11).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.emptySpaceItem4).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem6).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acSplitContainerControl4).BeginInit();
		this.acSplitContainerControl4.SuspendLayout();
		((System.ComponentModel.ISupportInitialize)this.acGridControl3).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acGridView3).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acGridControl4).BeginInit();
		((System.ComponentModel.ISupportInitialize)this.acGridView4).BeginInit();
		base.SuspendLayout();
		base.pnlScreenBase.Controls.Add(this.acTabControl1);
		base.pnlScreenBase.Location = new System.Drawing.Point(0, 36);
		base.pnlScreenBase.Size = new System.Drawing.Size(1268, 602);
		this.acBarManager1.AllowCustomization = false;
		this.acBarManager1.AllowQuickCustomization = false;
		this.acBarManager1.AllowShowToolbarsPopup = false;
		this.acBarManager1.Bars.AddRange(new DevExpress.XtraBars.Bar[2] { this.bar2, this.bar3 });
		this.acBarManager1.CloseButtonAffectAllTabs = false;
		this.acBarManager1.DockControls.Add(this.barDockControlTop);
		this.acBarManager1.DockControls.Add(this.barDockControlBottom);
		this.acBarManager1.DockControls.Add(this.barDockControlLeft);
		this.acBarManager1.DockControls.Add(this.barDockControlRight);
		this.acBarManager1.Form = this;
		this.acBarManager1.IsLoadDefaultLayout = true;
		this.acBarManager1.Items.AddRange(new DevExpress.XtraBars.BarItem[4] { this.statusBarLog, this.barItemSearch, this.acBarButtonItem1, this.acBarButtonItem2 });
		this.acBarManager1.MainMenu = this.bar2;
		this.acBarManager1.MaxItemId = 8;
		this.acBarManager1.StatusBar = this.bar3;
		this.bar2.BarItemHorzIndent = 10;
		this.bar2.BarItemVertIndent = 5;
		this.bar2.BarName = "도구상자";
		this.bar2.DockCol = 0;
		this.bar2.DockRow = 0;
		this.bar2.DockStyle = DevExpress.XtraBars.BarDockStyle.Top;
		this.bar2.LinksPersistInfo.AddRange(new DevExpress.XtraBars.LinkPersistInfo[3]
		{
			new DevExpress.XtraBars.LinkPersistInfo(this.barItemSearch),
			new DevExpress.XtraBars.LinkPersistInfo(this.acBarButtonItem1),
			new DevExpress.XtraBars.LinkPersistInfo(this.acBarButtonItem2)
		});
		this.bar2.OptionsBar.AllowQuickCustomization = false;
		this.bar2.OptionsBar.MultiLine = true;
		this.bar2.OptionsBar.UseWholeRow = true;
		this.bar2.ResourceID = null;
		this.bar2.Text = "도구상자";
		this.bar2.ToolTipID = null;
		this.bar2.UseResourceID = false;
		this.bar2.UseToolTipID = false;
		this.barItemSearch.ButtonShortCutType = ControlManager.acBarManager.emBarShortCutType.SEARCH;
		this.barItemSearch.Caption = "barItemSearch";
		this.barItemSearch.Glyph = ORD.Resource.glyphicons_halflings_3_search2x;
		this.barItemSearch.Id = 3;
		this.barItemSearch.Name = "barItemSearch";
		this.barItemSearch.ResourceID = null;
		this.barItemSearch.ToolTipID = "1UMVQFSB";
		this.barItemSearch.UseResourceID = false;
		this.barItemSearch.UseToolTipID = true;
		this.barItemSearch.ItemClick += new DevExpress.XtraBars.ItemClickEventHandler(barItemSearch_ItemClick);
		this.acBarButtonItem1.Caption = "엑셀 내보내기";
		this.acBarButtonItem1.Glyph = ORD.Resource.iconfinder_119_Excel;
		this.acBarButtonItem1.Id = 6;
		this.acBarButtonItem1.Name = "acBarButtonItem1";
		this.acBarButtonItem1.ResourceID = null;
		this.acBarButtonItem1.ToolTipID = null;
		this.acBarButtonItem1.UseResourceID = false;
		this.acBarButtonItem1.UseToolTipID = false;
		this.acBarButtonItem1.ItemClick += new DevExpress.XtraBars.ItemClickEventHandler(acBarButtonItem1_ItemClick);
		this.acBarButtonItem2.Caption = "저장";
		this.acBarButtonItem2.Glyph = ORD.Resource.glyphicons_halflings_172_floppy_disk2x;
		this.acBarButtonItem2.Id = 7;
		this.acBarButtonItem2.Name = "acBarButtonItem2";
		this.acBarButtonItem2.ResourceID = null;
		this.acBarButtonItem2.ToolTipID = null;
		this.acBarButtonItem2.UseResourceID = false;
		this.acBarButtonItem2.UseToolTipID = false;
		this.acBarButtonItem2.ItemClick += new DevExpress.XtraBars.ItemClickEventHandler(acBarButtonItem2_ItemClick);
		this.bar3.BarItemHorzIndent = 10;
		this.bar3.BarItemVertIndent = 5;
		this.bar3.BarName = "Status bar";
		this.bar3.CanDockStyle = DevExpress.XtraBars.BarCanDockStyle.Bottom;
		this.bar3.DockCol = 0;
		this.bar3.DockRow = 0;
		this.bar3.DockStyle = DevExpress.XtraBars.BarDockStyle.Bottom;
		this.bar3.LinksPersistInfo.AddRange(new DevExpress.XtraBars.LinkPersistInfo[1]
		{
			new DevExpress.XtraBars.LinkPersistInfo(DevExpress.XtraBars.BarLinkUserDefines.PaintStyle, this.statusBarLog, DevExpress.XtraBars.BarItemPaintStyle.CaptionGlyph)
		});
		this.bar3.OptionsBar.AllowQuickCustomization = false;
		this.bar3.OptionsBar.DrawDragBorder = false;
		this.bar3.OptionsBar.UseWholeRow = true;
		this.bar3.ResourceID = null;
		this.bar3.Text = "Status bar";
		this.bar3.ToolTipID = null;
		this.bar3.UseResourceID = false;
		this.bar3.UseToolTipID = false;
		this.statusBarLog.Border = DevExpress.XtraEditors.Controls.BorderStyles.NoBorder;
		this.statusBarLog.Glyph = ORD.Resource.glyphicons_halflings_111_comments2x;
		this.statusBarLog.Id = 0;
		this.statusBarLog.Name = "statusBarLog";
		this.statusBarLog.PaintStyle = DevExpress.XtraBars.BarItemPaintStyle.CaptionGlyph;
		this.statusBarLog.ResourceID = null;
		this.statusBarLog.TextAlignment = System.Drawing.StringAlignment.Near;
		this.statusBarLog.ToolTipID = null;
		this.statusBarLog.UseResourceID = false;
		this.statusBarLog.UseToolTipID = false;
		this.barDockControlTop.CausesValidation = false;
		this.barDockControlTop.Dock = System.Windows.Forms.DockStyle.Top;
		this.barDockControlTop.Location = new System.Drawing.Point(0, 0);
		this.barDockControlTop.Size = new System.Drawing.Size(1268, 36);
		this.barDockControlBottom.CausesValidation = false;
		this.barDockControlBottom.Dock = System.Windows.Forms.DockStyle.Bottom;
		this.barDockControlBottom.Location = new System.Drawing.Point(0, 638);
		this.barDockControlBottom.Size = new System.Drawing.Size(1268, 33);
		this.barDockControlLeft.CausesValidation = false;
		this.barDockControlLeft.Dock = System.Windows.Forms.DockStyle.Left;
		this.barDockControlLeft.Location = new System.Drawing.Point(0, 36);
		this.barDockControlLeft.Size = new System.Drawing.Size(0, 602);
		this.barDockControlRight.CausesValidation = false;
		this.barDockControlRight.Dock = System.Windows.Forms.DockStyle.Right;
		this.barDockControlRight.Location = new System.Drawing.Point(1268, 36);
		this.barDockControlRight.Size = new System.Drawing.Size(0, 602);
		this.acLayoutControl1.AllowCustomizationMenu = false;
		this.acLayoutControl1.AutoScroll = false;
		this.acLayoutControl1.ContainerName = null;
		this.acLayoutControl1.Controls.Add(this.acTextEdit1);
		this.acLayoutControl1.Controls.Add(this.acItem1);
		this.acLayoutControl1.Controls.Add(this.acLabelControl1);
		this.acLayoutControl1.Controls.Add(this.acDateEdit2);
		this.acLayoutControl1.Controls.Add(this.acDateEdit1);
		this.acLayoutControl1.Controls.Add(this.acCheckedComboBoxEdit1);
		this.acLayoutControl1.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acLayoutControl1.LayoutType = ControlManager.acLayoutControl.emLayoutType.CONDITION;
		this.acLayoutControl1.Location = new System.Drawing.Point(2, 22);
		this.acLayoutControl1.Name = "acLayoutControl1";
		this.acLayoutControl1.OptionsCustomizationForm.DesignTimeCustomizationFormPositionAndSize = new System.Drawing.Rectangle(2156, 201, 250, 350);
		this.acLayoutControl1.ParentControl = null;
		this.acLayoutControl1.Root = this.layoutControlGroup1;
		this.acLayoutControl1.Size = new System.Drawing.Size(790, 43);
		this.acLayoutControl1.TabIndex = 0;
		this.acLayoutControl1.Text = "acLayoutControl1";
		this.acTextEdit1.ColumnName = "BALJU_NUM";
		this.acTextEdit1.Location = new System.Drawing.Point(488, 5);
		this.acTextEdit1.MaskType = ControlManager.acTextEdit.emMaskType.NONE;
		this.acTextEdit1.MenuManager = this.acBarManager1;
		this.acTextEdit1.Name = "acTextEdit1";
		this.acTextEdit1.Properties.Appearance.BackColor = System.Drawing.Color.White;
		this.acTextEdit1.Properties.Appearance.ForeColor = System.Drawing.Color.Black;
		this.acTextEdit1.Properties.Appearance.Options.UseBackColor = true;
		this.acTextEdit1.Properties.Appearance.Options.UseForeColor = true;
		this.acTextEdit1.Size = new System.Drawing.Size(72, 20);
		this.acTextEdit1.StyleController = this.acLayoutControl1;
		this.acTextEdit1.TabIndex = 11;
		this.acItem1.ColumnName = "ITEM_CODE";
		this.acItem1.isReadyOnly = false;
		this.acItem1.isRequired = false;
		this.acItem1.Location = new System.Drawing.Point(346, 5);
		this.acItem1.MenuManager = this.acBarManager1;
		this.acItem1.Name = "acItem1";
		this.acItem1.Properties.Appearance.BackColor = System.Drawing.Color.White;
		this.acItem1.Properties.Appearance.ForeColor = System.Drawing.Color.Black;
		this.acItem1.Properties.Appearance.Options.UseBackColor = true;
		this.acItem1.Properties.Appearance.Options.UseForeColor = true;
		this.acItem1.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[2]
		{
			new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Down, "", -1, true, true, false, DevExpress.XtraEditors.ImageLocation.MiddleCenter, null, new DevExpress.Utils.KeyShortcut(System.Windows.Forms.Keys.None), appearance, "", "DETAIL", null, true),
			new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Glyph, "", -1, true, true, false, DevExpress.XtraEditors.ImageLocation.MiddleCenter, (System.Drawing.Image)resources.GetObject("acItem1.Properties.Buttons"), new DevExpress.Utils.KeyShortcut(System.Windows.Forms.Keys.None), appearance2, "", "FIND", null, false)
		});
		this.acItem1.Size = new System.Drawing.Size(89, 22);
		this.acItem1.StyleController = this.acLayoutControl1;
		this.acItem1.TabIndex = 9;
		this.acItem1.ToolTipID = null;
		this.acItem1.UseToolTipID = false;
		this.acLabelControl1.Location = new System.Drawing.Point(219, 5);
		this.acLabelControl1.Name = "acLabelControl1";
		this.acLabelControl1.ResourceID = null;
		this.acLabelControl1.Size = new System.Drawing.Size(9, 14);
		this.acLabelControl1.StyleController = this.acLayoutControl1;
		this.acLabelControl1.TabIndex = 8;
		this.acLabelControl1.Text = "~";
		this.acLabelControl1.ToolTipID = null;
		this.acLabelControl1.UseResourceID = false;
		this.acLabelControl1.UseToolTipID = false;
		this.acDateEdit2.ColumnName = "E_DATE";
		this.acDateEdit2.CreateParameterFormat = "yyyyMMdd";
		this.acDateEdit2.EditValue = null;
		this.acDateEdit2.isReadyOnly = false;
		this.acDateEdit2.isRequired = false;
		this.acDateEdit2.Location = new System.Drawing.Point(238, 5);
		this.acDateEdit2.Name = "acDateEdit2";
		this.acDateEdit2.Properties.Appearance.BackColor = System.Drawing.Color.White;
		this.acDateEdit2.Properties.Appearance.ForeColor = System.Drawing.Color.Black;
		this.acDateEdit2.Properties.Appearance.Options.UseBackColor = true;
		this.acDateEdit2.Properties.Appearance.Options.UseForeColor = true;
		this.acDateEdit2.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[1]
		{
			new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)
		});
		this.acDateEdit2.Properties.VistaTimeProperties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[1]
		{
			new DevExpress.XtraEditors.Controls.EditorButton()
		});
		this.acDateEdit2.Size = new System.Drawing.Size(73, 20);
		this.acDateEdit2.StyleController = this.acLayoutControl1;
		this.acDateEdit2.TabIndex = 6;
		this.acDateEdit2.TimeOfDayType = ControlManager.acDateEdit.emTimeOfDayType.START;
		this.acDateEdit2.ToolTipID = null;
		this.acDateEdit2.UseToolTipID = false;
		this.acDateEdit1.ColumnName = "S_DATE";
		this.acDateEdit1.CreateParameterFormat = "yyyyMMdd";
		this.acDateEdit1.EditValue = null;
		this.acDateEdit1.isReadyOnly = false;
		this.acDateEdit1.isRequired = false;
		this.acDateEdit1.Location = new System.Drawing.Point(116, 5);
		this.acDateEdit1.Name = "acDateEdit1";
		this.acDateEdit1.Properties.Appearance.BackColor = System.Drawing.Color.White;
		this.acDateEdit1.Properties.Appearance.ForeColor = System.Drawing.Color.Black;
		this.acDateEdit1.Properties.Appearance.Options.UseBackColor = true;
		this.acDateEdit1.Properties.Appearance.Options.UseForeColor = true;
		this.acDateEdit1.Properties.AppearanceReadOnly.BackColor = System.Drawing.Color.WhiteSmoke;
		this.acDateEdit1.Properties.AppearanceReadOnly.ForeColor = System.Drawing.Color.Black;
		this.acDateEdit1.Properties.AppearanceReadOnly.Options.UseBackColor = true;
		this.acDateEdit1.Properties.AppearanceReadOnly.Options.UseForeColor = true;
		this.acDateEdit1.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[1]
		{
			new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)
		});
		this.acDateEdit1.Properties.VistaTimeProperties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[1]
		{
			new DevExpress.XtraEditors.Controls.EditorButton()
		});
		this.acDateEdit1.Size = new System.Drawing.Size(93, 20);
		this.acDateEdit1.StyleController = this.acLayoutControl1;
		this.acDateEdit1.TabIndex = 5;
		this.acDateEdit1.TimeOfDayType = ControlManager.acDateEdit.emTimeOfDayType.START;
		this.acDateEdit1.ToolTipID = null;
		this.acDateEdit1.UseToolTipID = false;
		this.acCheckedComboBoxEdit1.ColumnName = "DATE";
		this.acCheckedComboBoxEdit1.isReadyOnly = false;
		this.acCheckedComboBoxEdit1.isRequired = false;
		this.acCheckedComboBoxEdit1.Location = new System.Drawing.Point(5, 5);
		this.acCheckedComboBoxEdit1.Name = "acCheckedComboBoxEdit1";
		this.acCheckedComboBoxEdit1.Properties.Appearance.BackColor = System.Drawing.Color.White;
		this.acCheckedComboBoxEdit1.Properties.Appearance.ForeColor = System.Drawing.Color.Black;
		this.acCheckedComboBoxEdit1.Properties.Appearance.Options.UseBackColor = true;
		this.acCheckedComboBoxEdit1.Properties.Appearance.Options.UseForeColor = true;
		this.acCheckedComboBoxEdit1.Properties.AppearanceReadOnly.BackColor = System.Drawing.Color.WhiteSmoke;
		this.acCheckedComboBoxEdit1.Properties.AppearanceReadOnly.ForeColor = System.Drawing.Color.Black;
		this.acCheckedComboBoxEdit1.Properties.AppearanceReadOnly.Options.UseBackColor = true;
		this.acCheckedComboBoxEdit1.Properties.AppearanceReadOnly.Options.UseForeColor = true;
		this.acCheckedComboBoxEdit1.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[1]
		{
			new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)
		});
		this.acCheckedComboBoxEdit1.Size = new System.Drawing.Size(101, 20);
		this.acCheckedComboBoxEdit1.StyleController = this.acLayoutControl1;
		this.acCheckedComboBoxEdit1.TabIndex = 4;
		this.acCheckedComboBoxEdit1.ToolTipID = null;
		this.acCheckedComboBoxEdit1.UseToolTipID = false;
		this.layoutControlGroup1.CustomizationFormText = "Root";
		this.layoutControlGroup1.GroupBordersVisible = false;
		this.layoutControlGroup1.Items.AddRange(new DevExpress.XtraLayout.BaseLayoutItem[8] { this.acLayoutControlItem1, this.acLayoutControlItem2, this.acLayoutControlItem3, this.emptySpaceItem1, this.acLayoutControlItem5, this.emptySpaceItem3, this.acLayoutControlItem4, this.acLayoutControlItem7 });
		this.layoutControlGroup1.Location = new System.Drawing.Point(0, 0);
		this.layoutControlGroup1.Name = "Root";
		this.layoutControlGroup1.ResourceID = null;
		this.layoutControlGroup1.Size = new System.Drawing.Size(790, 43);
		this.layoutControlGroup1.Text = "Root";
		this.layoutControlGroup1.TextVisible = false;
		this.layoutControlGroup1.ToolTipID = null;
		this.layoutControlGroup1.UseResourceID = false;
		this.layoutControlGroup1.UseToolTipID = false;
		this.acLayoutControlItem1.Control = this.acCheckedComboBoxEdit1;
		this.acLayoutControlItem1.CustomizationFormText = "acLayoutControlItem1";
		this.acLayoutControlItem1.IsHeader = false;
		this.acLayoutControlItem1.Location = new System.Drawing.Point(0, 0);
		this.acLayoutControlItem1.Name = "acLayoutControlItem1";
		this.acLayoutControlItem1.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
		this.acLayoutControlItem1.ResourceID = "";
		this.acLayoutControlItem1.Size = new System.Drawing.Size(111, 32);
		this.acLayoutControlItem1.Text = "acLayoutControlItem1";
		this.acLayoutControlItem1.TextAlignMode = DevExpress.XtraLayout.TextAlignModeItem.AutoSize;
		this.acLayoutControlItem1.TextSize = new System.Drawing.Size(0, 0);
		this.acLayoutControlItem1.TextToControlDistance = 0;
		this.acLayoutControlItem1.TextVisible = false;
		this.acLayoutControlItem1.ToolTipID = null;
		this.acLayoutControlItem1.UseResourceID = false;
		this.acLayoutControlItem1.UseToolTipID = false;
		this.acLayoutControlItem2.Control = this.acDateEdit1;
		this.acLayoutControlItem2.CustomizationFormText = "acLayoutControlItem2";
		this.acLayoutControlItem2.IsHeader = false;
		this.acLayoutControlItem2.Location = new System.Drawing.Point(111, 0);
		this.acLayoutControlItem2.Name = "acLayoutControlItem2";
		this.acLayoutControlItem2.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
		this.acLayoutControlItem2.ResourceID = null;
		this.acLayoutControlItem2.Size = new System.Drawing.Size(103, 32);
		this.acLayoutControlItem2.Text = "acLayoutControlItem2";
		this.acLayoutControlItem2.TextAlignMode = DevExpress.XtraLayout.TextAlignModeItem.AutoSize;
		this.acLayoutControlItem2.TextSize = new System.Drawing.Size(0, 0);
		this.acLayoutControlItem2.TextToControlDistance = 0;
		this.acLayoutControlItem2.TextVisible = false;
		this.acLayoutControlItem2.ToolTipID = null;
		this.acLayoutControlItem2.UseResourceID = false;
		this.acLayoutControlItem2.UseToolTipID = false;
		this.acLayoutControlItem3.Control = this.acDateEdit2;
		this.acLayoutControlItem3.CustomizationFormText = "acLayoutControlItem3";
		this.acLayoutControlItem3.IsHeader = false;
		this.acLayoutControlItem3.Location = new System.Drawing.Point(233, 0);
		this.acLayoutControlItem3.Name = "acLayoutControlItem3";
		this.acLayoutControlItem3.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
		this.acLayoutControlItem3.ResourceID = null;
		this.acLayoutControlItem3.Size = new System.Drawing.Size(83, 32);
		this.acLayoutControlItem3.Text = "acLayoutControlItem3";
		this.acLayoutControlItem3.TextAlignMode = DevExpress.XtraLayout.TextAlignModeItem.AutoSize;
		this.acLayoutControlItem3.TextSize = new System.Drawing.Size(0, 0);
		this.acLayoutControlItem3.TextToControlDistance = 0;
		this.acLayoutControlItem3.TextVisible = false;
		this.acLayoutControlItem3.ToolTipID = null;
		this.acLayoutControlItem3.UseResourceID = false;
		this.acLayoutControlItem3.UseToolTipID = false;
		this.emptySpaceItem1.AllowHotTrack = false;
		this.emptySpaceItem1.CustomizationFormText = "emptySpaceItem1";
		this.emptySpaceItem1.Location = new System.Drawing.Point(565, 0);
		this.emptySpaceItem1.Name = "emptySpaceItem1";
		this.emptySpaceItem1.Size = new System.Drawing.Size(225, 32);
		this.emptySpaceItem1.Text = "emptySpaceItem1";
		this.emptySpaceItem1.TextSize = new System.Drawing.Size(0, 0);
		this.acLayoutControlItem5.Control = this.acLabelControl1;
		this.acLayoutControlItem5.CustomizationFormText = "acLayoutControlItem5";
		this.acLayoutControlItem5.IsHeader = false;
		this.acLayoutControlItem5.Location = new System.Drawing.Point(214, 0);
		this.acLayoutControlItem5.Name = "acLayoutControlItem5";
		this.acLayoutControlItem5.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
		this.acLayoutControlItem5.ResourceID = null;
		this.acLayoutControlItem5.Size = new System.Drawing.Size(19, 32);
		this.acLayoutControlItem5.Text = "acLayoutControlItem5";
		this.acLayoutControlItem5.TextAlignMode = DevExpress.XtraLayout.TextAlignModeItem.AutoSize;
		this.acLayoutControlItem5.TextSize = new System.Drawing.Size(0, 0);
		this.acLayoutControlItem5.TextToControlDistance = 0;
		this.acLayoutControlItem5.TextVisible = false;
		this.acLayoutControlItem5.ToolTipID = null;
		this.acLayoutControlItem5.UseResourceID = false;
		this.acLayoutControlItem5.UseToolTipID = false;
		this.emptySpaceItem3.AllowHotTrack = false;
		this.emptySpaceItem3.CustomizationFormText = "emptySpaceItem3";
		this.emptySpaceItem3.Location = new System.Drawing.Point(0, 32);
		this.emptySpaceItem3.Name = "emptySpaceItem3";
		this.emptySpaceItem3.Size = new System.Drawing.Size(790, 11);
		this.emptySpaceItem3.Text = "emptySpaceItem3";
		this.emptySpaceItem3.TextSize = new System.Drawing.Size(0, 0);
		this.acLayoutControlItem4.Control = this.acItem1;
		this.acLayoutControlItem4.CustomizationFormText = "수주";
		this.acLayoutControlItem4.IsHeader = false;
		this.acLayoutControlItem4.Location = new System.Drawing.Point(316, 0);
		this.acLayoutControlItem4.Name = "acLayoutControlItem4";
		this.acLayoutControlItem4.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
		this.acLayoutControlItem4.ResourceID = null;
		this.acLayoutControlItem4.Size = new System.Drawing.Size(124, 32);
		this.acLayoutControlItem4.Text = "수주";
		this.acLayoutControlItem4.TextAlignMode = DevExpress.XtraLayout.TextAlignModeItem.AutoSize;
		this.acLayoutControlItem4.TextSize = new System.Drawing.Size(20, 14);
		this.acLayoutControlItem4.TextToControlDistance = 5;
		this.acLayoutControlItem4.ToolTipID = null;
		this.acLayoutControlItem4.UseResourceID = false;
		this.acLayoutControlItem4.UseToolTipID = false;
		this.acLayoutControlItem7.Control = this.acTextEdit1;
		this.acLayoutControlItem7.CustomizationFormText = "발주번호";
		this.acLayoutControlItem7.IsHeader = false;
		this.acLayoutControlItem7.Location = new System.Drawing.Point(440, 0);
		this.acLayoutControlItem7.Name = "acLayoutControlItem7";
		this.acLayoutControlItem7.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
		this.acLayoutControlItem7.ResourceID = null;
		this.acLayoutControlItem7.Size = new System.Drawing.Size(125, 32);
		this.acLayoutControlItem7.Text = "발주번호";
		this.acLayoutControlItem7.TextSize = new System.Drawing.Size(40, 14);
		this.acLayoutControlItem7.ToolTipID = null;
		this.acLayoutControlItem7.UseResourceID = false;
		this.acLayoutControlItem7.UseToolTipID = false;
		this.acGroupControl1.Controls.Add(this.acLayoutControl1);
		this.acGroupControl1.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acGroupControl1.IsNavPlan = true;
		this.acGroupControl1.Location = new System.Drawing.Point(0, 0);
		this.acGroupControl1.Name = "acGroupControl1";
		this.acGroupControl1.ResourceID = "0ESJ7Q53";
		this.acGroupControl1.Size = new System.Drawing.Size(794, 67);
		this.acGroupControl1.TabIndex = 6;
		this.acGroupControl1.Text = "검색조건";
		this.acGroupControl1.ToolTipID = null;
		this.acGroupControl1.UseResourceID = true;
		this.acGroupControl1.UseToolTipID = false;
		this.acSplitContainerControl1.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acSplitContainerControl1.FixedPanel = DevExpress.XtraEditors.SplitFixedPanel.None;
		this.acSplitContainerControl1.Horizontal = false;
		this.acSplitContainerControl1.Location = new System.Drawing.Point(0, 0);
		this.acSplitContainerControl1.Name = "acSplitContainerControl1";
		this.acSplitContainerControl1.Panel1.Controls.Add(this.acGroupControl1);
		this.acSplitContainerControl1.Panel1.Text = "Panel1";
		this.acSplitContainerControl1.Panel2.Controls.Add(this.acSplitContainerControl2);
		this.acSplitContainerControl1.Panel2.Text = "Panel2";
		this.acSplitContainerControl1.ParentControl = null;
		this.acSplitContainerControl1.Size = new System.Drawing.Size(794, 502);
		this.acSplitContainerControl1.SplitterPosition = 67;
		this.acSplitContainerControl1.TabIndex = 7;
		this.acSplitContainerControl1.Text = "acSplitContainerControl1";
		this.acSplitContainerControl2.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acSplitContainerControl2.FixedPanel = DevExpress.XtraEditors.SplitFixedPanel.None;
		this.acSplitContainerControl2.Location = new System.Drawing.Point(0, 0);
		this.acSplitContainerControl2.Name = "acSplitContainerControl2";
		this.acSplitContainerControl2.Panel1.Controls.Add(this.acGridControl1);
		this.acSplitContainerControl2.Panel1.Text = "Panel1";
		this.acSplitContainerControl2.Panel2.Controls.Add(this.acGridControl2);
		this.acSplitContainerControl2.Panel2.Text = "Panel2";
		this.acSplitContainerControl2.ParentControl = null;
		this.acSplitContainerControl2.Size = new System.Drawing.Size(794, 430);
		this.acSplitContainerControl2.SplitterPosition = 119;
		this.acSplitContainerControl2.TabIndex = 1;
		this.acSplitContainerControl2.Text = "acSplitContainerControl2";
		this.acGridControl1.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acGridControl1.Location = new System.Drawing.Point(0, 0);
		this.acGridControl1.MainView = this.acGridView1;
		this.acGridControl1.MenuManager = this.acBarManager1;
		this.acGridControl1.Name = "acGridControl1";
		this.acGridControl1.Size = new System.Drawing.Size(119, 430);
		this.acGridControl1.TabIndex = 0;
		this.acGridControl1.ViewCollection.AddRange(new DevExpress.XtraGrid.Views.Base.BaseView[1] { this.acGridView1 });
		this.acGridView1.ColumnPanelRowHeight = 30;
		this.acGridView1.GridControl = this.acGridControl1;
		this.acGridView1.Name = "acGridView1";
		this.acGridView1.OptionsBehavior.AutoPopulateColumns = false;
		this.acGridView1.OptionsLayout.Columns.StoreAllOptions = true;
		this.acGridView1.OptionsLayout.StoreAllOptions = true;
		this.acGridView1.OptionsView.RowAutoHeight = true;
		this.acGridView1.OptionsView.ShowGroupPanel = false;
		this.acGridView1.OptionsView.ShowIndicator = false;
		this.acGridView1.ParentControl = this;
		this.acGridView1.RowHeight = 30;
		this.acGridView1.SaveFileName = null;
		this.acGridControl2.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acGridControl2.Location = new System.Drawing.Point(0, 0);
		this.acGridControl2.MainView = this.acGridView2;
		this.acGridControl2.MenuManager = this.acBarManager1;
		this.acGridControl2.Name = "acGridControl2";
		this.acGridControl2.Size = new System.Drawing.Size(670, 430);
		this.acGridControl2.TabIndex = 0;
		this.acGridControl2.ViewCollection.AddRange(new DevExpress.XtraGrid.Views.Base.BaseView[1] { this.acGridView2 });
		this.acGridView2.ColumnPanelRowHeight = 30;
		this.acGridView2.GridControl = this.acGridControl2;
		this.acGridView2.Name = "acGridView2";
		this.acGridView2.OptionsBehavior.AutoPopulateColumns = false;
		this.acGridView2.OptionsLayout.Columns.StoreAllOptions = true;
		this.acGridView2.OptionsLayout.StoreAllOptions = true;
		this.acGridView2.OptionsView.RowAutoHeight = true;
		this.acGridView2.OptionsView.ShowGroupPanel = false;
		this.acGridView2.OptionsView.ShowIndicator = false;
		this.acGridView2.ParentControl = this;
		this.acGridView2.RowHeight = 30;
		this.acGridView2.SaveFileName = null;
		this.acTabControl1.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acTabControl1.Location = new System.Drawing.Point(0, 0);
		this.acTabControl1.Name = "acTabControl1";
		this.acTabControl1.SelectedTabPage = this.acTabPage1;
		this.acTabControl1.Size = new System.Drawing.Size(1268, 602);
		this.acTabControl1.TabIndex = 8;
		this.acTabControl1.TabPages.AddRange(new DevExpress.XtraTab.XtraTabPage[2] { this.acTabPage1, this.acTabPage2 });
		this.acTabPage1.ContainerName = "IN";
		this.acTabPage1.Controls.Add(this.acSplitContainerControl1);
		this.acTabPage1.Name = "acTabPage1";
		this.acTabPage1.ResourceID = null;
		this.acTabPage1.Size = new System.Drawing.Size(794, 502);
		this.acTabPage1.Text = "매입";
		this.acTabPage1.ToolTipID = null;
		this.acTabPage1.UseResourceID = false;
		this.acTabPage1.UseToolTipID = false;
		this.acTabPage2.ContainerName = "OUT";
		this.acTabPage2.Controls.Add(this.acSplitContainerControl3);
		this.acTabPage2.Name = "acTabPage2";
		this.acTabPage2.ResourceID = null;
		this.acTabPage2.Size = new System.Drawing.Size(1262, 573);
		this.acTabPage2.Text = "매출";
		this.acTabPage2.ToolTipID = null;
		this.acTabPage2.UseResourceID = false;
		this.acTabPage2.UseToolTipID = false;
		this.acSplitContainerControl3.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acSplitContainerControl3.FixedPanel = DevExpress.XtraEditors.SplitFixedPanel.None;
		this.acSplitContainerControl3.Horizontal = false;
		this.acSplitContainerControl3.Location = new System.Drawing.Point(0, 0);
		this.acSplitContainerControl3.Name = "acSplitContainerControl3";
		this.acSplitContainerControl3.Panel1.Controls.Add(this.acGroupControl2);
		this.acSplitContainerControl3.Panel1.Text = "Panel1";
		this.acSplitContainerControl3.Panel2.Controls.Add(this.acSplitContainerControl4);
		this.acSplitContainerControl3.Panel2.Text = "Panel2";
		this.acSplitContainerControl3.ParentControl = null;
		this.acSplitContainerControl3.Size = new System.Drawing.Size(1262, 573);
		this.acSplitContainerControl3.SplitterPosition = 92;
		this.acSplitContainerControl3.TabIndex = 0;
		this.acSplitContainerControl3.Text = "acSplitContainerControl3";
		this.acGroupControl2.Controls.Add(this.acLayoutControl2);
		this.acGroupControl2.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acGroupControl2.IsNavPlan = false;
		this.acGroupControl2.Location = new System.Drawing.Point(0, 0);
		this.acGroupControl2.Name = "acGroupControl2";
		this.acGroupControl2.ResourceID = "0ESJ7Q53";
		this.acGroupControl2.Size = new System.Drawing.Size(1262, 92);
		this.acGroupControl2.TabIndex = 0;
		this.acGroupControl2.Text = "검색조건";
		this.acGroupControl2.ToolTipID = null;
		this.acGroupControl2.UseResourceID = true;
		this.acGroupControl2.UseToolTipID = false;
		this.acLayoutControl2.AllowCustomizationMenu = false;
		this.acLayoutControl2.ContainerName = null;
		this.acLayoutControl2.Controls.Add(this.acItem2);
		this.acLayoutControl2.Controls.Add(this.acDateEdit4);
		this.acLayoutControl2.Controls.Add(this.acLabelControl2);
		this.acLayoutControl2.Controls.Add(this.acDateEdit3);
		this.acLayoutControl2.Controls.Add(this.acCheckedComboBoxEdit2);
		this.acLayoutControl2.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acLayoutControl2.LayoutType = ControlManager.acLayoutControl.emLayoutType.NONE;
		this.acLayoutControl2.Location = new System.Drawing.Point(2, 22);
		this.acLayoutControl2.Name = "acLayoutControl2";
		this.acLayoutControl2.OptionsCustomizationForm.DesignTimeCustomizationFormPositionAndSize = new System.Drawing.Rectangle(2174, 225, 250, 350);
		this.acLayoutControl2.ParentControl = null;
		this.acLayoutControl2.Root = this.acLayoutControlGroup1;
		this.acLayoutControl2.Size = new System.Drawing.Size(1258, 68);
		this.acLayoutControl2.TabIndex = 0;
		this.acLayoutControl2.Text = "acLayoutControl2";
		this.acItem2.ColumnName = "ITEM_CODE";
		this.acItem2.isReadyOnly = false;
		this.acItem2.isRequired = false;
		this.acItem2.Location = new System.Drawing.Point(393, 5);
		this.acItem2.MenuManager = this.acBarManager1;
		this.acItem2.Name = "acItem2";
		this.acItem2.Properties.Appearance.BackColor = System.Drawing.Color.White;
		this.acItem2.Properties.Appearance.ForeColor = System.Drawing.Color.Black;
		this.acItem2.Properties.Appearance.Options.UseBackColor = true;
		this.acItem2.Properties.Appearance.Options.UseForeColor = true;
		this.acItem2.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[2]
		{
			new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Down, "", -1, true, true, false, DevExpress.XtraEditors.ImageLocation.MiddleCenter, null, new DevExpress.Utils.KeyShortcut(System.Windows.Forms.Keys.None), appearance3, "", "DETAIL", null, true),
			new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Glyph, "", -1, true, true, false, DevExpress.XtraEditors.ImageLocation.MiddleCenter, (System.Drawing.Image)resources.GetObject("acItem2.Properties.Buttons"), new DevExpress.Utils.KeyShortcut(System.Windows.Forms.Keys.None), appearance4, "", "FIND", null, false)
		});
		this.acItem2.Size = new System.Drawing.Size(152, 22);
		this.acItem2.StyleController = this.acLayoutControl2;
		this.acItem2.TabIndex = 8;
		this.acItem2.ToolTipID = null;
		this.acItem2.UseToolTipID = false;
		this.acDateEdit4.ColumnName = "E_DATE";
		this.acDateEdit4.CreateParameterFormat = "yyyyMMdd";
		this.acDateEdit4.EditValue = null;
		this.acDateEdit4.isReadyOnly = false;
		this.acDateEdit4.isRequired = false;
		this.acDateEdit4.Location = new System.Drawing.Point(256, 5);
		this.acDateEdit4.MenuManager = this.acBarManager1;
		this.acDateEdit4.Name = "acDateEdit4";
		this.acDateEdit4.Properties.Appearance.BackColor = System.Drawing.Color.White;
		this.acDateEdit4.Properties.Appearance.ForeColor = System.Drawing.Color.Black;
		this.acDateEdit4.Properties.Appearance.Options.UseBackColor = true;
		this.acDateEdit4.Properties.Appearance.Options.UseForeColor = true;
		this.acDateEdit4.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[1]
		{
			new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)
		});
		this.acDateEdit4.Properties.VistaTimeProperties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[1]
		{
			new DevExpress.XtraEditors.Controls.EditorButton()
		});
		this.acDateEdit4.Size = new System.Drawing.Size(104, 20);
		this.acDateEdit4.StyleController = this.acLayoutControl2;
		this.acDateEdit4.TabIndex = 7;
		this.acDateEdit4.ToolTipID = null;
		this.acDateEdit4.UseToolTipID = false;
		this.acLabelControl2.Location = new System.Drawing.Point(237, 5);
		this.acLabelControl2.Name = "acLabelControl2";
		this.acLabelControl2.ResourceID = null;
		this.acLabelControl2.Size = new System.Drawing.Size(9, 14);
		this.acLabelControl2.StyleController = this.acLayoutControl2;
		this.acLabelControl2.TabIndex = 6;
		this.acLabelControl2.Text = "~";
		this.acLabelControl2.ToolTipID = null;
		this.acLabelControl2.UseResourceID = false;
		this.acLabelControl2.UseToolTipID = false;
		this.acDateEdit3.ColumnName = "S_DATE";
		this.acDateEdit3.CreateParameterFormat = "yyyyMMdd";
		this.acDateEdit3.EditValue = null;
		this.acDateEdit3.isReadyOnly = false;
		this.acDateEdit3.isRequired = false;
		this.acDateEdit3.Location = new System.Drawing.Point(118, 5);
		this.acDateEdit3.MenuManager = this.acBarManager1;
		this.acDateEdit3.Name = "acDateEdit3";
		this.acDateEdit3.Properties.Appearance.BackColor = System.Drawing.Color.White;
		this.acDateEdit3.Properties.Appearance.ForeColor = System.Drawing.Color.Black;
		this.acDateEdit3.Properties.Appearance.Options.UseBackColor = true;
		this.acDateEdit3.Properties.Appearance.Options.UseForeColor = true;
		this.acDateEdit3.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[1]
		{
			new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)
		});
		this.acDateEdit3.Properties.VistaTimeProperties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[1]
		{
			new DevExpress.XtraEditors.Controls.EditorButton()
		});
		this.acDateEdit3.Size = new System.Drawing.Size(109, 20);
		this.acDateEdit3.StyleController = this.acLayoutControl2;
		this.acDateEdit3.TabIndex = 5;
		this.acDateEdit3.ToolTipID = null;
		this.acDateEdit3.UseToolTipID = false;
		this.acCheckedComboBoxEdit2.ColumnName = "DATE";
		this.acCheckedComboBoxEdit2.isReadyOnly = false;
		this.acCheckedComboBoxEdit2.isRequired = false;
		this.acCheckedComboBoxEdit2.Location = new System.Drawing.Point(5, 5);
		this.acCheckedComboBoxEdit2.MenuManager = this.acBarManager1;
		this.acCheckedComboBoxEdit2.Name = "acCheckedComboBoxEdit2";
		this.acCheckedComboBoxEdit2.Properties.Appearance.BackColor = System.Drawing.Color.White;
		this.acCheckedComboBoxEdit2.Properties.Appearance.ForeColor = System.Drawing.Color.Black;
		this.acCheckedComboBoxEdit2.Properties.Appearance.Options.UseBackColor = true;
		this.acCheckedComboBoxEdit2.Properties.Appearance.Options.UseForeColor = true;
		this.acCheckedComboBoxEdit2.Properties.AppearanceReadOnly.BackColor = System.Drawing.Color.WhiteSmoke;
		this.acCheckedComboBoxEdit2.Properties.AppearanceReadOnly.ForeColor = System.Drawing.Color.Black;
		this.acCheckedComboBoxEdit2.Properties.AppearanceReadOnly.Options.UseBackColor = true;
		this.acCheckedComboBoxEdit2.Properties.AppearanceReadOnly.Options.UseForeColor = true;
		this.acCheckedComboBoxEdit2.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[1]
		{
			new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)
		});
		this.acCheckedComboBoxEdit2.Size = new System.Drawing.Size(103, 20);
		this.acCheckedComboBoxEdit2.StyleController = this.acLayoutControl2;
		this.acCheckedComboBoxEdit2.TabIndex = 4;
		this.acCheckedComboBoxEdit2.ToolTipID = null;
		this.acCheckedComboBoxEdit2.UseToolTipID = false;
		this.acLayoutControlGroup1.CustomizationFormText = "Root";
		this.acLayoutControlGroup1.EnableIndentsWithoutBorders = DevExpress.Utils.DefaultBoolean.False;
		this.acLayoutControlGroup1.GroupBordersVisible = false;
		this.acLayoutControlGroup1.Items.AddRange(new DevExpress.XtraLayout.BaseLayoutItem[7] { this.acLayoutControlItem8, this.emptySpaceItem2, this.acLayoutControlItem9, this.acLayoutControlItem10, this.acLayoutControlItem11, this.emptySpaceItem4, this.acLayoutControlItem6 });
		this.acLayoutControlGroup1.Location = new System.Drawing.Point(0, 0);
		this.acLayoutControlGroup1.Name = "Root";
		this.acLayoutControlGroup1.ResourceID = null;
		this.acLayoutControlGroup1.Size = new System.Drawing.Size(1258, 68);
		this.acLayoutControlGroup1.Text = "Root";
		this.acLayoutControlGroup1.TextVisible = false;
		this.acLayoutControlGroup1.ToolTipID = null;
		this.acLayoutControlGroup1.UseResourceID = false;
		this.acLayoutControlGroup1.UseToolTipID = false;
		this.acLayoutControlItem8.Control = this.acCheckedComboBoxEdit2;
		this.acLayoutControlItem8.CustomizationFormText = "acLayoutControlItem8";
		this.acLayoutControlItem8.IsHeader = false;
		this.acLayoutControlItem8.Location = new System.Drawing.Point(0, 0);
		this.acLayoutControlItem8.Name = "acLayoutControlItem8";
		this.acLayoutControlItem8.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
		this.acLayoutControlItem8.ResourceID = null;
		this.acLayoutControlItem8.Size = new System.Drawing.Size(113, 32);
		this.acLayoutControlItem8.Text = "acLayoutControlItem8";
		this.acLayoutControlItem8.TextSize = new System.Drawing.Size(0, 0);
		this.acLayoutControlItem8.TextToControlDistance = 0;
		this.acLayoutControlItem8.TextVisible = false;
		this.acLayoutControlItem8.ToolTipID = null;
		this.acLayoutControlItem8.UseResourceID = false;
		this.acLayoutControlItem8.UseToolTipID = false;
		this.emptySpaceItem2.AllowHotTrack = false;
		this.emptySpaceItem2.CustomizationFormText = "emptySpaceItem2";
		this.emptySpaceItem2.Location = new System.Drawing.Point(0, 32);
		this.emptySpaceItem2.Name = "emptySpaceItem2";
		this.emptySpaceItem2.Size = new System.Drawing.Size(1258, 36);
		this.emptySpaceItem2.Text = "emptySpaceItem2";
		this.emptySpaceItem2.TextSize = new System.Drawing.Size(0, 0);
		this.acLayoutControlItem9.Control = this.acDateEdit3;
		this.acLayoutControlItem9.CustomizationFormText = "acLayoutControlItem9";
		this.acLayoutControlItem9.IsHeader = false;
		this.acLayoutControlItem9.Location = new System.Drawing.Point(113, 0);
		this.acLayoutControlItem9.Name = "acLayoutControlItem9";
		this.acLayoutControlItem9.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
		this.acLayoutControlItem9.ResourceID = null;
		this.acLayoutControlItem9.Size = new System.Drawing.Size(119, 32);
		this.acLayoutControlItem9.Text = "acLayoutControlItem9";
		this.acLayoutControlItem9.TextSize = new System.Drawing.Size(0, 0);
		this.acLayoutControlItem9.TextToControlDistance = 0;
		this.acLayoutControlItem9.TextVisible = false;
		this.acLayoutControlItem9.ToolTipID = null;
		this.acLayoutControlItem9.UseResourceID = false;
		this.acLayoutControlItem9.UseToolTipID = false;
		this.acLayoutControlItem10.Control = this.acLabelControl2;
		this.acLayoutControlItem10.CustomizationFormText = "acLayoutControlItem10";
		this.acLayoutControlItem10.IsHeader = false;
		this.acLayoutControlItem10.Location = new System.Drawing.Point(232, 0);
		this.acLayoutControlItem10.Name = "acLayoutControlItem10";
		this.acLayoutControlItem10.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
		this.acLayoutControlItem10.ResourceID = null;
		this.acLayoutControlItem10.Size = new System.Drawing.Size(19, 32);
		this.acLayoutControlItem10.Text = "acLayoutControlItem10";
		this.acLayoutControlItem10.TextSize = new System.Drawing.Size(0, 0);
		this.acLayoutControlItem10.TextToControlDistance = 0;
		this.acLayoutControlItem10.TextVisible = false;
		this.acLayoutControlItem10.ToolTipID = null;
		this.acLayoutControlItem10.UseResourceID = false;
		this.acLayoutControlItem10.UseToolTipID = false;
		this.acLayoutControlItem11.Control = this.acDateEdit4;
		this.acLayoutControlItem11.CustomizationFormText = "acLayoutControlItem11";
		this.acLayoutControlItem11.IsHeader = false;
		this.acLayoutControlItem11.Location = new System.Drawing.Point(251, 0);
		this.acLayoutControlItem11.Name = "acLayoutControlItem11";
		this.acLayoutControlItem11.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
		this.acLayoutControlItem11.ResourceID = null;
		this.acLayoutControlItem11.Size = new System.Drawing.Size(114, 32);
		this.acLayoutControlItem11.Text = "acLayoutControlItem11";
		this.acLayoutControlItem11.TextSize = new System.Drawing.Size(0, 0);
		this.acLayoutControlItem11.TextToControlDistance = 0;
		this.acLayoutControlItem11.TextVisible = false;
		this.acLayoutControlItem11.ToolTipID = null;
		this.acLayoutControlItem11.UseResourceID = false;
		this.acLayoutControlItem11.UseToolTipID = false;
		this.emptySpaceItem4.AllowHotTrack = false;
		this.emptySpaceItem4.CustomizationFormText = "emptySpaceItem4";
		this.emptySpaceItem4.Location = new System.Drawing.Point(550, 0);
		this.emptySpaceItem4.Name = "emptySpaceItem4";
		this.emptySpaceItem4.Size = new System.Drawing.Size(708, 32);
		this.emptySpaceItem4.Text = "emptySpaceItem4";
		this.emptySpaceItem4.TextSize = new System.Drawing.Size(0, 0);
		this.acLayoutControlItem6.Control = this.acItem2;
		this.acLayoutControlItem6.CustomizationFormText = "수주";
		this.acLayoutControlItem6.IsHeader = false;
		this.acLayoutControlItem6.Location = new System.Drawing.Point(365, 0);
		this.acLayoutControlItem6.Name = "acLayoutControlItem6";
		this.acLayoutControlItem6.Padding = new DevExpress.XtraLayout.Utils.Padding(5, 5, 5, 5);
		this.acLayoutControlItem6.ResourceID = null;
		this.acLayoutControlItem6.Size = new System.Drawing.Size(185, 32);
		this.acLayoutControlItem6.Text = "수주";
		this.acLayoutControlItem6.TextSize = new System.Drawing.Size(20, 14);
		this.acLayoutControlItem6.ToolTipID = null;
		this.acLayoutControlItem6.UseResourceID = false;
		this.acLayoutControlItem6.UseToolTipID = false;
		this.acSplitContainerControl4.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acSplitContainerControl4.FixedPanel = DevExpress.XtraEditors.SplitFixedPanel.None;
		this.acSplitContainerControl4.Location = new System.Drawing.Point(0, 0);
		this.acSplitContainerControl4.Name = "acSplitContainerControl4";
		this.acSplitContainerControl4.Panel1.Controls.Add(this.acGridControl3);
		this.acSplitContainerControl4.Panel1.Text = "Panel1";
		this.acSplitContainerControl4.Panel2.Controls.Add(this.acGridControl4);
		this.acSplitContainerControl4.Panel2.Text = "Panel2";
		this.acSplitContainerControl4.ParentControl = null;
		this.acSplitContainerControl4.Size = new System.Drawing.Size(1262, 476);
		this.acSplitContainerControl4.SplitterPosition = 200;
		this.acSplitContainerControl4.TabIndex = 0;
		this.acSplitContainerControl4.Text = "acSplitContainerControl4";
		this.acGridControl3.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acGridControl3.Location = new System.Drawing.Point(0, 0);
		this.acGridControl3.MainView = this.acGridView3;
		this.acGridControl3.MenuManager = this.acBarManager1;
		this.acGridControl3.Name = "acGridControl3";
		this.acGridControl3.Size = new System.Drawing.Size(200, 476);
		this.acGridControl3.TabIndex = 0;
		this.acGridControl3.ViewCollection.AddRange(new DevExpress.XtraGrid.Views.Base.BaseView[1] { this.acGridView3 });
		this.acGridView3.ColumnPanelRowHeight = 30;
		this.acGridView3.GridControl = this.acGridControl3;
		this.acGridView3.Name = "acGridView3";
		this.acGridView3.OptionsBehavior.AutoPopulateColumns = false;
		this.acGridView3.OptionsLayout.Columns.StoreAllOptions = true;
		this.acGridView3.OptionsLayout.StoreAllOptions = true;
		this.acGridView3.OptionsView.RowAutoHeight = true;
		this.acGridView3.OptionsView.ShowGroupPanel = false;
		this.acGridView3.OptionsView.ShowIndicator = false;
		this.acGridView3.ParentControl = this;
		this.acGridView3.RowHeight = 30;
		this.acGridView3.SaveFileName = null;
		this.acGridControl4.Dock = System.Windows.Forms.DockStyle.Fill;
		this.acGridControl4.Location = new System.Drawing.Point(0, 0);
		this.acGridControl4.MainView = this.acGridView4;
		this.acGridControl4.MenuManager = this.acBarManager1;
		this.acGridControl4.Name = "acGridControl4";
		this.acGridControl4.Size = new System.Drawing.Size(1057, 476);
		this.acGridControl4.TabIndex = 0;
		this.acGridControl4.ViewCollection.AddRange(new DevExpress.XtraGrid.Views.Base.BaseView[1] { this.acGridView4 });
		this.acGridView4.ColumnPanelRowHeight = 30;
		this.acGridView4.GridControl = this.acGridControl4;
		this.acGridView4.Name = "acGridView4";
		this.acGridView4.OptionsBehavior.AutoPopulateColumns = false;
		this.acGridView4.OptionsLayout.Columns.StoreAllOptions = true;
		this.acGridView4.OptionsLayout.StoreAllOptions = true;
		this.acGridView4.OptionsView.RowAutoHeight = true;
		this.acGridView4.OptionsView.ShowGroupPanel = false;
		this.acGridView4.OptionsView.ShowIndicator = false;
		this.acGridView4.ParentControl = this;
		this.acGridView4.RowHeight = 30;
		this.acGridView4.SaveFileName = null;
		base.AutoScaleDimensions = new System.Drawing.SizeF(7f, 14f);
		base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
		base.Controls.Add(this.barDockControlLeft);
		base.Controls.Add(this.barDockControlRight);
		base.Controls.Add(this.barDockControlBottom);
		base.Controls.Add(this.barDockControlTop);
		base.Name = "ORD07A_M1A";
		base.Size = new System.Drawing.Size(1268, 671);
		base.Controls.SetChildIndex(this.barDockControlTop, 0);
		base.Controls.SetChildIndex(this.barDockControlBottom, 0);
		base.Controls.SetChildIndex(this.barDockControlRight, 0);
		base.Controls.SetChildIndex(this.barDockControlLeft, 0);
		base.Controls.SetChildIndex(base.pnlScreenBase, 0);
		((System.ComponentModel.ISupportInitialize)base.pnlScreenBase).EndInit();
		base.pnlScreenBase.ResumeLayout(false);
		((System.ComponentModel.ISupportInitialize)this.acBarManager1).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControl1).EndInit();
		this.acLayoutControl1.ResumeLayout(false);
		((System.ComponentModel.ISupportInitialize)this.acTextEdit1.Properties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acItem1.Properties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit2.Properties.VistaTimeProperties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit2.Properties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit1.Properties.VistaTimeProperties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit1.Properties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acCheckedComboBoxEdit1.Properties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.layoutControlGroup1).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem1).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem2).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem3).EndInit();
		((System.ComponentModel.ISupportInitialize)this.emptySpaceItem1).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem5).EndInit();
		((System.ComponentModel.ISupportInitialize)this.emptySpaceItem3).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem4).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem7).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acGroupControl1).EndInit();
		this.acGroupControl1.ResumeLayout(false);
		((System.ComponentModel.ISupportInitialize)this.acSplitContainerControl1).EndInit();
		this.acSplitContainerControl1.ResumeLayout(false);
		((System.ComponentModel.ISupportInitialize)this.acSplitContainerControl2).EndInit();
		this.acSplitContainerControl2.ResumeLayout(false);
		((System.ComponentModel.ISupportInitialize)this.acGridControl1).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acGridView1).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acGridControl2).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acGridView2).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acTabControl1).EndInit();
		this.acTabControl1.ResumeLayout(false);
		this.acTabPage1.ResumeLayout(false);
		this.acTabPage2.ResumeLayout(false);
		((System.ComponentModel.ISupportInitialize)this.acSplitContainerControl3).EndInit();
		this.acSplitContainerControl3.ResumeLayout(false);
		((System.ComponentModel.ISupportInitialize)this.acGroupControl2).EndInit();
		this.acGroupControl2.ResumeLayout(false);
		((System.ComponentModel.ISupportInitialize)this.acLayoutControl2).EndInit();
		this.acLayoutControl2.ResumeLayout(false);
		((System.ComponentModel.ISupportInitialize)this.acItem2.Properties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit4.Properties.VistaTimeProperties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit4.Properties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit3.Properties.VistaTimeProperties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acDateEdit3.Properties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acCheckedComboBoxEdit2.Properties).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlGroup1).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem8).EndInit();
		((System.ComponentModel.ISupportInitialize)this.emptySpaceItem2).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem9).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem10).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem11).EndInit();
		((System.ComponentModel.ISupportInitialize)this.emptySpaceItem4).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acLayoutControlItem6).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acSplitContainerControl4).EndInit();
		this.acSplitContainerControl4.ResumeLayout(false);
		((System.ComponentModel.ISupportInitialize)this.acGridControl3).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acGridView3).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acGridControl4).EndInit();
		((System.ComponentModel.ISupportInitialize)this.acGridView4).EndInit();
		base.ResumeLayout(false);
	}
}
