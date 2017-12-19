{{ content() }}

<div class="page-header">
  <h2>Password Setting</h2>
</div>

{{ form('session/password', 'id': 'passwordForm', 'class': 'form-horizontal', 'onbeforesubmit': 'return false') }}
<fieldset>
  <div class="form-group">
    <label class="col-sm-2 control-label" for="newPassword">New Password</label>

    <input type="hidden" name="<?php echo $this->security->getTokenKey() ?>"
           value="<?php echo $this->security->getToken() ?>"/>

    <div class="col-sm-3">
      {{ password_field('newPassword', 'class': 'form-control') }}
      <!--
      <p class="help-block">(minimum 8 characters)</p>
      -->
    </div>
  </div>
  <div class="form-group">
    <label class="col-sm-2 control-label" for="repeatPassword">Repeat Password</label>

    <div class="col-sm-3">
      {{ password_field('repeatPassword', 'class': 'form-control') }}
      <div class="alert" id="repeatPassword_alert">
        <strong>Warning!</strong> The password does not match
      </div>
    </div>
  </div>

  <br>
  <div class="form-actions">
    {{ submit_button('Update', 'class': 'btn btn-info btn-large', 'onclick': 'return Password.validate();') }}
    &nbsp;
    {{ link_to('index/index', 'Cancel') }}
  </div>
</fieldset>
</form>
