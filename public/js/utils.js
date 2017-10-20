/**
 * Validate Register. (session/register)
 * @type {{check: check, validate: validate}}
 */
var SignUp = {
    check: function (id) {
        if ($.trim($("#" + id)[0].value) == '') {
            $("#" + id)[0].focus();
            $("#" + id + "_alert").show();

            return false;
        }
        ;

        return true;
    },
    validate: function () {
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
    validate: function () {
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
    validate: function () {
        if (SignUp.check("newPassword") == false) {
            return false;
        }
        if ($("#newPassword")[0].value != $("#repeatPassword")[0].value) {
            $("#repeatPassword")[0].focus();
            $("#repeatPassword_alert").show();

            return false;
        }
        $("#passwordForm")[0].submit();
    }
};

$(document).ready(function () {
    $("#registerForm .alert").hide();
    $("#accountForm .alert").hide();
    $("#passwordForm .alert").hide();
});

/*
 * Change chevron icon with toggle panel
 */
function openChevron(e) {
    $(e.target).parents(".panel").find("i.indicator")
        .removeClass('glyphicon-chevron-right')
        .addClass('glyphicon-chevron-down');
}
function closeChevron(e) {
    $(e.target).parents(".panel").find("i.indicator")
        .removeClass('glyphicon-chevron-down')
        .addClass('glyphicon-chevron-right');
}

$(document).ready(function () {
    $('#projectOverview').on('hidden.bs.collapse', closeChevron);
    $('#projectOverview').on('shown.bs.collapse', openChevron);
});

/*
 * Tooltip
 */
$(document).ready(function () {
    $('a[rel=tooltip]').tooltip({
        container: 'body'
    });
});

// Read a page's GET URL variables and return them as an associative array.

$(document).ready(function () {
    $.extend({
        getUrlVars: function () {
            var vars = [], hash;
            var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
            for (var i = 0; i < hashes.length; i++) {
                hash = hashes[i].split('=');
                vars.push(hash[0]);
                vars[hash[0]] = hash[1];
            }
            return vars;
        },
        getUrlVar: function (name) {
            return $.getUrlVars()[name];
        }
    });
});
