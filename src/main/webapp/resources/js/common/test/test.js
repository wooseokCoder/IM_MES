var consts = {
	sysId:    gconsts.SYS_ID,
	title:    gconsts.TITLE,
	pageSize: gconsts.PAGE_SIZE,
	easygrid: false,
	url: {
		search: getUrl("/common/test/test/search.json"),
		save:   getUrl("/common/test/test/save.json")
	},
	
	init: function() {
		this.easygrid = new jeasygrid({
			url: this.url,
			gridKey:  "#search-grid",
			sformKey: "#search-form"
		});
		
		this.easygrid.init({
			fit: true,
			pageSize: this.pageSize,
			toolbar:  "#search-toolbar",
			idField:  'menuKey',
			onClickRow:   this.easygrid.clickRowEdit,
			onBeforeEdit: this.easygrid.beforeEdit,
			onAfterEdit : this.easygrid.afterEdit
		});
	}
};

$(function() {
	consts.init();
});

function doSearch() {
	consts.easygrid.search();
}

function doAppend() {
	consts.easygrid.appendEdit();
}

function doRemove() {
	consts.easygrid.removeEdit();
}

function doSave() {
	consts.easygrid.saveEdit();
}
