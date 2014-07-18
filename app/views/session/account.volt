{{ content() }}

<div class="page-header">
  <h2>Account Setting</h2>
</div>

{{ form('session/account', 'id': 'accountForm', 'class': 'form-horizontal', 'onbeforesubmit': 'return false') }}
<fieldset>
  <div class="control-group">
    <label class="control-label" for="firstname">Your First Name</label>

    <div class="controls">
      {{ text_field('firstname', 'class': 'input-xlarge') }}
      <p class="help-block">(required)</p>

      <div class="alert" id="firstname_alert">
        <strong>Warning!</strong> Please enter your first name
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="lastname">Your Last Name</label>

    <div class="controls">
      {{ text_field('lastname', 'class': 'input-xlarge') }}
      <p class="help-block">(required)</p>

      <div class="alert" id="lastname_alert">
        <strong>Warning!</strong> Please enter your last name
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="email">Email Address</label>

    <div class="controls">
      {{ text_field('email', 'class': 'input-xlarge') }}
      <p class="help-block">(required)</p>

      <div class="alert" id="email_alert">
        <strong>Warning!</strong> Please enter your email
      </div>
    </div>
  </div>

  <div class="form-actions">
    {{ submit_button('Update', 'class': 'btn btn-info btn-large', 'onclick': 'return Account.validate();') }}
    &nbsp;
    {{ link_to('index/index', 'Cancel') }}
  </div>
</fieldset>
</form>
