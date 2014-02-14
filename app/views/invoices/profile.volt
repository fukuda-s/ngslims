{{ content() }}

<div class="profile left">
  {{ form('invoices/profile', 'id': 'profileForm', 'onbeforesubmit': 'return false') }}
  <div class="clearfix">
    <label for="firstname">Your First Name:</label>

    <div class="input">
      {{ text_field("firstname", "size": "30", "class": "col-md-6") }}
      <div class="alert" id="firstname_alert">
        <strong>Warning!</strong> Please enter your first name
      </div>
    </div>
  </div>
  <div class="clearfix">
    <label for="lastname">Your Last Name:</label>

    <div class="input">
      {{ text_field("lastname", "size": "30", "class": "col-md-6") }}
      <div class="alert" id="lastname_alert">
        <strong>Warning!</strong> Please enter your last name
      </div>
    </div>
  </div>
  <div class="clearfix">
    <label for="email">Email Address:</label>

    <div class="input">
      {{ text_field("email", "size": "30", "class": "col-md-6") }}
      <div class="alert" id="email_alert">
        <strong>Warning!</strong> Please enter your email
      </div>
    </div>
  </div>
  <div class="clearfix">
    <input type="button" value="Update" class="btn btn-primary btn-large btn-info" onclick="Profile.validate()">
    &nbsp;
    {{ link_to('invoices/index', 'Cancel') }}
  </div>
  </form>
</div>