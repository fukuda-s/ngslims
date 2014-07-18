{{ content() }}

<div class="page-header">
  <h2>Password Setting</h2>
</div>

{{ form('session/password', 'id': 'passwordForm', 'class': 'form-horizontal', 'onbeforesubmit': 'return false') }}
<fieldset>
  <div class="control-group">
    <label class="control-label" for="password">Password</label>

    <div class="controls">
      {{ password_field('password', 'class': 'input-xlarge') }}
      <p class="help-block">(minimum 8 characters)</p>

      <div class="alert" id="password_alert">
        <strong>Warning!</strong> Please provide a valid password
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="repeatPassword">Repeat Password</label>

    <div class="controls">
      {{ password_field('repeatPassword', 'class': 'input-xlarge') }}
      <div class="alert" id="repeatPassword_alert">
        <strong>Warning!</strong> The password does not match
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="newPassword">New Password</label>

    <div class="controls">
      {{ password_field('newPassword', 'class': 'input-xlarge') }}
      <p class="help-block">(minimum 8 characters)</p>

      <div class="alert" id="password_alert">
        <strong>Warning!</strong> The password does not change
      </div>
    </div>
  </div>

  <div class="form-actions">
    {{ submit_button('Update', 'class': 'btn btn-info btn-large', 'onclick': 'return Password.validate();') }}
    &nbsp;
    {{ link_to('index/index', 'Cancel') }}
  </div>
</fieldset>
</form>
