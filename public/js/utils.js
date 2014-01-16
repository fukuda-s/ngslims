var Profile = {
	check : function(id) {
		if ($.trim($("#" + id)[0].value) == '') {
			$("#" + id)[0].focus();
			$("#" + id + "_alert").show();

			return false;
		}
		;

		return true;
	},
	validate : function() {
		if (SignUp.check("name") == false) {
			return false;
		}
		if (SignUp.check("email") == false) {
			return false;
		}
		$("#profileForm")[0].submit();
	}
};

var SignUp = {
	check : function(id) {
		if ($.trim($("#" + id)[0].value) == '') {
			$("#" + id)[0].focus();
			$("#" + id + "_alert").show();

			return false;
		}
		;

		return true;
	},
	validate : function() {
		if (SignUp.check("name") == false) {
			return false;
		}
		if (SignUp.check("username") == false) {
			return false;
		}
		if (SignUp.check("email") == false) {
			return false;
		}
		if (SignUp.check("password") == false) {
			return false;
		}
		if ($("#password")[0].value != $("#repeatPassword")[0].value) {
			$("#repeatPassword")[0].focus();
			$("#repeatPassword_alert").show();

			return false;
		}
		$("#registerForm")[0].submit();
	}
};

$(document).ready(function() {
	$("#registerForm .alert").hide();
	$("div.profile .alert").hide();
});

/*
 * Change cheveron icon with toggle panel
 */
function toggleChevron(e) {
	$(e.target).parent().prev('.panel-heading').find("i.indicator")
			.toggleClass('glyphicon-chevron-down glyphicon-chevron-right');
}
$('#projectOverview').on('hidden.bs.collapse', toggleChevron);
$('#projectOverview').on('shown.bs.collapse', toggleChevron);

/*
 * Tooltip
 */
$(document).ready(function() {
	$('a[rel=tooltip]').tooltip({
		container : 'body'
	});
});

/*
 * DataTables
 */
$(document).ready(function() {
	$('#sampleInfo_table').dataTable({
		"sScrollY" : "400px",
		"bPaginate" : false,
		"bScrollCollapse" : true
	});
});
