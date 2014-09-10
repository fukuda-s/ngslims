/**
 * Validate Register. (session/register)
 * @type {{check: check, validate: validate}}
 */

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
        if (SignUp.check("newPassword") == false) {
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

/**
 * Validate Account setting. (session/register)
 * @type {{check: check, validate: validate}}
 */
var Account = {
    validate : function() {
        if (SignUp.check("firstname") == false) {
            return false;
        }
        if (SignUp.check("lastname") == false) {
            return false;
        }
        if (SignUp.check("email") == false) {
            return false;
        }
        $("#accountForm")[0].submit();
    }
};

/**
 * Validate password setting. (session/register)
 * @type {{check: check, validate: validate}}
 */
var Password = {
    validate : function() {
        if (SignUp.check("password") == false) {
            return false;
        }
        if (SignUp.check("newPassword") == false) {
            return false;
        }
        if ($("#password")[0].value != $("#repeatPassword")[0].value) {
            $("#repeatPassword")[0].focus();
            $("#repeatPassword_alert").show();

            return false;
        }
        if ($("#password")[0].value == $("#newPassword")[0].value) {
            $("#newPassword")[0].focus();
            $("#newPassword_alert").show();

            return false;
        }
        $("#passwordForm")[0].submit();
    }
};

$(document).ready(function() {
	$("#registerForm .alert").hide();
    $("#accountForm .alert").hide();
    $("#passwordForm .alert").hide();
});

/*
 * Change cheveron icon with toggle panel
 */
function toggleChevron(e) {
    $(e.target).parents(".panel").find("i.indicator")
			.toggleClass('glyphicon-chevron-down glyphicon-chevron-right');
}

$(document).ready(function() {
	$('#projectOverview').on('hidden.bs.collapse', toggleChevron);
	$('#projectOverview').on('shown.bs.collapse', toggleChevron);
});

/*
 * Tooltip
 */
$(document).ready(function() {
	$('a[rel=tooltip]').tooltip({
		container : 'body'
	});
});