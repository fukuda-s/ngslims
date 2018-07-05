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
      {{ email_field('email', 'class': 'input-xlarge') }}
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
