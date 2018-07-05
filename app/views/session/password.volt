{{ content() }}

<!--
  ~ (The MIT License)
  ~
  ~ Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining
  ~ a copy of this software and associated documentation files (the
  ~ 'Software'), to deal in the Software without restriction, including
  ~ without limitation the rights to use, copy, modify, merge, publish,
  ~ distribute, sublicense, and/or sell copies of the Software, and to
  ~ permit persons to whom the Software is furnished to do so, subject to
  ~ the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be
  ~ included in all copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  ~ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  ~ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  ~ IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  ~ CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  ~ TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  ~ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  -->

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
