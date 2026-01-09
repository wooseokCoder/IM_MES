var jcalendar_plugin = "fullcalendar-2.1.1";
var jcalendar_abpath = getUrl("/resources/jquery/") + jcalendar_plugin;

document.write('<link rel="stylesheet" type="text/css" href="'+ jcalendar_abpath +'/lib/redmond/jquery-ui.min.css" />');
document.write('<link rel="stylesheet" type="text/css" href="'+ jcalendar_abpath +'/fullcalendar.css" />');
document.write('<script type="text/javascript" src="'+ jcalendar_abpath +'/lib/moment.min.js"></script>');
document.write('<script type="text/javascript" src="'+ jcalendar_abpath +'/fullcalendar.js"></script>');
document.write('<script type="text/javascript" src="'+ jcalendar_abpath +'/lang/ko.js"></script>');
/*
using("../" + jcalendar_plugin + "/lib/cupertino/jquery-ui.min.css");
using("../" + jcalendar_plugin + "/fullcalendar.css");
using("../" + jcalendar_plugin + "/fullcalendar.print.css");

using("../" + jcalendar_plugin + "/lib/moment.min.js");
using("../" + jcalendar_plugin + "/fullcalendar.min.js");
*/

var jcalendar = {
};
